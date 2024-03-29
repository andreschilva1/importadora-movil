import 'package:flutter/material.dart';
import 'package:projectsw2_movil/services/auth_services.dart';


mostrarLoading(BuildContext context, {String? mensaje}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text((mensaje != null) ? mensaje : 'En Progreso'),
        content: const LinearProgressIndicator(),
      ));
}

mostrarAlerta(BuildContext context, String titulo, String mensaje) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: [
              MaterialButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ));
}

showAlertDialog(BuildContext context, void Function() onPressed) async {
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget continueButton = TextButton(
    onPressed: onPressed,
    child: const Text("Eliminar"),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Eliminar campo"),
    content: const Text("Está de acuerdo en eliminar este información?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog2(BuildContext context, String text1, String text2) async {
  Widget okButton = TextButton(
    child: const Text("Ok"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(text1),
    content: Text(text2),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

ScaffoldFeatureController showBottomAlert(
    {required BuildContext context, required String message, Color? color}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
    backgroundColor: color ?? Colors.red,
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void displayDialog(BuildContext context, String title, String content,
    IconData icon, Color color) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 5,
        title: Text(title),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(content),
            const SizedBox(
              height: 10,
            ),
            Icon(
              icon,
              size: 85,
              color: color,
            ),
          ],
        ),
        actions: [
          Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  fixedSize: const Size(150, 50),
                  textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ok'),
              ),
            )
        ],
      );
    },
  );
}

showDialogCerrarSesion(BuildContext context, AuthService authService) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text('Cerrar Sesión'),
      content: const Text('¿Desea cerrar sesion?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              color: const Color(0xff353759),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: const Text('si'),
              onPressed: (){
                authService.logout();
                Navigator.pushNamed(context, 'login');
              },
            ),
            MaterialButton(
              color: const Color(0xff353759),
              textColor: Colors.white,
               shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    ),
  );
}
