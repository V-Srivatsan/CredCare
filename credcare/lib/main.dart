import 'package:flutter/material.dart';
import 'package:credcare/screens/auth/main.dart' as auth;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFF5F3F6),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black,
          fontSize: 20,
        ),

      ),
      scaffoldBackgroundColor: Color(0xFFF5F3F6),
      textTheme: TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontWeight: FontWeight.bold)
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        fillColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.fromMap({
            WidgetState.disabled: Colors.grey,
            WidgetState.any: Color(0xFF6A5B94),
          }),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        )
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF6A5B94),
        foregroundColor: Colors.white
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(15))
      )
    ),
    home: auth.Screen(),
  ));
}
