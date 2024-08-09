import 'package:flutter/material.dart';

class ImageLoadError {
  Widget imageError({double? textSize}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.broken_image,
          color: Colors.grey[400],
          size: 48,
        ),
        const SizedBox(height: 8.0),
        Text(
          'Image not available',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: textSize ?? 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
