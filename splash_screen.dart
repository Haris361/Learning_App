import 'dart:async';

import 'package:flutter/material.dart';
import 'package:third_project/login_page.dart';
import 'package:third_project/register.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  void initState(){
    super.initState();

    Timer(const Duration(seconds: 3),(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Register_User()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/internee.png',
            )
          ],
        ),
      ),
    );
  }
}
