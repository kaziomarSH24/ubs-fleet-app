import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: Theme.of(context).elevatedButtonTheme.style,
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2.5,
              ),
            )
          : text.text.xl.bold.make(),
    );
  }
}
