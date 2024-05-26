###### TEDx-Load-Aggregate-Model
######

import sys
import json
import pyspark
from pyspark.sql.functions import col, collect_list, array_join,array_intersect,size,array,lit

from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

from pyspark.sql.functions import array_contains
from functools import reduce


##### FROM FILES
tedx_dataset_path = "s3://alessialazzari-data/final_list.csv"

###### READ PARAMETERS
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

##### START JOB CONTEXT AND JOB
sc = SparkContext()


glueContext = GlueContext(sc)
spark = glueContext.spark_session


    
job = Job(glueContext)
job.init(args['JOB_NAME'], args)


#### READ INPUT FILES TO CREATE AN INPUT DATASET
tedx_dataset = spark.read \
    .option("header","true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(tedx_dataset_path)
    
tedx_dataset.printSchema()


#### FILTER ITEMS WITH NULL POSTING KEY
count_items = tedx_dataset.count()
count_items_null = tedx_dataset.filter("id is not null").count()

print(f"Number of items from RAW DATA {count_items}")
print(f"Number of items from RAW DATA with NOT NULL KEY {count_items_null}")

## READ THE DETAILS
details_dataset_path = "s3://alessialazzari-data/details.csv"
details_dataset = spark.read \
    .option("header","true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(details_dataset_path)

details_dataset = details_dataset.select(col("id").alias("id_ref"),
                                         col("description"),
                                         col("duration"),
                                         col("publishedAt"))

# AND JOIN WITH THE MAIN TABLE
tedx_dataset_main = tedx_dataset.join(details_dataset, tedx_dataset.id == details_dataset.id_ref, "left") \
    .drop("id_ref") 

tedx_dataset_main.printSchema()

## READ TAGS DATASET
tags_dataset_path = "s3://alessialazzari-data/tags.csv"
tags_dataset = spark.read.option("header","true").csv(tags_dataset_path)

tags_dataset_agg = tags_dataset.groupBy("id").agg(collect_list("tag").alias("tags"))

# Filter tags_dataset_agg to retain only rows with "sleep" tag
tags_dataset_agg = tags_dataset_agg.where("array_contains(tags, 'sleep')")

# Join tedx_dataset_main with tags_dataset_agg
tedx_dataset_agg = tedx_dataset_main.join(tags_dataset_agg, tedx_dataset_main["id"] == tags_dataset_agg["id"], "left") \
                                    .drop(tags_dataset_agg["id"]) \
                                    .select(tedx_dataset_main["id"].alias("_id"), col("*")) \
                                    .drop(tedx_dataset_main["id"])

tedx_dataset_agg.printSchema()


## READ THE IMAGES (VERSIONE NUOVA)
images_dataset_path = "s3://alessialazzari-data/images.csv"
images_dataset = spark.read \
    .option("header","true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(images_dataset_path)
 
images_dataset = images_dataset.select(col("id").alias("id_ref"),
                                         col("url"))
 
# AND JOIN WITH THE MAIN TABLE
tedx_dataset_main = tedx_dataset.join(details_dataset, tedx_dataset.id == details_dataset.id_ref, "left") \
    .drop("id_ref")

#VERSIONE NUOVA DEL JOIN
tedx_dataset_main = tedx_dataset_main.join(images_dataset, tedx_dataset_main.id == images_dataset.id_ref, "left") \
    .drop("id_ref")
 
tedx_dataset_main.printSchema()

# READ AND MANAGE RELATED VIDEOS
related_videos_path= "s3://alessialazzari-data/related_videos.csv"
related_videos_dataset= spark.read.option("header","true").csv(related_videos_path)
related_videos_dataset=related_videos_dataset.dropDuplicates()

# ADD RELATED VIDEOS per ID TO AGGREGATE MODEL
related_videos_dataset_agg = related_videos_dataset.groupBy(col("id").alias("id_watch_next")).agg(collect_list("related_id").alias("WatchNext_id"), collect_list("title").alias("WatchNext_title"))

tedx_dataset_agg = tedx_dataset_agg.join (related_videos_dataset_agg,tedx_dataset_agg._id == related_videos_dataset_agg.id_watch_next,"left").drop("id_watch_next")


# FILTRAGGIO PAROLE SLEEP RELATED
filtered_dataset = tedx_dataset_agg

# FINAL FILTER BASED ON SLEEP-RELATED KEYWORDS
filtered_dataset = tedx_dataset_agg.filter(size(array_intersect(col("tags"),
array(lit("sleep"), lit("dream"), lit("meditation"), lit("bedtime"), lit("insomnia"), lit("melatonin"), lit("REM"), lit("ASMR"), lit("snore"), lit("nap"), lit("bed"), lit("bed"), lit("night")))) > 0)


# Stampa lo schema del dataset filtrato
filtered_dataset.printSchema()


write_mongo_options = {
    "connectionName": "TEDX2024",
    "database": "unibg_tedx_2024",
    "collection": "tedx-versione sonno",
    "ssl": "true",
    "ssl.domain_match": "false"}
    
    
from awsglue.dynamicframe import DynamicFrame
tedx_dataset_dynamic_frame = DynamicFrame.fromDF(filtered_dataset, glueContext, "nested")
glueContext.write_dynamic_frame.from_options(tedx_dataset_dynamic_frame, connection_type="mongodb", connection_options=write_mongo_options)