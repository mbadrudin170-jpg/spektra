import 'package:flutter/material.dart';

// Definisi tes diagnostik yang ditampilkan pada grid; dipakai bersama oleh
// layar grid dan layar ringkasan agar label/ikon konsisten.
class TesDiagnostik {
  const TesDiagnostik({
    required this.id,
    required this.label,
    required this.ikon,
  });

  final String id;
  final String label;
  final IconData ikon;
}

const List<TesDiagnostik> kDaftarTes = [
  TesDiagnostik(
    id: 'warna_layar',
    label: 'Warna Layar',
    ikon: Icons.color_lens,
  ),
  TesDiagnostik(
    id: 'dead_pixel',
    label: 'Dead Pixel',
    ikon: Icons.grid_on_outlined,
  ),
  TesDiagnostik(
    id: 'multi_touch',
    label: 'Multi-Touch',
    ikon: Icons.touch_app_outlined,
  ),
  TesDiagnostik(
    id: 'kecerahan',
    label: 'Kecerahan',
    ikon: Icons.brightness_6_outlined,
  ),
  TesDiagnostik(id: 'getar', label: 'Getar', ikon: Icons.vibration),
  TesDiagnostik(
    id: 'audio_speaker',
    label: 'Audio Speaker',
    ikon: Icons.volume_up_outlined,
  ),
  TesDiagnostik(
    id: 'audio_mikrofon',
    label: 'Audio Mikrofon',
    ikon: Icons.mic_none_outlined,
  ),
  TesDiagnostik(
    id: 'senter',
    label: 'Senter',
    ikon: Icons.flashlight_on_outlined,
  ),
  TesDiagnostik(
    id: 'tombol_volume',
    label: 'Tombol Volume',
    ikon: Icons.volume_down_outlined,
  ),
];

TesDiagnostik cariTes(String id) =>
    kDaftarTes.firstWhere((tes) => tes.id == id);
