import 'package:flutter/material.dart';
import 'package:kapa_app/Services/authservice.dart';

import 'Resources/colors.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    authService.context = context;
    return MaterialApp(
      title: 'Kapa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.dark(),
          accentColor: appThemeBlueMainColor,
          backgroundColor: appThemeBackgroundHexColor,
          textTheme: TextTheme(
            bodyText2: TextStyle(
              color: Colors.white,
            ),
            headline4: TextStyle(
              color: Colors.white,
            ),
          ),
      ),
      home: authService.handleAuth(),
      //home: LoginScreen(),
      /*localizationsDelegates: [
        AppLoc.delegate
      ],
      supportedLocales: AppLoc.delegate.supportedLocales,
   */
    );
  }
}

