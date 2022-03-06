import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  final Function? onpressed;
  const NoConnection({this.onpressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.signal_wifi_connected_no_internet_4_outlined,
            color: Colors.black54,
            size: 100,
          ),
          TextButton(
              onPressed: () => onpressed,
              child: const Text("Retry"))
        ]);
  }
}
