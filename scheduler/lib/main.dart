import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase/firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
