import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Main theme of the application
class AppThemeData {
  static  ThemeData get baseTheme {
    return ThemeData(
        primarySwatch: Colors.teal,
        errorColor: Colors.red,
        textTheme: GoogleFonts.robotoTextTheme(),

        inputDecorationTheme: AppInputTheme().theme()
    );
  }
}

class AppInputTheme {
  TextStyle _buildTextStyle(Color color, {double size = 16.0}){
    return TextStyle(
      color:color,
      fontSize: size
    );
  }

  OutlineInputBorder _buildBorder(Color color){
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        color:color,
        width: 1.0,
      ),
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
    contentPadding: const EdgeInsets.all(16),

    floatingLabelBehavior: FloatingLabelBehavior.always,
    enabledBorder: _buildBorder(Colors.grey[600]!),
    errorBorder: _buildBorder(Colors.red),
    focusedErrorBorder: _buildBorder(Colors.red),
    focusedBorder: _buildBorder(Colors.teal),
    disabledBorder: _buildBorder(Colors.grey[400]!),

    suffixStyle: _buildTextStyle(Colors.black),
    counterStyle: _buildTextStyle(Colors.grey, size:12),
    floatingLabelStyle: _buildTextStyle(Colors.black),

    errorStyle: _buildTextStyle(Colors.red, size:12),
    helperStyle: _buildTextStyle(Colors.black, size:12),
    hintStyle: _buildTextStyle(Colors.grey),
    labelStyle: _buildTextStyle(Colors.black),
    prefixStyle: _buildTextStyle(Colors.black)
  );

}
