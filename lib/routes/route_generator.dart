import 'package:flutter/material.dart';

import 'package:task_app/routes/app_routes.dart';
import 'package:task_app/animated/fade_transition_route.dart';

import 'package:task_app/task/ui/screen/add_task_screen.dart';
import 'package:task_app/task/ui/screen/list_task_screen.dart';
import 'package:task_app/screens/splash_screen.dart';

class RouteGenerartor {
  static Route<dynamic> onGenerateRoute({RouteSettings settings}) {
    switch (settings.name) {
      case (AppRoutes.splashscreen):
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case (AppRoutes.tasks):
        return MaterialPageRoute(builder: (context) => ListTaskScreen());

      case (AppRoutes.addTask):
        final isListArguments = settings.arguments;
        final task = isListArguments is List ? isListArguments[0] : null;
        final function = isListArguments is List ? isListArguments[1] : () {};
        return FadeTransitionRoute(
            widget: AddTaskScreen(task: task, updateTaskList: function));
    }
  }

  static Route<dynamic> onUnknownRoute({RouteSettings settings}) {
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("ERROR"),
          centerTitle: true,
        ),
        body: Center(
          child: Text("Pantalla No Encontrada"),
        ),
      );
    });
  }
}
