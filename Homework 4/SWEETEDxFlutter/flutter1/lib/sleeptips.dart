import 'package:flutter/material.dart';

class SleepTipsScreen extends StatelessWidget {
  // Lista di articoli di esempio con titolo e descrizione
  final List<Map<String, String>> sleepTips = [
    {
      "title": "Mantieni una routine di sonno regolare",
      "description": "Andare a letto e svegliarsi alla stessa ora ogni giorno aiuta a regolare l'orologio biologico."
    },
    {
      "title": "Evita il consumo di caffeina prima di dormire",
      "description": "La caffeina può interferire con il sonno, quindi è meglio evitarla nelle ore serali."
    },
    {
      "title": "Crea un ambiente di sonno confortevole",
      "description": "Assicurati che la tua stanza sia buia, silenziosa e fresca per favorire un sonno migliore."
    },
    {
      "title": "Fai attività fisica durante il giorno",
      "description": "L'esercizio fisico regolare può aiutare a migliorare la qualità del sonno."
    },
    {
      "title": "Limita l'uso degli schermi prima di dormire",
      "description": "La luce blu degli schermi può disturbare il sonno, quindi cerca di evitare i dispositivi elettronici prima di coricarti."
    },
    {
      "title": "Evita pasti pesanti prima di andare a dormire",
      "description": "Consumare pasti abbondanti poco prima di coricarsi può causare disagio e disturbi del sonno."
    },
    {
      "title": "Pratica tecniche di rilassamento prima di dormire",
      "description": "Lo yoga, la meditazione o la respirazione profonda possono aiutare a ridurre lo stress e favorire il sonno."
    },
  ];

  SleepTipsScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFF3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Sleep Better Tips',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: sleepTips.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[300], 
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.bedtime, color: Color.fromARGB(255, 109, 24, 194)),
                      title: Text(
                        sleepTips[index]['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(sleepTips[index]['description']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
