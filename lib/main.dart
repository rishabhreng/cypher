import 'package:cypher/begin.dart';
import 'package:cypher/pregame.dart';
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
  late int _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  void moveForward() {
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut).whenComplete(() {
      setState(() => _selectedPageIndex = _pageController.page!.round());
    });
  }

  void moveBackward() {
    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut).whenComplete(() {
      setState(() => _selectedPageIndex = _pageController.page!.round());
    });
  }

  @override
  void initState() {
    super.initState();

    _selectedPageIndex = 0;
    _pages = [
      BeginPage(moveForward: () => moveForward()),
      PregamePage(incrementIndex: moveForward, decrementIndex: moveBackward),
      const Placeholder(child: Text('AUTONOMOUS')),
      const Placeholder(child: Text('TELEOPERATED')),
      const Placeholder(child: Text('ENDGAME')),
      const Placeholder(child: Text('NOTES')),
      const Placeholder(child: Text('SCAN QR')),
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: colors.tertiary,
            title: Text(widget.title,
            style: TextStyle(color: colors.onTertiary)),
          ),
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 1000,
                  indicatorColor: colors.primary,
                  backgroundColor: colors.primaryContainer,
                  selectedIndex: _selectedPageIndex,
                  selectedIconTheme: IconThemeData(color: colors.inversePrimary),
                  onDestinationSelected: (selectedPage) =>
                    _pageController.animateToPage(
                      selectedPage, 
                      duration: const Duration(milliseconds: 300), 
                      curve: Curves.easeInOut)
                      .whenComplete(() => setState(() => _selectedPageIndex = selectedPage)),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.science_outlined), 
                      label: Text('Start'),
                      ),
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
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: _pages,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
