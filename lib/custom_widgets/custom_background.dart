import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key, required this.backgroundColor});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Container(
            color: backgroundColor,
            child: SvgPicture.asset(
              'assets/images/background.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
