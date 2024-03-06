import 'package:crypto_coins_list/repositories/crypto_coins/crypto_coins.dart';
import 'package:dio/dio.dart';

class CryptoCoinsRepository implements AbstractCoinsRepository {
  CryptoCoinsRepository({required this.dio});

  final Dio dio;

  @override
  Future<List<CryptoCoin>> getCoinsList() async {
    final response = await dio.get(
      'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,BNB,SOL,DOG,AID,BOX,TRIO,WHEN&tsyms=USD'
    );

    final data = response.data as Map<String, dynamic>;
    final dataRow = data['RAW'] as Map<String, dynamic>;
    final cryptoCoinsList = dataRow.entries
    .map((e) {
      final usdValue = e.value['USD'];
      return CryptoCoin(
        name: e.key,
        priceInUSD: usdValue['PRICE'],
        imageUrl: 'https://www.cryptocompare.com${usdValue['IMAGEURL']}',
      );
    })
    .toList();

    return cryptoCoinsList;
  }
}
