import 'package:flutter/material.dart';

import 'package:spektra/fitur/pengaturan/tema/tema_controller.dart';
import 'package:spektra/home.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TemaController _temaController = TemaController();

  @override
  void initState() {
    super.initState();
    // Memuat mode tema tersimpan sejak aplikasi dibuka.
    _temaController.muatModeTema().catchError((Object error) {
      debugPrint('Gagal memuat mode tema: $error');
    });
  }

  @override
  void dispose() {
    _temaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Colors.deepPurple;

    return AnimatedBuilder(
      animation: _temaController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: _temaController.modeTema,
          home: MyHomePage(
            title: 'Flutter Demo Home Page',
            temaController: _temaController,
          ),
        );
      },
    );
  }
}
