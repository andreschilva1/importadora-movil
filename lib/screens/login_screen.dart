import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/helpers.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/theme/app_theme.dart';
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
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_handleEmailFocusChange);
    _passwordFocusNode.addListener(_handlePasswordFocusChange);
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_handleEmailFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.removeListener(_handlePasswordFocusChange);
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleEmailFocusChange() {
    setState(() {
      _isEmailFocused = _emailFocusNode.hasFocus;
    });
  }

  void _handlePasswordFocusChange() {
    setState(() {
      _isPasswordFocused = _passwordFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
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
                  topRight: Radius.circular(40.0),
                ),
                color: AppTheme.primaryColor,
              ),
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
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          Positioned(
            top: 270,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _InputCustom(
                    errorMessagge: 'Ingrese su Email',
                    controller: _emailController,
                    labelText: 'Email',
                    focusNode: _emailFocusNode,
                  ),
                  _InputCustom(
                    errorMessagge: 'Ingrese su contraseña',
                    controller: _passwordController,
                    labelText: 'Contraseña',
                    obscureText: true,
                    focusNode: _passwordFocusNode,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .79,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(211, 55, 69, 1),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          FirebaseMessaging firebase =
                              FirebaseMessaging.instance;
                          final String? tokenDevice = await firebase.getToken();
                          final succes = await authService.login(
                            email,
                            password,
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
                      child: const TextFrave(
                          text: 'Iniciar Sesión',
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize:
                _isEmailFocused || _isPasswordFocused ? 0.0 : 0.16,
            minChildSize: _isEmailFocused || _isPasswordFocused ? 0.0 : 0.16,
            maxChildSize: _isEmailFocused || _isPasswordFocused ? 0.0 : 0.85,
            builder: (_, s) => DraggableScrollRegister(scrollController: s),
          ),
        ],
      ),
    );
  }
}

class _InputCustom extends StatelessWidget {
  final String errorMessagge;
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final FocusNode? focusNode;

  const _InputCustom({
    required this.errorMessagge,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        child: TextFormField(
          focusNode: focusNode,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          validator: (value) {
            if (value!.isEmpty) {
              return errorMessagge;
            }
            return null;
          },
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Colors.white,
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
