import 'package:flutter/material.dart';
import 'talk_repository.dart';
import 'models/talk.dart';

class TimerScreen extends StatefulWidget {
  final Talk talk;

  const TimerScreen({
    super.key,
    required this.talk,
  });

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _selectedInterval = 30; // Default timer interval

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Timer',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold, // Testo in grassetto
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selected Talk: ${widget.talk.title}', 
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Timer Interval:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<int>(
                value: _selectedInterval,
                items: [10, 15, 20, 25, 30].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      '$value minutes',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (int? value) {
                  setState(() {
                    _selectedInterval = value ?? 0;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Start the timer with the selected interval
                  startTimer(_selectedInterval);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Start Timer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer(int minutes) {
    // Start the timer with the selected interval
    if (minutes > 0) {
      Future.delayed(Duration(minutes: minutes), () {
        // Call the function to stop video playback
        stopVideo();
      });
    }
  }

  void stopVideo() {
    setAutoShutdownTimer(_selectedInterval.toString());
  }
}
