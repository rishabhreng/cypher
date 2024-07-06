import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils.dart';

class Second extends StatefulWidget {
  final VoidCallback incrementIndex;

  const Second({super.key, required this.incrementIndex});

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  final _formKey = GlobalKey<FormState>();
  var isPreloaded = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Mandatory Plaything'),
      home: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(0, 255, 255, 0),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  BigTitle(title: "PREGAME"),
                  Row(
                    children: [
                      Text('Preloaded?', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 20),
                      Checkbox(
                        value: isPreloaded,
                        onChanged: (bool? value) {
                          setState(() {
                            isPreloaded = value!;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Match Number: ", style: TextStyle(fontSize: 20)),
                      SizedBox(width: 20),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.singleLineFormatter,
                          FilteringTextInputFormatter.deny(RegExp(r'^0*'))
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Invalid';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            constraints:
                                BoxConstraints.tightFor(width: 150, height: 75),
                            border: UnderlineInputBorder(),
                            labelText: "Match Number"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Team Number: ", style: TextStyle(fontSize: 20)),
                      SizedBox(width: 20),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.singleLineFormatter,
                          FilteringTextInputFormatter.deny(RegExp(r'^0*'))
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Invalid';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            constraints:
                                BoxConstraints.tightFor(width: 150, height: 75),
                            border: UnderlineInputBorder(),
                            labelText: "Team Number"),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.incrementIndex();
                        }
                      },
                      child: const Text('Next Page'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
