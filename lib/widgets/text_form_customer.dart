import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/input_decoration.dart';

class TextFormCustomer extends StatelessWidget {
  const TextFormCustomer({
    super.key,
    required this.controller,
    required this.type,
    required this.hintText,
    required this.labelText,
    required this.icon, required this.aviso,
  });

  final TextEditingController controller;
  final TextInputType type;
  final String hintText;
  final String labelText;
  final IconData icon;
  final String aviso;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      keyboardType: type,
      decoration: InputDecorations.authInputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: icon,
      ),
      controller: controller,
      onChanged: (value) => value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return aviso;
        }
        return null;
      },
    );
  }
}
