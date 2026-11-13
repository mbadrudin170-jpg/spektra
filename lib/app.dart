import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spektra/fitur/pengaturan/tema/tema_provider.dart';
import 'package:spektra/home.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const seedColor = Colors.deepPurple;

    final modeTema = ref.watch(temaProvider).asData?.value ?? ThemeMode.system;

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
      themeMode: modeTema,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
