import 'package:flutter/material.dart';

class CustomTextform extends StatelessWidget {
 final String? hint;
  final Function(String)? onchanged;
 final IconButton? icon;
  final bool? obscureText;

  const CustomTextform({
    super.key,
    this.hint,
    this.onchanged,
    this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        obscureText: obscureText!,
        validator: (data) {
          if (data!.isEmpty) {
            return "Field is Required";
          }

          return null;
        },
        onChanged: onchanged,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        decoration: InputDecoration(
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            hintText: hint,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            suffix: icon),
      ),
    );
  }
}
