import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const Color lightPrimaryColor = Color(0xFFDFECDB);
  static const Color lightOnPrimaryColor = Color(0xFF3598DB);
  static const Color lightSecondaryColor = Color(0xFFFFFFFF);
  static const Color lightOnSecondaryColor = Color(0xFF5D9CEC);
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: lightPrimaryColor,
      appBarTheme: const AppBarTheme(
          foregroundColor: lightSecondaryColor,
          backgroundColor: lightOnPrimaryColor,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 160,
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: lightOnSecondaryColor,
          foregroundColor: lightSecondaryColor,
          iconSize: 35,
          sizeConstraints: BoxConstraints(minHeight: 70, minWidth: 70),
          shape: CircleBorder(
              side: BorderSide(color: lightSecondaryColor, width: 4))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: lightOnSecondaryColor,
        unselectedItemColor: Color(0xFFC8C9CB),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: lightSecondaryColor,
        shape: CircularNotchedRectangle(),
        surfaceTintColor: null,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          dragHandleColor: lightOnPrimaryColor,
          dragHandleSize: Size(50, 10),
          backgroundColor: lightPrimaryColor),
      cardTheme: const CardTheme(
          color: lightSecondaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  const WidgetStatePropertyAll(lightOnSecondaryColor),
              foregroundColor:
                  const WidgetStatePropertyAll(lightSecondaryColor),
              padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 25, vertical: 8)),
              iconSize: const WidgetStatePropertyAll(30),
              shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(25))))),
      textTheme: TextTheme(
        titleMedium: GoogleFonts.poppins(
            color: darkOnSecondaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w700),
        bodySmall: const TextStyle(color: Colors.black, fontSize: 20),
        bodyMedium: const TextStyle(color: Colors.black, fontSize: 30),
      ),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle:
              GoogleFonts.montserrat(fontSize: 25, fontWeight: FontWeight.w400),
          hintStyle:
              GoogleFonts.montserrat(fontSize: 25, fontWeight: FontWeight.w300),
          prefixIconColor: const Color(0xFFc4c4c4),
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF6C63FF)),
              borderRadius: BorderRadius.circular(20)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(20))),
      dialogTheme: const DialogTheme(
        backgroundColor: lightPrimaryColor,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
        contentTextStyle: TextStyle(color: Colors.black, fontSize: 25),
      ),
      datePickerTheme: DatePickerThemeData(
        headerBackgroundColor: lightPrimaryColor,
        headerForegroundColor: lightOnPrimaryColor,
        yearStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: lightPrimaryColor,
        dividerColor: lightOnPrimaryColor,
        surfaceTintColor: null,
        weekdayStyle: const TextStyle(color: Colors.black, fontSize: 20),
        cancelButtonStyle: const ButtonStyle(
            textStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 25, color: Color(0xFF6C63FF)))),
        confirmButtonStyle: const ButtonStyle(
            textStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 25, color: Color(0xFF6C63FF)))),
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            } else {
              return Colors.black;
            }
          },
        ),
        yearForegroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            } else {
              return Colors.white;
            }
          },
        ),
      ),
      timePickerTheme: const TimePickerThemeData(
        dialHandColor: lightPrimaryColor,
        dialBackgroundColor: lightOnPrimaryColor,
        dialTextStyle: TextStyle(fontSize: 25, color: Colors.black),
        hourMinuteTextStyle: TextStyle(fontSize: 30, color: Colors.red),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        dayPeriodColor: lightOnPrimaryColor,
        dayPeriodTextColor: Colors.black,
        hourMinuteColor: lightOnPrimaryColor,
        hourMinuteTextColor: Colors.black,
        backgroundColor: lightPrimaryColor,
        entryModeIconColor: Colors.black,
        cancelButtonStyle: ButtonStyle(
            textStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 25, color: Color(0xFF6C63FF)))),
        confirmButtonStyle: ButtonStyle(
            textStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 25, color: Color(0xFF6C63FF)))),
      ),
      switchTheme: SwitchThemeData(trackColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return lightOnPrimaryColor;
          } else {
            return Colors.transparent;
          }
        },
      )));

  static const Color darkPrimaryColor = Color(0xFF060E1E);
  static const Color darkOnPrimaryColor = Color(0xFF3598DB);
  static const Color darkSecondaryColor = Color(0xFF141922);
  static const Color darkOnSecondaryColor = Color(0xFF5D9CEC);
  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: darkPrimaryColor,
      appBarTheme: const AppBarTheme(
          foregroundColor: darkPrimaryColor,
          backgroundColor: darkOnSecondaryColor,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 160,
          titleTextStyle: TextStyle(
              color: darkPrimaryColor,
              fontSize: 30,
              fontWeight: FontWeight.w700)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: darkOnSecondaryColor,
          foregroundColor: Colors.white,
          iconSize: 35,
          sizeConstraints: BoxConstraints(minHeight: 70, minWidth: 70),
          shape: CircleBorder(
              side: BorderSide(color: darkSecondaryColor, width: 4))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: darkOnSecondaryColor,
        unselectedItemColor: Color(0xFFC8C9CB),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: darkSecondaryColor,
        shape: CircularNotchedRectangle(),
        surfaceTintColor: null,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          dragHandleColor: darkOnPrimaryColor,
          dragHandleSize: Size(50, 10),
          backgroundColor: darkPrimaryColor),
      cardTheme: const CardTheme(
          color: darkSecondaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  const WidgetStatePropertyAll(darkOnSecondaryColor),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 25, vertical: 8)),
              iconSize: const WidgetStatePropertyAll(30),
              shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(25))))),
      textTheme: TextTheme(
        titleMedium: GoogleFonts.poppins(
            color: darkOnSecondaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w700),
        bodySmall: const TextStyle(color: Colors.white, fontSize: 20),
        bodyMedium: const TextStyle(color: Colors.white, fontSize: 30),
      ),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkSecondaryColor,
          labelStyle: GoogleFonts.montserrat(
              fontSize: 25, fontWeight: FontWeight.w400, color: Colors.white),
          hintStyle: GoogleFonts.montserrat(
              fontSize: 25, fontWeight: FontWeight.w300, color: Colors.white),
          prefixIconColor: const Color(0xFFc4c4c4),
          suffixIconColor: const Color(0xFFc4c4c4),
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF6C63FF)),
              borderRadius: BorderRadius.circular(20)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(20))),
      dialogTheme: const DialogTheme(
        backgroundColor: darkPrimaryColor,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 25),
      ),
      datePickerTheme: DatePickerThemeData(
        headerBackgroundColor: Colors.blue,
        headerForegroundColor: Colors.white,
        yearStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: darkPrimaryColor,
        dividerColor: darkOnPrimaryColor,
        surfaceTintColor: null,
        weekdayStyle: const TextStyle(color: Colors.white, fontSize: 20),
        cancelButtonStyle: const ButtonStyle(
            textStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 25, color: Color(0xFF6C63FF)))),
        confirmButtonStyle: const ButtonStyle(
            textStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 25, color: Color(0xFF6C63FF)))),
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            } else {
              return Colors.white;
            }
          },
        ),
        yearForegroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            } else {
              return Colors.white;
            }
          },
        ),
      ),
      timePickerTheme: const TimePickerThemeData(
        dialHandColor: darkPrimaryColor,
        dialBackgroundColor: darkOnPrimaryColor,
        dialTextStyle: TextStyle(fontSize: 25, color: Colors.white),
        hourMinuteTextStyle: TextStyle(fontSize: 30, color: Colors.red),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        dayPeriodColor: darkOnPrimaryColor,
        dayPeriodTextColor: Colors.white,
        hourMinuteColor: darkOnPrimaryColor,
        hourMinuteTextColor: Colors.white,
        backgroundColor: darkPrimaryColor,
        entryModeIconColor: Colors.white,
        cancelButtonStyle: ButtonStyle(
            textStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 25, color: Color(0xFF6C63FF)))),
        confirmButtonStyle: ButtonStyle(
            textStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 25, color: Color(0xFF6C63FF)))),
      ),
      switchTheme: SwitchThemeData(trackColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return darkOnPrimaryColor;
          } else {
            return Colors.transparent;
          }
        },
      )));
}
