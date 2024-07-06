// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Second extends StatefulWidget {
  final VoidCallback incrementIndex;


  const Second({super.key, required this.incrementIndex});

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Mandatory Plaything'),
        home: Scaffold(
          backgroundColor: const Color.fromARGB(0, 255, 255, 0),
          body: Center(
            child:
              Column(
                children: [
                  
                  Row(
                    children: [
                      // Text("Team Number: "),
                      
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          constraints: BoxConstraints.tightFor(width: 300, height:50),
                          border: UnderlineInputBorder(),
                          labelText: "Enter Team Number"
                        ),
                      )
                    ],
                  ),
                ],
              )
          ),
        ),
      )
    );
  }
}
