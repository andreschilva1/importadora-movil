import 'package:flutter/material.dart';

class RowCustom extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String subText;
  final Widget? child;

  const RowCustom({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
    required this.subText,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: 35,
        ),
        const SizedBox(
          width: 20.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.40,
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.40,
              child: Text(
                subText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey[400],
                ),
              ),
            )
          ],
        ),
        Column(
          children: [
            child ?? const SizedBox(),
          ],
        )
      ],
    );
  }
}