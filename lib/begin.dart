import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:http/http.dart' as http;

class BeginPage extends StatelessWidget {
  final VoidCallback moveForward;

  final int eventYear = 2024;
  final String eventCode = "CURIE";

  void loadSchedule({int eventYear = 2024, String eventCode="CURIE"}) async {
    const credentials = "thepianoman:40e1597d-89f6-4dc1-9c90-3359b87ea809";
    final encodedCredentials = utf8.fuse(base64).encode(credentials);
    final matchUrl = "https://frc-api.firstinspires.org/v3.0/$eventYear/schedule/$eventCode?tournamentLevel=Qualification";
    
    final response = await http
      .get(Uri.parse(matchUrl), 
            headers: {HttpHeaders.authorizationHeader: "Basic $encodedCredentials"});

    if (response.statusCode == 200) {
      String csv = 'Match Number,Red 1,Red 2,Red 3,Blue 1,Blue 2,Blue 3\n';
      var decodedSchedule = (jsonDecode(response.body) as Map<String, dynamic>)['Schedule'];
      for (var i = 0; i < decodedSchedule.length; i++) {
        var match = decodedSchedule[i];
        csv += '${match['matchNumber']},';
        for (var j = 0; j < 6; j++) {
          csv += '${match['teams'][j]['teamNumber']},';
        }
        csv = csv.substring(0, csv.length - 1); // remove trailing comma
        csv += '\n';
      }

      File f = File('assets/schedule.csv');

      await f.writeAsString(csv.trim());
    } else {
      throw Exception('Failed to load schedule');}
  }

  const BeginPage({super.key, required this.moveForward});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(fontFamily: 'Mandatory Plaything', colorScheme: Theme.of(context).colorScheme),
      home: Scaffold(
        // backgroundColor: colors.primary,
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigTitle(title: "CYPHER"),
                const Text(
                  'FUSION CORPS',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.grey[900],
                    // foregroundColor: Colors.green
                  ),
                  onPressed: () {
                    moveForward();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'BEGIN',
                      style: TextStyle(
                        fontSize: 50,
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.grey[900],
                    // overlayColor: Colors.blue
                  ),
                  onPressed: () => loadSchedule(eventYear: eventYear, eventCode: eventCode), 
                  child: Text(
                    "Load/Open Schedule",
                    style: const TextStyle(
                        fontSize: 30,
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                SizedBox(height: 20),
                const Text(
                  'Rishabh R, FRC 6672',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
