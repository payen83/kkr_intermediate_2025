import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kkr_intermediate_2025/app/widget/drawer.widget.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Map and Geolocation2'),
      ),
      body: Center(
        child: MatrixTransition(
          animation: animation,
          onTransform: (double value) {
            return Matrix4.identity()
              ..setEntry(3, 2, 0.004)
              ..rotateY(pi * 2.0 * value);
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            // child: FlutterLogo(size: 150),
            child: Text('KKR', style: TextStyle(fontSize: 50),),
          ),
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
