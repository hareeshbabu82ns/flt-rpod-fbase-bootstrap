import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final themeModeControllerProvider =
    StateNotifierProvider<ThemeModeController, Brightness>(
  (ref) {
    return ThemeModeController(ref.read);
  },
);

class ThemeModeController extends StateNotifier<Brightness> {
  final Reader _read;

  ThemeModeController(this._read) : super(Brightness.dark);

  void toggle() {
    state = state == Brightness.light ? Brightness.dark : Brightness.light;
  }
}

// const Color m3BaseColor = Colors.red;
const Color m3BaseColor = Color(0xFF0E5BB2);

final themeColorSeedProvider = StateProvider<Color>((ref) => m3BaseColor);

final themeDataProvider = Provider<ThemeData>(
  (ref) {
    final seedColor = ref.watch(themeColorSeedProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final bgColor = themeMode == Brightness.dark
        ? HSLColor.fromColor(seedColor).withLightness(0.1).toColor()
        : null;
    final colorSchemeTmp = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: themeMode,
    );
    final colorScheme = colorSchemeTmp.copyWith(
      surface: colorSchemeTmp.inversePrimary,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // colorSchemeSeed: seedColor,
      // brightness: themeMode,
      canvasColor: bgColor,
      cardColor: bgColor,
      dialogBackgroundColor: bgColor,
    );
  },
);
