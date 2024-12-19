import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController Controller;
  final String hint;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.Controller,
    required this.hint,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: Controller,
      obscureText: obscureText, 
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        fillColor: Theme.of(context).colorScheme.tertiary,
        filled: true,
        focusedBorder: 
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, // Inverse primary color
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
