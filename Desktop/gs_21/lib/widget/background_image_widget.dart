import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  final Widget child;
  final ImageProvider image;

  const BackgroundImageWidget({
    Key? key,
    required this.image,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      buildBackground(),
      child,
    ],
  );

  Widget buildBackground() => ShaderMask(
    shaderCallback: (bounds) => LinearGradient(
      colors: [Colors.white, Colors.black],
      begin: Alignment.center,
      end: Alignment.bottomCenter,
    ).createShader(bounds),
    blendMode: BlendMode.darken,
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.2),
            BlendMode.darken,
          ),
        ),
      ),
    ),
  );
}
