import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/colors.dart';

class ValueContainer extends StatelessWidget {
  String value;
  TextEditingController controller;
  ValueContainer({super.key, required this.value, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: TextField(
                textAlign: TextAlign.center,
                controller: controller,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 24, color: primaryColor)),
                cursorColor: Colors.white70,
                decoration: const InputDecoration(
                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                  //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                  focusColor: primaryColor,
                ),
              ),
            ),
            Text(
              '$value',
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: Colors.white54)),
            ),
          ],
        )
    ) ;
  }
}