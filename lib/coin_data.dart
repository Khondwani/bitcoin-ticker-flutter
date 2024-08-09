import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  String marketDataURL = 'https://rest.coinapi.io/v1/exchangerate';
  Map<String, double> rates = {};
  Future<Map<String, double>> getCoinData(String currency) async {
    for (String crypto in cryptoList) {
      http.Response response = await http.get(
        Uri.parse('$marketDataURL/$crypto/$currency'),
        headers: {'X-CoinAPI-Key': 'your api key'},
      );
      print('$marketDataURL/$crypto/$currency');
      if (response.statusCode == 200) {
        var jsonObject = json.decode(response.body);
        rates[crypto] = jsonObject['rate'];
        print(rates[crypto]);
      } else {
        print('hello:${response.statusCode}');
      }
    }

    return rates;
  }
}
