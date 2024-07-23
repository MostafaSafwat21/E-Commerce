import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool hasCircularBorder;
  final color;

  const MainButton({
    super.key,
    required this.text,
    required this.onTap,
    this.hasCircularBorder = false,
    this.color = Colors.deepOrangeAccent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: hasCircularBorder
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                )
              : null,
        ),
        child: Text(
          text,
          // style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
