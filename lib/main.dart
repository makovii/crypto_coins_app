import 'package:crypto_coins_list/firebase_options.dart';
import 'package:crypto_coins_list/theme/crypto_coins_list_app.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'repositories/crypto_coins/crypto_coins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final app = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // talker initialization
  // talker.info(app.options.projectId);

  GetIt.I.registerSingleton<AbstractCoinsRepository>(CryptoCoinsRepository(dio: Dio()));
  runApp(const CryptoCoinsListApp());
}

