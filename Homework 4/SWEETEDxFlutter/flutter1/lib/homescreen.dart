import 'package:flutter/material.dart';
import 'package:flutter1/models/talk.dart';
import 'package:flutter1/sleeptips.dart';
import 'package:flutter1/talk_repository.dart';
import 'package:flutter1/timerscreen.dart';
import 'package:flutter1/login.dart';

void main() => runApp(const HomeScreen());

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWEETEDxDreams App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const MySearchPage(),
    const LoginPage(),
    SleepTipsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tips_and_updates),
            label: 'Sleep Tips',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}

class MySearchPage extends StatefulWidget {
  const MySearchPage({super.key, this.title = 'SWEETEDxDreams'});

  final String title;

  @override
  State<MySearchPage> createState() => _MySearchPage();
}

class _MySearchPage extends State<MySearchPage> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  Future<List<Talk>>? _tagTalks;
  Future<List<Talk2>>? _idTalks;
  bool initTag = true;
  bool initId = true;

  @override
  void initState() {
    super.initState();
    _tagTalks = initEmptyList();
    _idTalks = initEmptyList2();
  }

  void _getTalksByTag() {
    setState(() {
      _tagTalks = getTalksByTag(_tagController.text, 1);
      _idTalks = initEmptyList2();
      _tagController.clear();
    });
  }

  void _getTalksById() {
    setState(() {
      _idTalks = getTalksById(_idController.text, 1);
      _tagTalks = initEmptyList();
      _idController.clear();
    });
  }

  void _getTalksBySleepTag() {
    setState(() {
      _tagTalks = getTalksByTag('sleep', 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Talks',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                hintText: 'Enter your favorite talk tag',
                labelText: 'Tag',
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _getTalksByTag,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Search by tag'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                hintText: 'Enter your last-watched talk ID',
                labelText: 'ID',
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _getTalksById,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Search by ID'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getTalksBySleepTag,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Find Talks with tag "sleep"'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<List<Talk>>(
                      future: _tagTalks,
                      builder: (context, snapshot) {
                        return _buildTalksList(snapshot);
                      },
                    ),
                    FutureBuilder<List<Talk2>>(
                      future: _idTalks,
                      builder: (context, snapshot) {
                        return _buildTalksList2(snapshot);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTalksList(AsyncSnapshot<List<Talk>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No talks found.'));
    } else {
      List<Talk> talks = snapshot.data!;
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: talks.length,
        itemBuilder: (context, index) {
          Talk talk = talks[index];
          return ListTile(
            title: Text(talk.title),
            subtitle: Text(talk.details),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimerScreen(talk: talk),
                ),
              );
            },
          );
        },
      );
    }
  }

  Widget _buildTalksList2(AsyncSnapshot<List<Talk2>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Text("${snapshot.error}");
    } else if (snapshot.hasData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var talk = snapshot.data![index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(talk.watchNextId.length, (i) {
                  return GestureDetector(
                    child: ListTile(
                      title: Text(talk.watchNextTitle[i]),
                      subtitle: Text('(ID: ${talk.watchNextId[i]})'),
                    ),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ID: ${talk.watchNextId[i]}')),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}


