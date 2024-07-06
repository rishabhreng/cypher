import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils.dart';

class PregamePage extends StatefulWidget {
  final VoidCallback incrementIndex;
  final VoidCallback decrementIndex;

  const PregamePage({super.key, required this.incrementIndex, required this.decrementIndex});

  @override
  State<PregamePage> createState() => _PregamePageState();
}

class _PregamePageState extends State<PregamePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  var isPreloaded = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Mandatory Plaything',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)),
      home: Form(
        key: _formKey,
        child: Scaffold(
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
                        // activeColor: Colors.green,
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
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.decrementIndex();
                        }
                      },
                      child: const Text('Prev Page'),
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
