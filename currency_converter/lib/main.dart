import "package:flutter/material.dart";

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

Future<Map<String, dynamic>> getData() async {
  try {
    http.Response response = await http
        .get(Uri.parse('https://api.hgbrasil.com/finance?key=5cc3883e'));

    return json.decode(response.body);
  } catch (error) {
    print(error);
    return {'Error': error};
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _dollarInputController = TextEditingController();
  final TextEditingController _euroInputController = TextEditingController();
  final TextEditingController _realIputController = TextEditingController();

  var dollarPriceToBuy;
  var euroPriceToBuy;

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double inputValue = double.parse(text);
    _dollarInputController.text =
        (inputValue / dollarPriceToBuy).toStringAsFixed(2);
    _euroInputController.text =
        (inputValue / euroPriceToBuy).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double inputValue = double.parse(text);
    _realIputController.text =
        (dollarPriceToBuy * inputValue).toStringAsFixed(2);
    _euroInputController.text =
        ((inputValue * dollarPriceToBuy) / euroPriceToBuy).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double inputValue = double.parse(text);
    _realIputController.text = (euroPriceToBuy * inputValue).toStringAsFixed(2);
    _dollarInputController.text =
        ((inputValue * euroPriceToBuy) / dollarPriceToBuy).toStringAsFixed(2);
  }

  void _clearAll() {
    _dollarInputController.text = "";
    _euroInputController.text = "";
    _realIputController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('\$ Currency converter \$'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[400],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Sorry, we can\'t get data. Try again',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            dollarPriceToBuy =
                snapshot.data?["results"]["currencies"]["USD"]["buy"];
            euroPriceToBuy =
                snapshot.data?["results"]["currencies"]["EUR"]["buy"];
            return SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/stocks.jpg'),
                    width: 300,
                    height: 250,
                  ),
                  Divider(),
                  buildTextFild(
                    'R\$ ',
                    "Reais | BRL",
                    _realIputController,
                    _realChanged,
                  ),
                  Divider(),
                  buildTextFild(
                    'US\$ ',
                    "Dollar| USD",
                    _dollarInputController,
                    _dollarChanged,
                  ),
                  Divider(),
                  buildTextFild(
                    '\€ ',
                    "Euro| EUR",
                    _euroInputController,
                    _euroChanged,
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    color: Colors.greenAccent[900],
                  ),
                  Text(
                    'Loading data...',
                    style: TextStyle(color: Colors.grey[900], fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Widget buildTextFild(String prefix, String label,
    TextEditingController inputController, handleOnChanged) {
  return TextField(
    controller: inputController,
    onChanged: handleOnChanged,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.greenAccent[900],
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.greenAccent,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.greenAccent,
          width: 1.0,
        ),
      ),
      prefixText: prefix,
    ),
  );
}
