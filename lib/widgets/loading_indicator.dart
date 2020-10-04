import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading {
  static Widget loadingIndicators({BuildContext context}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitChasingDots(
            color: Theme.of(context).primaryColor,
            size: 80.0,
          ),
          Text(
            "Cargando...",
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w300,
                color: Colors.grey),
          )
        ],
      ),
    );
  }
}
