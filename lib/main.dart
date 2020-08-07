import 'package:flutter/material.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/View/LoginPage/Login.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {

  //AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kapa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.dark(),
          textTheme: TextTheme(
            bodyText2: TextStyle(
              color: Colors.white,
            ),
            headline4: TextStyle(
              color: Colors.white,
            ),
          ),
      ),
      home: AuthService().handleAuth(),
      //home: LoginScreen(),
      /*localizationsDelegates: [
        AppLoc.delegate
      ],
      supportedLocales: AppLoc.delegate.supportedLocales,
   */
    );
  }
}

