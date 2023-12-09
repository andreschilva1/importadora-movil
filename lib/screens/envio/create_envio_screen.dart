import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:projectsw2_movil/helpers/helpers.dart';
import 'package:projectsw2_movil/services/envio_service.dart';
import 'package:projectsw2_movil/services/metodo_envio_service.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CreateEnvioScreen extends StatefulWidget {
  final int paquete;
  final String peso;
  const CreateEnvioScreen({Key? key, required this.peso, required this.paquete})
      : super(key: key);

  @override
  State<CreateEnvioScreen> createState() => _CreateEnvioScreenState();
}

class _CreateEnvioScreenState extends State<CreateEnvioScreen> {
  String? metodoId;
  int total = 0;

  Map<String, dynamic>? paymentIntent;

  void makePayment(int total) async {
    try {
      paymentIntent = await createPaymentIntent(total);
      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "US",
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.dark,
        merchantDisplayName: "",
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
      debugPrint("Done");
    } catch (e) {
      debugPrint("Failde");
    }
  }

  createPaymentIntent(int total) async {
    try {

      Map<String, dynamic> body = {
        "amount": "${total}00",
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
  initState() {
    super.initState();
    Provider.of<MetodoEnvioService>(context, listen: false).fetchMetodoEnvios();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<MetodoEnvioService>(
          builder: (context, metodoService, child) {
        if (metodoService.metodoEnvios!.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                          decoration: InputDecorations.authInputDecoration(
                            hintText: 'Método',
                            labelText: 'Método de Envío',
                            prefixIcon: Icons.rule,
                          ),
                          value: metodoId,
                          onChanged: (value) {
                            setState(() {
                              metodoId = value;
                              total = int.parse(metodoService.metodoEnvios![int.parse(metodoId!) - 1].costoKg) * int.parse(widget.peso);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Debe elegir un método';
                            }
                            return null;
                          },
                          items: metodoService.metodoEnvios!.map((metodo) {
                            return DropdownMenuItem<String>(
                              value: metodo.id.toString(),
                              child: Text(
                                  "${metodo.transportista}- Costo: ${int.parse(metodo.costoKg) * int.parse(widget.peso)}bs por ${metodo.metodo}"),
                            );
                          }).toList()),
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
                              if (formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                Provider.of<EnvioService>(context,
                                        listen: false)
                                    .createEnvio(
                                        widget.paquete, metodoId!, context);
                                // makePayment(total);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      }),
    );
  }
}
