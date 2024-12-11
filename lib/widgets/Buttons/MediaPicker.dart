import 'package:flutter/material.dart';

class MediaPicker extends StatelessWidget {
  final VoidCallback onPickMedia;

  const MediaPicker({Key? key, required this.onPickMedia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),        ),
      margin: EdgeInsets.symmetric(vertical: 10),        child: ElevatedButton.icon(
        onPressed: onPickMedia,
        icon: Icon(Icons.photo_camera),
        label: Text('Pick Photos/Videos'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
