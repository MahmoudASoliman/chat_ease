import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  String? type;
  VoidCallback? ontape;
  Custombutton({super.key, this.type, this.ontape});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontape,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            type!,
            style: const TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
