import 'dart:io' show Platform;
import 'dart:ui';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedMenuItem = "USD";
  CoinData coinData = CoinData();
  Map<String, double> rates = {};
  bool isLoading;
  Map<String, double> coinRates;

  DropdownButton<String> getAndroidDropDown() {
    List<DropdownMenuItem<String>> arrayOfMenuItems = [];
    for (int x = 0; x < currenciesList.length; x++) {
      arrayOfMenuItems.add(DropdownMenuItem(
        child: Text(currenciesList[x]),
        value: currenciesList[x],
      ));
    }
    return DropdownButton(
      value: selectedMenuItem,
      items: arrayOfMenuItems,
      onChanged: (selectedValue) {
        setState(() {
          selectedMenuItem = selectedValue;
          getCurrencyRate();
        });
      },
    );
  }

  CupertinoPicker getiOSPicker() {
    List<Text> arrayOfPickerItems = [];
    for (int x = 0; x < currenciesList.length; x++) {
      arrayOfPickerItems.add(
        Text(currenciesList[x]),
      );
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedMenuItem = arrayOfPickerItems[selectedIndex].data;
        getCurrencyRate();
      },
      children: arrayOfPickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrencyRate();
  }

  void getCurrencyRate() async {
    isLoading = true;
    rates = await coinData.getCoinData(selectedMenuItem);
    isLoading = false;
    setState(() {
      coinRates = rates;
    });
  }

  List<CryptoCard> createCards() {
    List<CryptoCard> arrayOfCards = [];
    for (int x = 0; x < cryptoList.length; x++) {
      var newCard = CryptoCard(
        rate: isLoading ? '?' : coinRates[cryptoList[x]].toStringAsFixed(0),
        selectedMenuItem: this.selectedMenuItem,
        crypto: cryptoList[x],
      );
      arrayOfCards.add(newCard);
    }
    return arrayOfCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getiOSPicker() : getAndroidDropDown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  final String rate;
  final String selectedMenuItem;
  final String crypto;

  CryptoCard({this.rate, this.selectedMenuItem, this.crypto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $rate $selectedMenuItem',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
