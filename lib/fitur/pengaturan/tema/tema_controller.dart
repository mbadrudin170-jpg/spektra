import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mengelola mode tema aplikasi (terang, gelap, atau mengikuti sistem) dan
// mempersistenkannya ke penyimpanan lokal.
class TemaController extends ChangeNotifier {
  TemaController();

  static const String KUNCI_MODE_TEMA = 'kunci_mode_tema';
  static const String NILAI_TERANG = 'terang';
  static const String NILAI_GELAP = 'gelap';
  static const String NILAI_SISTEM = 'sistem';

  ThemeMode _modeTema = ThemeMode.system;

  ThemeMode get modeTema => _modeTema;

  // Memuat mode tema tersimpan; default [ThemeMode.system] bila belum ada.
  Future<void> muatModeTema() async {
    try {
      final preferensi = await SharedPreferences.getInstance();
      _modeTema = _dariNilai(preferensi.getString(KUNCI_MODE_TEMA));
      notifyListeners();
    } catch (error) {
      debugPrint('Gagal memuat mode tema: $error');
    }
  }

  // Mengubah mode tema secara langsung dan menyimpannya ke penyimpanan lokal.
  Future<void> ubahModeTema(ThemeMode mode) async {
    if (_modeTema == mode) {
      return;
    }
    _modeTema = mode;
    notifyListeners();
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
