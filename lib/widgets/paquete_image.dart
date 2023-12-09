import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projectsw2_movil/screens/paquete/paquete_zoom_image_screen.dart';


class PaqueteImage extends StatelessWidget {
  final File foto;
  const PaqueteImage({Key? key, required this.foto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Container(
          width: 370,
          height: 250,
          decoration: imageBorder(),
          child: Image.file(
            foto,
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaqueteZoomImageScreen(foto: foto,)),
        );
      },
    );
  }

  BoxDecoration imageBorder() =>
      const BoxDecoration(color: Colors.white, boxShadow: [

        BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 10)
      ]);
}
