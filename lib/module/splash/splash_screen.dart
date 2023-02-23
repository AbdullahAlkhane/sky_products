import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/constance/constants.dart';
import 'package:sky_products/module/control_panel/control_panel_screen.dart';
import 'package:sky_products/module/home/home_screen.dart';
import 'package:sky_products/uitls/app_colors.dart';

class SplashPage extends StatefulWidget {

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  Animation<double>? opacity;
  AnimationController ?controller;

  @override
  void initState() {
   
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(controller!)
      ..addListener(() {
        setState(() {});
      });
    controller!.forward().then((_) {
      navigationPage();
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void navigationPage() {
    if(uId ==null) {
      navigatorAndFinish(context, const HomeScreen());
    } else{
      navigatorAndFinish(context, const ControlPanelScreen());
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            ));
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
      ),
      child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.primaryColor,
        body: Column(
          children: <Widget>[
            Expanded(
                child: Opacity(
              opacity: opacity!.value,
              child: Image.asset('assets/images/logo.png'),
            )),
            const Padding(
              padding: EdgeInsets.all(8.0),
            )
          ],
        ),
      )),
    );
  }
}
