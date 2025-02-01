import 'package:flutter/material.dart';

class PhotoButton extends StatelessWidget {
  const PhotoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Icon(Icons.photo, size: 43),
      ),
    );
  }
}
