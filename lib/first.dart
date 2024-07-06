import 'package:flutter/material.dart';
import 'utils.dart';

class First extends StatelessWidget {
  final VoidCallback incrementIndex;

  void loadSchedule() {
    // TODO: add functionality
  }

  const First({super.key, required this.incrementIndex});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Mandatory Plaything'),

      home: Scaffold(
        backgroundColor: const Color.fromARGB(0, 255, 255, 0),
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
                    incrementIndex();
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
                  onPressed: () => loadSchedule(), 
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
                  'Rishabh R., FRC 6672',
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
