import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _textStyle = TextStyle(color: Colors.green, fontSize: 25.0);
  TextEditingController _weighController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  String _infoText = "Informe seus dados!";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _weighController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _updateInfoText(String info) {
    setState(() {
      _infoText = info;
    });
  }

  void _closeKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void _resetFields() {
    _weighController.clear();
    _heightController.clear();
    setState(() {
      _updateInfoText("Informe seus dados!");
    });
    _formKey = GlobalKey<FormState>();
    _closeKeyboard();
  }

  void _calculate() {
    _closeKeyboard();

    if (!_formKey.currentState.validate()) return;

    double weight = double.parse(_weighController.text);
    double height = double.parse(_heightController.text) / 100;
    double imc = weight / (height * height);
    print(imc);

    String imcStr = imc.toStringAsPrecision(3);
    if (imc < 18.6) {
      _updateInfoText("Abaixo do peso ($imcStr)");
    } else if (imc >= 18.6 && imc < 24.9) {
      _updateInfoText("Peso ideal ($imcStr)");
    } else if (imc >= 24.9 && imc < 29.9) {
      _updateInfoText("Levemente acima do peso ($imcStr)");
    } else if (imc >= 29.9 && imc < 34.9) {
      _updateInfoText("Obesidade grau I ($imcStr)");
    } else if (imc >= 34.9 && imc < 39.9) {
      _updateInfoText("Obesidade grau II ($imcStr)");
    } else if (imc >= 39.9) {
      _updateInfoText("Obesidade grau III ($imcStr)");
    }
    _formKey.currentState.save();
  }

  String _weightValidator(String value) {
    if (value.isEmpty) return "Insira seu peso!";
    String pattern = r"^[0-9.]+$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) return "Digite apenas números.";
    return null;
  }

  String _heightValidator(String value) {
    if (value.isEmpty) return "Insira sua altura!";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora IMC"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size: 120.0,
                color: Colors.green,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Peso (Kg)",
                  labelStyle: TextStyle(color: Colors.green),
                ),
                textAlign: TextAlign.center,
                style: _textStyle,
                controller: _weighController,
                validator: _weightValidator,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Altura (cm)",
                  labelStyle: TextStyle(color: Colors.green),
                ),
                textAlign: TextAlign.center,
                style: _textStyle,
                controller: _heightController,
                validator: _heightValidator,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Calcular",
                      style: _textStyle.copyWith(color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: _calculate,
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: _textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
