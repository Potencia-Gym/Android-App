import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/colors.dart';

final ThemeData myTheme = ThemeData(
  primaryColor: primaryColor,

);

final TextStyle appTitleStyle = GoogleFonts.syne(
    textStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: tertiaryColor
    )
);

final TextStyle headerTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: tertiaryColor
    )
);

final TextStyle bodyTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: tertiaryColor
    )
);

final ButtonStyle flatButtonStyle = OutlinedButton.styleFrom(
  //0xFFFBFbFB
  backgroundColor: blackColor,
  side: const BorderSide(color: primaryColor, width: 1),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  textStyle: GoogleFonts.poppins(textStyle:const TextStyle(fontSize: 16, color: primaryColor,  fontWeight: FontWeight.w500)),
);

final ButtonStyle selectedButtonStyle = OutlinedButton.styleFrom(
  //0xFFFBFbFB
  backgroundColor: primaryColor,
  side: const BorderSide(color: primaryColor, width: 1),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  textStyle: GoogleFonts.poppins(textStyle:const TextStyle(fontSize: 16, color: primaryColor,  fontWeight: FontWeight.w500)),
);

final ButtonStyle roundButtonStyle = OutlinedButton.styleFrom(
  //0xFFFBFbFB
  backgroundColor: blackColor,
  side: const BorderSide(color: primaryColor, width: 1),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
  ),
  //textStyle: GoogleFonts.poppins(textStyle:const TextStyle(fontSize: 16, color: primaryColor,  fontWeight: FontWeight.w500)),
);