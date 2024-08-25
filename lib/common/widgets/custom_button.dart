import 'package:flutter/material.dart';
  class CustomButton extends StatelessWidget {
    final String text;
    final VoidCallback onPressed;
    const CustomButton({super.key,
      required this.text,
      required this.onPressed});

    @override
    Widget build(BuildContext context) {
      return ElevatedButton(
        child:Text(text, style: const TextStyle(
          color: Colors.black87,
          fontSize: 21,
          fontWeight: FontWeight.w600,
        ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlueAccent,
          minimumSize: const Size(double.infinity,50),
        )
      );
    }
  }
