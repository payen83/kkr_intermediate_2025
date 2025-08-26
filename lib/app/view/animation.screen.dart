import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kkr_intermediate_2025/app/widget/appbar.widget.dart';
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
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );

    offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(3, 0))
        .animate(
          CurvedAnimation(parent: animationController, curve: Curves.elasticIn),
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
      appBar: AppBarWidget(title: 'Animation'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MatrixTransition(
              animation: animation,
              onTransform: (double value) {
                return Matrix4.identity()
                  ..setEntry(3, 2, 0.004)
                  ..rotateY(pi * 2.0 * value);
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                // child: FlutterLogo(size: 150),
                child: Text('KKR', style: TextStyle(fontSize: 50)),
              ),
            ),
            SlideTransition(
              position: offsetAnimation,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: FlutterLogo(size: 150),
              ),
            ),
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
