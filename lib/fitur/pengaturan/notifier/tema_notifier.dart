import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tema_notifier.g.dart';

// Mengelola mode tema aplikasi (terang, gelap, atau mengikuti sistem) dan
// mempersistenkannya ke penyimpanan lokal.
@Riverpod(keepAlive: true)
class TemaNotifier extends _$TemaNotifier {
  static const String KUNCI_MODE_TEMA = 'kunci_mode_tema';
  static const String NILAI_TERANG = 'terang';
  static const String NILAI_GELAP = 'gelap';
  static const String NILAI_SISTEM = 'sistem';

  // Memuat mode tema tersimpan; default [ThemeMode.system] bila belum ada
  // atau gagal dibaca.
  @override
  Future<ThemeMode> build() async {
    try {
      final preferensi = await SharedPreferences.getInstance();
      return _dariNilai(preferensi.getString(KUNCI_MODE_TEMA));
    } catch (error) {
      debugPrint('Gagal memuat mode tema: $error');
      return ThemeMode.system;
    }
  }

  // Mengubah mode tema secara langsung dan menyimpannya ke penyimpanan lokal.
  Future<void> ubah(ThemeMode mode) async {
    if (state.asData?.value == mode) {
      return;
    }
    state = AsyncValue.data(mode);
    try {
      final preferensi = await SharedPreferences.getInstance();
      await preferensi.setString(KUNCI_MODE_TEMA, _keNilai(mode));
    } catch (error) {
      debugPrint('Gagal menyimpan mode tema: $error');
    }
  }

  static ThemeMode _dariNilai(String? nilai) {
    return switch (nilai) {
      NILAI_TERANG => ThemeMode.light,
      NILAI_GELAP => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static String _keNilai(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => NILAI_TERANG,
      ThemeMode.dark => NILAI_GELAP,
      ThemeMode.system => NILAI_SISTEM,
    };
  }
}
