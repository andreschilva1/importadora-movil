import 'package:flutter/material.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/utils/utils.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1E2036),
      body:
       Stack(
        children: [
          Image.asset(
            'Assets/portada.png',
            height: 180,
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)),
                  color: Color(0xFF1E2036)),
            ),
          ),
          Positioned(
            top: 110,
            left: 140,
            child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'Assets/logo_campos.png',
                  ),
                )),
          ),
          const Positioned(
              top: 220,
              left: 100,
              child: TextFrave(
                  text: 'Bienvenido de Nuevo',
                  fontSize: 21,
                  color: Color.fromARGB(255, 255, 255, 255))
                  ),
          Positioned(
            top: 270,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese su email';
                          }
                          return null;
                        },
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese su contraseña';
                          }
                          return null;
                        },
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(color: Colors.white),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .79,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: const Color.fromRGBO(211, 55, 69, 1)),
                    child: TextButton(
                      onPressed: authService.isLoading ? null : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          final succes = await authService.login(email, password);
                          if (succes) {
                            Navigator.pushReplacementNamed(context, 'home');
                          } else {
                            ShowAlert.displayDialog(context, 'Error de inicio de Sesion', 'Email o contraseña incorrectos', Icons.error, Colors.red);
                          }
                        }
                      },
                      child:  TextFrave(
                          text: authService.isLoading 
                                ? 'Espere...' 
                                : 'Iniciar Sesión',
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.16,
            minChildSize: 0.10,
            maxChildSize: 0.85,
            builder: (_, s) => DraggableScrollRegister(scrollController: s)
          ),
        ],
           ),
    );
  }
}
