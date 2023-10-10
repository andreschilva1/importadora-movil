import 'package:flutter/material.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';

class PerfilScreen extends StatefulWidget {
   
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer:  const SidebarDrawer(),
      appBar: AppBar(
         title: const Text('PerfilScreen'),
      ),
      body: const Center(
         child: Text('PerfilScreen'),
      ),
    );
  }
}