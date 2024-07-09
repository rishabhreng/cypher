import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';

import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:http/http.dart' as http;

class BeginPage extends StatelessWidget {
  final VoidCallback moveForward;
  final VoidCallback gotoSchedulePage;

  final int eventYear = 2024;
  final String eventCode = "CURIE";

  void loadScheduleAndTeamList({int eventYear = 2024, String eventCode="CURIE"}) async {
    const credentials = "thepianoman:40e1597d-89f6-4dc1-9c90-3359b87ea809";
    final encodedCredentials = utf8.fuse(base64).encode(credentials);
    final scheduleURL = "https://frc-api.firstinspires.org/v3.0/$eventYear/schedule/$eventCode?tournamentLevel=Qualification";
    final teamListURL = "https://frc-api.firstinspires.org/v3.0/$eventYear/teams";
    var response = await http
      .get(Uri.parse(scheduleURL), 
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

    int numOfPagesInTeamList = 10;

    File f = File('assets/teamList.csv');
    for (var i = 1; i < numOfPagesInTeamList; i++) {
      var response = await http
        .get(Uri.parse("$teamListURL?page=$i"), 
            headers: {HttpHeaders.authorizationHeader: "Basic $encodedCredentials"});
      
      if (response.statusCode == 200) {
        String csv = i==1 ? 'Team Number,Team Name\n' : '';
        if (i == 1) numOfPagesInTeamList = (jsonDecode(response.body) as Map<String, dynamic>)['pageTotal'];
        var decodedTeams = (jsonDecode(response.body) as Map<String, dynamic>)['teams'];
        for (var i = 0; i < decodedTeams.length; i++) {
          var team = decodedTeams[i];
          csv += '${team['teamNumber']},"${team['nameShort']}"\n';
        }

        if (i == 1) {
          await f.writeAsString(csv);
        } else {
        await f.writeAsString(csv, mode: FileMode.append);
        }
      } else {
        throw Exception('Failed to load team list');
      }
    }
  }

  const BeginPage({super.key, required this.moveForward, required this.gotoSchedulePage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Mandatory Plaything', colorScheme: Theme.of(context).colorScheme),
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                    backgroundColor: Colors.grey[900],
                    foregroundColor: Colors.green
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    overlayColor: Colors.blue
                  ),
                  onPressed: () {
                    loadScheduleAndTeamList(eventYear: eventYear, eventCode: eventCode);
                    gotoSchedulePage();
                    }, 
                  child: Text(
                    "Load/Open Schedule",
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
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
