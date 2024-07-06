import 'package:cypher/first.dart';
import 'package:cypher/second.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scouting App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Mandatory Plaything',
      ),
      home: const MyHomePage(title: 'CYPHER (FRC 6672)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  void incrementIndex() {
    setState(() => selectedIndex++);
  }

  void decrementIndex() {
    setState(() => selectedIndex--);
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedIndex) {
      case 0:
        page = First(incrementIndex: incrementIndex);
      case 1:
        page = Second(incrementIndex: incrementIndex);
      case 2:
        page = const Placeholder(child: Text('AUTONOMOUS'));
      case 3:
        page = const Placeholder(child: Text('TELEOPERATED'));
      case 4:
        page = const Placeholder(child: Text('ENDGAME'));
      case 5:
        page = const Placeholder(child: Text('NOTES'));
      case 6:
        page = const Placeholder(child: Text('SCAN QR'));
      default:
        throw UnimplementedError("Page $selectedIndex not assigned");
    }


    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
          ),
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 400,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.science_outlined), 
                      label: Text('Start')),
                    NavigationRailDestination(
                      icon: Icon(Icons.star), 
                      label: Text('Pregame')),
                    NavigationRailDestination(
                      icon: Icon(FontAwesomeIcons.robot), 
                      label: Text('Autonomous')),
                    NavigationRailDestination(
                      icon: Icon(Icons.remove_road), 
                      label: Text('Teleoperated')),
                    NavigationRailDestination(
                      icon: Icon(Icons.flag), 
                      label: Text('Endgame')),
                    NavigationRailDestination(
                      icon: Icon(Icons.edit_note), 
                      label: Text('Notes')),
                    NavigationRailDestination(
                      icon: Icon(Icons.qr_code), 
                      label: Text('QR Code')),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected:(value) => setState(() {
                    selectedIndex = value;
                  }),
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
            ),
        );
      }
    );
  }
}
