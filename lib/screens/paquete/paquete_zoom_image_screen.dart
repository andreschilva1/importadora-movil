import 'dart:io';
import 'package:flutter/material.dart';

class PaqueteZoomImageScreen extends StatelessWidget {
  final File foto;
  const PaqueteZoomImageScreen({Key? key, required this.foto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title:const  Text('Imagen del Paquete'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const  Icon(Icons.close),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                label: const Text(''),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              child: InteractiveViewer(
                maxScale: 5,
                child: Image.file(foto,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
