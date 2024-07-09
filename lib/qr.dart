import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPage extends StatefulWidget {
  final VoidCallback moveBackward;
  final VoidCallback resetAll;

  const QRPage({super.key, required this.moveBackward, required this.resetAll});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QrImageView(
            data: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            version: QrVersions.auto,
            size: 400.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: widget.moveBackward,
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: widget.resetAll,
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}