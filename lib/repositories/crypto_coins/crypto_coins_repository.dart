import 'package:crypto_coins_list/repositories/crypto_coins/crypto_coins.dart';
import 'package:crypto_coins_list/repositories/crypto_coins/models/crypto_coin_detail.dart';
import 'package:dio/dio.dart';

class CryptoCoinsRepository implements AbstractCoinsRepository {
  CryptoCoinsRepository({required this.dio});

  final Dio dio;

  @override
  Future<List<CryptoCoin>> getCoinsList() async {
    try {
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
    } catch(e) {
      throw e;
    }

  }

  @override
  Future<CryptoCoin> getCoinDetails(String currencyCode) async {
    final response = await dio.get(
      'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=$currencyCode&tsyms=USD'
    );

    final data = response.data as Map<String, dynamic>;
    final dataRaw = data['RAW'] as Map<String, dynamic>;
    final coinData = dataRaw[currencyCode] as Map<String, dynamic>;
    final usdData = coinData['USD'] as Map<String, dynamic>;
    final details = CryptoCoinDetail.fromJson(usdData);

    return CryptoCoin(
      name: currencyCode,
      details: details,
    );

  }
}
