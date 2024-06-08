// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/talk.dart';

Future<List<Talk>> initEmptyList() async {
  Iterable list = json.decode("[]");
  var talks = list.map((model) => Talk.fromJSON(model)).toList();
  return talks;
}

Future<List<Talk2>> initEmptyList2() async {
  Iterable list = json.decode("[]");
  var talks = list.map((model) => Talk2.fromJSON(model)).toList();
  return talks;
}

Future<List<Talk>> getTalksByTag(String tag, int page) async {
  var url = Uri.parse('https://ecp0cy67m2.execute-api.us-east-1.amazonaws.com/default/Get_Talks_By_Tag');

  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'tag': tag,
      'page': page,
      'doc_per_page': 6
    }),
  );

  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    var talks = list.map((model) => Talk.fromJSON(model)).toList();
    if (talks.isEmpty) {
      throw Exception('No talks found with tag: $tag');
    }
    return talks;
  } else {
    throw Exception('Failed to load talks');
  }
}

Future<List<Talk2>> getTalksById(String idx, int page) async {
  var url = Uri.parse(
      'https://dcu2s0sjs0.execute-api.us-east-1.amazonaws.com/default/Get_Watch_Next_by_Idx');

  try {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, Object>{
            'idx': idx,
            'page': page,
            'doc_per_page': 10}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.isNotEmpty) {
        List<Talk2> talks = jsonResponse.map((model) {
          return Talk2.fromJSON(model);
        }).toList();
        if (talks.isEmpty) {
          throw Exception('No talks found with this Id');
        }
        return talks;
        } else {
          throw Exception('Empty or invalid response');
        }
    } else {
        throw Exception('Failed to load talks: ${response.statusCode}');
      }
  } catch (e) {
    throw Exception('Id does not exist');
  }
}


Future<String> login(String mail, String password) async {
  var url = Uri.parse(
      'https://a98p6r9e0e.execute-api.us-east-1.amazonaws.com/default/LoginSD');
  var body = jsonEncode(<String, String>{
    'mail': mail,
    'password': password,
  });

  print('Sending POST request to $url');
  print('Request body: $body');

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
    if (responseBody['Message'] == 'Success') {
      return 'login successful'; // Login riuscito
    } else {
      return responseBody['Message'] ?? 'login failed'; // Errore login
    }
  } else if (response.statusCode == 404) {
    return 'Incorrect Email or Password'; // Email e/o password errati
  } else {
    return 'Server error: ${response.statusCode}'; // Server error 
  }
}


Future<String> setAutoShutdownTimer(String url) async {
  var url = Uri.parse('https://hr9iua78l8.execute-api.us-east-1.amazonaws.com/default/TimerAutoSpegnimento'); 

  var minutes;
  var body = jsonEncode(<String, dynamic>{
    'minutes': minutes,
  });

  print('Sending POST request to $url');
  print('Request body: $body');

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
    if (responseBody['success']) {
      return 'Timer set successfully'; // Timer impostato con successo
    } else {
      return responseBody['message'] ?? 'Failed to set timer'; // Errore impostazione timer
    }
  } else {
    return 'Server error: ${response.statusCode}'; // Errore del server
  }
}

