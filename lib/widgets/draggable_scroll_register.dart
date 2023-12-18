import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/helpers.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/text_frave.dart';
import 'package:provider/provider.dart';

class DraggableScrollRegister extends StatelessWidget {
  final ScrollController scrollController;

  const DraggableScrollRegister({Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final formKey = GlobalKey<FormState>();
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController celular = TextEditingController();
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10.0)]),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                height: 4.0,
                width: 50,
                decoration: BoxDecoration(
                    color: const Color(0xff353759),
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
            const SizedBox(height: 30),
            const TextFrave(
                text: 'Crea una nueva Cuenta',
                fontSize: 28,
                color: Color(0xff353759),
                fontWeight: FontWeight.bold),
            const SizedBox(height: 50),
            _TextFieldCustom(
                text: 'Nombre',
                icon: Icons.person_outline_outlined,
                controller: name),
            const SizedBox(height: 30),
            _TextFieldCustom(
                text: 'E-mail', icon: Icons.email_outlined, controller: email),
            const SizedBox(height: 30),
            _TextFieldCustom(
                text: 'Contraseña',
                icon: Icons.vpn_key_outlined,
                controller: password),
            const SizedBox(height: 30),
            _TextFieldCustom(
                text: 'Celular',
                icon: Icons.phone_android_outlined,
                controller: celular),
            const SizedBox(height: 90),
            TextButton(
              child: const TextFrave(
                  text: 'Registrarse',
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  FocusScope.of(context).unfocus();
                  authService.register(
                    name.text.trim(),
                    email.text.trim(),
                    password.text.trim(),
                    celular.text.trim(),
                  );

                  FirebaseMessaging firebase = FirebaseMessaging.instance;
                  final String? tokenDevice = await firebase.getToken();
                  final succes = await authService.login(
                    email.text.trim(),
                    password.text.trim(),
                    context,
                    tokenDevice!,
                  );
                  if (succes) {
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, 'home');
                    }
                  } else {
                    if (context.mounted) {
                      displayDialog(
                          context,
                          'Error de inicio de Sesion',
                          'Email o contraseña incorrectos',
                          Icons.error,
                          Colors.red);
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldCustom extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextEditingController controller;

  const _TextFieldCustom(
      {required this.text, required this.icon, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        autocorrect: false,
        keyboardType: (text != 'Celular')
            ? TextInputType.emailAddress
            : TextInputType.number,
        decoration: InputDecoration(
            labelText: text,
            labelStyle: const TextStyle(color: Colors.black),
            suffixIcon: Icon(icon),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!))),
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingrese el $text';
          }
          return null;
        },
      ),
    );
  }
}
