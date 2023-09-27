import 'package:flutter/material.dart';
import 'package:projectsw2_movil/widgets/text_frave.dart';


class DraggableScrollRegister extends StatelessWidget {
  final ScrollController scrollController;

  const DraggableScrollRegister({Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const _TextFieldCustom(text: 'Nombre', icon: Icons.person_outline_outlined),
          const SizedBox(height: 30),
          const _TextFieldCustom(text: 'E-mail', icon: Icons.email_outlined),
          const SizedBox(height: 30),
          const _TextFieldCustom(text: 'Contraseña', icon: Icons.vpn_key_outlined),
          const SizedBox(height: 90),
          TextButton(
            child: const TextFrave(
                text: 'Registrarse',
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _TextFieldCustom extends StatelessWidget {
  final String text;
  final IconData icon;

  const _TextFieldCustom({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        decoration: InputDecoration(
            labelText: text,
            labelStyle: const TextStyle(color: Colors.black),
            suffixIcon: Icon(icon),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!))),
      ),
    );
  }
}
