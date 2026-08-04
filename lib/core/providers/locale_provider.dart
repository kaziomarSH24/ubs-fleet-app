import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Defaults to English initially. 
// Later we can persist this using SharedPreferences.
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
