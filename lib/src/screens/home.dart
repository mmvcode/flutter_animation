import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;

  late Animation<double> boxAnimation;
  late AnimationController boxController;

  initState() {
    super.initState();

    // Used for both box flaps
    boxController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
        CurvedAnimation(parent: boxController, curve: Curves.easeInOut));
    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    boxController.forward();

    // Cat animation
    catController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    catAnimation = Tween(begin: -12.0, end: -90.0)
        .animate(CurvedAnimation(parent: catController, curve: Curves.easeIn));
  }

  onTap() {
    if (catAnimation.status == AnimationStatus.completed) {
      catController.reverse();
      boxController.forward();
    } else {
      catController.forward();
      boxController.stop();
    }
  }

  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Animation'),
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          child: Center(
            child: Stack(
              children: <Widget>[
                buildCatAnimation(),
                buildBox(),
                buildLeftFlap(),
                buildRightFlap()
              ],
              clipBehavior: Clip.none,
            ),
          ),
          onTap: onTap,
        ));
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        final ch = child == null
            ? Container(
                child: child,
              )
            : child; // Workaround
        return Positioned(
          child: ch,
          //margin: EdgeInsets.only(top: catAnimation.value),
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child:
          Cat(), // Only use one instance of the cat widget over and over, not
      // every second, as this may be an expensive widget (not this case)
    );
  }

  Widget buildBox() {
    return Container(
      width: 200,
      height: 200,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
          animation: boxAnimation,
          child: Container(height: 10.0, width: 125.0, color: Colors.brown),
          builder: (ctx, child) {
            return Transform.rotate(
              child: child,
              alignment: Alignment.topLeft,
              angle: boxAnimation.value,
            );
          }),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
          animation: boxAnimation,
          child: Container(height: 10.0, width: 125.0, color: Colors.brown),
          builder: (ctx, child) {
            return Transform.rotate(
              child: child,
              alignment: Alignment.topRight,
              angle: -boxAnimation.value,
            );
          }),
    );
  }
}
