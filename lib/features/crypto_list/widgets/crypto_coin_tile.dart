import 'package:flutter/material.dart';

class CryptoCoinTile extends StatelessWidget {
  const CryptoCoinTile({
    super.key,
    required this.coinName,
    required this.coinPriceInUSD,
    required this.imageUrl,
  });

  final String coinName;
  final double coinPriceInUSD;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const int decimalPrecision = 3;
    final coinPrice = double.parse(coinPriceInUSD.toStringAsFixed(decimalPrecision));
    return ListTile(
      leading: Image.network(imageUrl),
      title: Text(
        coinName,
        style: theme.textTheme.bodyMedium,
      ),
      subtitle: Text(
        '\$$coinPrice',
        style: theme.textTheme.labelSmall,
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/coin',
          arguments: coinName,
        );
      },
    );
  }
}
