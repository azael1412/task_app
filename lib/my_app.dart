import 'package:flutter/material.dart';

import 'package:task_app/task/bloc/task_bloc.dart';
import 'package:task_app/languages/language.dart';
import 'package:task_app/routes/app_routes.dart';
import 'package:task_app/routes/route_generator.dart';

import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => TaskBloc(),
        child: MaterialApp(
          localizationsDelegates: Language.localizationsDelegates,
          supportedLocales: Language.supportedLocales,
          title: 'Task App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: ListTaskScreen(),
          initialRoute: AppRoutes.splashscreen,
          onGenerateRoute: (settings) =>
              RouteGenerartor.onGenerateRoute(settings: settings),
          onUnknownRoute: (settings) =>
              RouteGenerartor.onUnknownRoute(settings: settings),
        ));
  }
}
