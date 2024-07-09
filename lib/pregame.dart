import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'utils.dart';

class PregamePage extends StatefulWidget {
  final VoidCallback moveForward;
  final VoidCallback moveBackward;

  const PregamePage(
      {super.key, required this.moveForward, required this.moveBackward});

  @override
  State<PregamePage> createState() => _PregamePageState();
}

class _PregamePageState extends State<PregamePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    loadCSV().then((value) {
      setState(() {
        teamMap = value;
      });
    });
  }

  Map<String, String> teamMap = {};

  Future<Map<String, String>> loadCSV() async {
    final data = await rootBundle.loadString("assets/teamList.csv");
    var teamList = CsvToListConverter().convert(data, eol: '\n');
    for (var entry in teamList) {
      teamMap[entry[0].toString()] = entry[1];
    }
    return teamMap;
  }

  final _formKey = GlobalKey<FormState>();
  var isPreloaded = false;
  final List alliances = ['Red', 'Blue'];

  String _selectedAlliance = '';

  var _teamName = "";

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Mandatory Plaything',
          colorScheme: Theme.of(context).colorScheme),
      home: Form(
        key: _formKey,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // BigTitle(title: 'PREGAME'),
                Align(
                    alignment: Alignment.topLeft,
                    child: BigTitle(title: "PREGAME")),
                // SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('Preloaded?',
                                  style: TextStyle(fontSize: 20)),
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
                              Text("Match Number: ",
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(width: 20),
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'^0*'))
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    constraints: BoxConstraints.tightFor(
                                        width: 150, height: 75),
                                    border: UnderlineInputBorder(),
                                    labelText: "Match Number"),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("Team Number: ",
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 20),
                                  TextFormField(
                                    onChanged: (value) => setState(() {
                                      _teamName = teamMap[value] ?? "";
                                    }),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                      FilteringTextInputFormatter
                                          .singleLineFormatter,
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'^0*'))
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Invalid';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        constraints: BoxConstraints.tightFor(
                                            width: 150, height: 75),
                                        border: UnderlineInputBorder(),
                                        labelText: "Team Number"),
                                  ),
                                  SizedBox(width: 20),
                                  Text(_teamName),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Alliance: ',
                                  style: TextStyle(fontSize: 20)),
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: alliances.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                        title: Text('${alliances[index]}'),
                                        leading: Radio<String>(
                                          value: alliances[index]
                                              .toString()
                                              .substring(0, 1)
                                              .toLowerCase(),
                                          groupValue: _selectedAlliance,
                                          activeColor: alliances[index] == 'Red'
                                              ? Colors.red
                                              : Colors.blue,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedAlliance = value!;
                                            });
                                          },
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                              _selectedAlliance == 'r'
                                  ? 'assets/2024-field-red.png'
                                  : 'assets/2024-field-blue.png',
                              height: 400,
                              width: 300,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              filterQuality: FilterQuality.low,
                              cacheHeight: 500,
                              cacheWidth: 500,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text('Error loading image'),
                              semanticLabel: '2024 Field Image',
                              excludeFromSemantics: true,
                              key: Key('fieldImageKey'))
                        ],
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 100,
                    child: FloatingActionButton(
                      elevation: 10,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.moveForward();
                        }
                      },
                      child: const Text('Next Page'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: 100,
                    child: FloatingActionButton(
                      elevation: 10,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.moveBackward();
                        }
                      },
                      child: const Text('Prev Page'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
