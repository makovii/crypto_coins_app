import 'package:crypto_coins_list/firebase_options.dart';
import 'package:crypto_coins_list/repositories/crypto_coins/models/crypto_coin_detail.dart';
import 'package:crypto_coins_list/theme/crypto_coins_list_app.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'repositories/crypto_coins/crypto_coins.dart';

void main() async {
  const cryptoCoinsBoxName = 'crypto_coins_box';

  WidgetsFlutterBinding.ensureInitialized();

  final app = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // talker initialization
  // talker.info(app.options.projectId);

  await Hive.initFlutter();
  Hive.registerAdapter(CryptoCoinAdapter());
  Hive.registerAdapter(CryptoCoinDetailAdapter());

  final cryptoCoinsBox = await Hive.openBox<CryptoCoin>(cryptoCoinsBoxName);

  GetIt.I.registerLazySingleton<AbstractCoinsRepository>(
    () => CryptoCoinsRepository(
      dio: Dio(),
      cryptoCoinsBox: cryptoCoinsBox,
    )
  );

  runApp(const CryptoCoinsListApp());
}

