import 'package:flutter/material.dart';

class Ruta {
  final String route;
  final Widget screen;
  final IconData icon;
  final String name;  
  Ruta({
    required this.route, 
    required this.screen, 
    required this.icon, 
    required this.name
    });
}