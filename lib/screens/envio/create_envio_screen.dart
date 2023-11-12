import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:projectsw2_movil/models/metodo_envio.dart';
import 'package:projectsw2_movil/services/envio_service.dart';
import 'package:projectsw2_movil/services/metodo_envio_service.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CreateEnvioScreen extends StatefulWidget {
  final int paquete;
  final String peso;
  const CreateEnvioScreen({Key? key, required this.peso, required this.paquete}) : super(key: key);

  @override
  State<CreateEnvioScreen> createState() => _CreateEnvioScreenState();
}

class _CreateEnvioScreenState extends State<CreateEnvioScreen> {
  List<DropdownMenuItem<int>> _menuItems = [];

  List<MetodoEnvio> _metodo = [];
  int _value = 1;

  Map<String, dynamic>? paymentIntent;

  void makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();
      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "US",
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.dark,
        merchantDisplayName: "Sabir",
        googlePay: gpay,
      ));

      await displayPaymentSheet();
    } catch (e) {
      Exception(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Done");
    } catch (e) {
      print("Failde");
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "1000",
        "currency": "USD",
      };

      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51O7Ie0AY23p6KhXHMB1cn0MvftzATjcs36rNJBC75b2joKuBvJM3HDdYSpZvkGgcGB922gHNLkklW7OYoCMuKgje00Oac710XJ",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final metodo = Provider.of<MetodoEnvioService>(context);

    if (_metodo.isEmpty) {
      metodo.fetchMetodoEnvios();

      setState(() {
        _metodo = metodo.metodoEnvios!;

        _menuItems = List.generate(
          _metodo.length,
          (i) => DropdownMenuItem(
            value: _metodo[i].id,
            child: Text(
                "${_metodo[i].transportista} - Costo: ${_metodo[i].costoKg} bs por ${_metodo[i].metodo}"),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Método del envío',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<int>(
                  isExpanded: true,
                  items: _menuItems,
                  value: _value,
                  onChanged: (value) => setState(() {
                    _value = value!;
                  }),
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      disabledColor: Colors.grey,
                      elevation: 0,
                      color: Colors.black,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 15),
                          child: const Text('Crear',
                              style: TextStyle(color: Colors.white))),
                      onPressed: () {
                        Provider.of<EnvioService>(context, listen: false).createEnvio(widget.paquete, _value, context);
                        makePayment();
                      }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
