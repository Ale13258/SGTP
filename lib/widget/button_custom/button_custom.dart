import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonCustom extends StatelessWidget {
  final String name;
  final bool colorEs;
  final String? router;
  const ButtonCustom(
      {super.key, required this.name, this.colorEs = false, this.router = ''});

  @override
  Widget build(BuildContext context) {
    final color = colorEs ? Colors.black : Colors.white;
    return Material(
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        color: Color.fromARGB(255, 174, 141, 62),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      color: color,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 167,
          minHeight: 52,
        ),
        child: InkWell(
          onTap: () {
            context.push(router.toString());
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(name),
            ),
          ),
        ),
      ),
    );
  }
}
