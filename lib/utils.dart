import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  final String title;
  const Title({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image(image: AssetImage('assets/FusionCorpsLogo.png')),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
  }
}