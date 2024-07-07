import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';



class SchedulePage extends StatefulWidget {
  final VoidCallback moveBackward;

  const SchedulePage({super.key, required this.moveBackward});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    loadCSV().then((value) {
      setState(() {
        csvData = value;
      });
    });
  }
  @override
  bool get wantKeepAlive => true;

  List<List<dynamic>>? csvData;

  Future<List<List<dynamic>>> loadCSV() async {
      final data = await rootBundle.loadString("assets/schedule.csv");
      csvData = CsvToListConverter().convert(data, eol: "\n");
      return csvData!;
  }

  var teamNumToSearch = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 50,
        width: 150,
        child: FloatingActionButton(
          isExtended: true,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          onPressed: () => widget.moveBackward(),
          child: Text('Back to Pregame', ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: csvData == null
                ? LinearProgressIndicator(minHeight: 10)
                : DataTable(
                    dataRowColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
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
                Form(
                  key: GlobalKey<FormState>(),
                  child: TextFormField(
                    // TODO: Implement search functionality
                    onChanged: (value) => setState(() => teamNumToSearch = value),
                    inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.singleLineFormatter,
                          FilteringTextInputFormatter.deny(RegExp(r'^0*'))
                        ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Team Number',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}