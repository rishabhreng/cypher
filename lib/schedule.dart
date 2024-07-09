import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class SchedulePage extends StatefulWidget {

  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    loadCSV().then((value) {
      setState(() {
        csvData = value;
      });
    });
  }

  List<List<dynamic>>? csvData;

  Future<List<List<dynamic>>> loadCSV() async {
    final data = await rootBundle.loadString("assets/schedule.csv");
    csvData = CsvToListConverter().convert(data, eol: "\n");
    return csvData!;
  }

  var matches = {};

  void _filterMatches(String teamNumber) {
    matches = {};
    for (var i = 1; i < csvData!.length; i++) {
      for (var j = 1; j < csvData![i].length; j++) {
        if (csvData![i][j].toString() == teamNumber) {
          matches[csvData![i][0]] = csvData![0][j];
        }
      }
    }
    setState(() {}); // Trigger UI update
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Mandatory Plaything', colorScheme: Theme.of(context).colorScheme),
      home: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: csvData == null
                    ? LinearProgressIndicator(minHeight: 10)
                    : DataTable(
                        dataRowColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
                        headingRowColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiaryContainer),
                        headingTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer),
                        dataTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                        columns: List<DataColumn>.generate(
                          csvData![0].length,
                          (index) => DataColumn(label: Text(csvData![0][index].toString())),
                        ),
                        rows: List<DataRow>.generate(
                          csvData!.length - 1,
                          (index) => DataRow(
                            cells: List<DataCell>.generate(
                              csvData![index + 1].length,
                              (index2) => DataCell(Text(csvData![index + 1][index2].toString())),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Search for Team Number:"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        _filterMatches(value);
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(5),
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.singleLineFormatter,
                        FilteringTextInputFormatter.deny(RegExp(r'^0*')),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Team Number',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            tileColor: Theme.of(context).colorScheme.primaryContainer,
                            title: Text('Match ${matches.keys.elementAt(index)}'),
                            subtitle: Text('Position: ${matches.values.elementAt(index)}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
