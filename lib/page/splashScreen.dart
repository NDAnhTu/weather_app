import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:test_2/page/homePage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.amber,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSplashScreen(
              splash: Container(
                //color: Colors.amber,
                child: Image.asset('assets/images/icon.png'),
              ),
              duration: 1000,
              splashTransition: SplashTransition.fadeTransition,
              splashIconSize: 150,
              pageTransitionType: PageTransitionType.bottomToTop,
              nextScreen: HomeScreen(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 60,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
