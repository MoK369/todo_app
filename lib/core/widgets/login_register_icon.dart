import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/providers/theme_provider.dart';

class LoginRegisterIcon extends StatelessWidget {
  final String title1, title2;

  const LoginRegisterIcon(
      {super.key, required this.title1, required this.title2});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeProvider themeProvider = Provider.of(context);
    final ThemeData theme = Theme.of(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset(
            'assets/images/undraw_adventure_map.png',
            scale: 4,
            color: themeProvider.isDark() ? const Color(0xFF6C63FF) : null,
          ),
        ),
        Positioned(
            bottom: size.height * 0.02,
            child: Text(
              title1,
              style: GoogleFonts.montserrat(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodySmall!.color),
            )),
        Positioned(
          bottom: size.height * 0.005,
          child: Text(
            title2,
            style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: theme.textTheme.bodySmall!.color),
          ),
        ),
      ],
    );
  }
}
