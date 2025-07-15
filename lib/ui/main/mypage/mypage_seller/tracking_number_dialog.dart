import 'package:flutter/material.dart';

class TrackingNumberDialog extends StatefulWidget {
  const TrackingNumberDialog({super.key});

  @override
  State<TrackingNumberDialog> createState() => _TrackingNumberDialogState();
}

class _TrackingNumberDialogState extends State<TrackingNumberDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('송장 번호 입력'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: '송장 번호를 입력하세요'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            final trackingNumber = _controller.text.trim();
            if (trackingNumber.isNotEmpty) {
              Navigator.pop(context, trackingNumber);
            }
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}