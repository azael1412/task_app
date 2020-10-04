import 'package:flutter/material.dart';
import 'package:task_app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1000),
      () => Navigator.of(context).pushReplacementNamed(AppRoutes.tasks),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(
        "Splash Screen",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w200),
      ),
    ) /*SafeArea(
        child: Column(
          children: <Widget>[
            Spacer(),
            Center(
              child: FractionallySizedBox(
                widthFactor: .6,
                child: FlutterLogo(size: 400),
              ),
            ),
            Spacer(),
            CircularProgressIndicator(),
            Spacer(),
            Text('Bienvenido/Welcome')
          ],
        ),
      ),*/
        );
  }
}
