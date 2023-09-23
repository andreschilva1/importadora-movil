import 'package:flutter/material.dart';

class ShowAlert {
    static void displayDialog(BuildContext context, String title, String content, IconData icon, Color color) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 5,
          title: Text(title),
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content),
              const SizedBox(height: 10,),
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
                    fixedSize: const Size(100, 50),
                    textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ok')),
            )
          ],
        );
      },
    );
  }
}