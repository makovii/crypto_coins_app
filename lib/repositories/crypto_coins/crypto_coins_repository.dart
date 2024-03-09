import 'package:crypto_coins_list/repositories/crypto_coins/crypto_coins.dart';
import 'package:crypto_coins_list/repositories/crypto_coins/models/crypto_coin_detail.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CryptoCoinsRepository implements AbstractCoinsRepository {
  CryptoCoinsRepository({
      required this.dio,
      required this.cryptoCoinsBox,
    });

  final Dio dio;
  final Box<CryptoCoin> cryptoCoinsBox;

  @override
  Future<List<CryptoCoin>> getCoinsList() async {
    var cryptoCoinsList = <CryptoCoin>[];
    try {
      cryptoCoinsList = await _getCoinsListFromApi();

      final cryptoCoinsMap = { for(var e in cryptoCoinsList) e.name: e };

      cryptoCoinsBox.putAll(cryptoCoinsMap);   
    } catch(e) {
      cryptoCoinsList = cryptoCoinsBox.values.toList();
    }

    cryptoCoinsList.sort((a, b) => b.details.priceInUSD.compareTo(a.details.priceInUSD));
    return cryptoCoinsList;
  }

  Future<List<CryptoCoin>> _getCoinsListFromApi() async {
    final response = await dio.get(
      'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,BNB,SOL,DOG,AID,BOX,TRIO,WHEN&tsyms=USD'
    );
    
    final data = response.data as Map<String, dynamic>;
    final dataRow = data['RAW'] as Map<String, dynamic>;
    final cryptoCoinsList = dataRow.entries
    .map((e) {
      final usdValue = e.value['USD'];
      final details = CryptoCoinDetail.fromJson(usdValue);
    
      return CryptoCoin(
        name: e.key,
        details: details,
      );
    })
    .toList();
    return cryptoCoinsList;
  }

  @override
  Future<CryptoCoin> getCoinDetails(String currencyCode) async {
    try {
      final coin = await _getCoinDetailsFromApi(currencyCode);
      await cryptoCoinsBox.put(currencyCode, coin);
      return coin;
    } catch(e) {
      return cryptoCoinsBox.get(currencyCode)!;
    }
  }

  Future<CryptoCoin> _getCoinDetailsFromApi(String currencyCode) async {
    final response = await dio.get(
      'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=$currencyCode&tsyms=USD'
    );
    
    final data = response.data as Map<String, dynamic>;
    final dataRaw = data['RAW'] as Map<String, dynamic>;
    final coinData = dataRaw[currencyCode] as Map<String, dynamic>;
    final usdData = coinData['USD'] as Map<String, dynamic>;
    final details = CryptoCoinDetail.fromJson(usdData);
    return CryptoCoin(name: currencyCode, details: details);
  }
}
