import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:spektra/fitur/diagnostik/screens/diagnostik_screen.dart';
import 'package:spektra/fitur/pengaturan/screens/pengaturan_screen.dart';
import 'package:spektra/fitur/statistik/screens/statistik_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _pilihTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _bukaDiagnostik() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const DiagnostikScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Center(
            // Center is a layout widget. It takes a single child and positions
            // it in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children
              // and arranges them vertically. By default, it sizes itself to
              // fit its children horizontally, and tries to be as tall as its
              // parent.
              //
              // Column has various properties to control how it sizes itself
              // and how it positions its children. Here we use
              // mainAxisAlignment to center the children vertically; the main
              // axis here is the vertical axis because Columns are vertical
              // (the cross axis would be horizontal).
              //
              // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug
              // Paint" action in the IDE, or press "p" in the console), to see
              // the wireframe for each widget.
              mainAxisAlignment: .center,
              spacing: 16,
              children: [
                const Text('You have pushed the button this many times:'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                FilledButton.icon(
                  onPressed: _bukaDiagnostik,
                  icon: const Icon(Icons.health_and_safety_outlined),
                  label: const Text('Tes Diagnostik'),
                ),
              ],
            ),
          ),
          const _PlaceholderTab(label: 'Biodata'),
          const _PlaceholderTab(label: 'Impian'),
          const StatistikScreen(),
          const PengaturanScreen(),
        ],
      ),
      // FAB counter hanya relevan pada tab Dashboard.
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _pilihTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(CupertinoIcons.home),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.person),
            label: 'Biodata',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.star),
            label: 'Impian',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.chart_bar_alt_fill),
            label: 'Statistik',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.ellipsis),
            label: 'Lainnya',
          ),
        ],
      ),
    );
  }
}

// Placeholder sementara untuk tab yang fiturnya belum tersedia di spektra.
class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$label — belum tersedia',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
