import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Snack {
  show(String text, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          style: GoogleFonts.ubuntu(color: Colors.black),
        ),
        showCloseIcon: true,
        backgroundColor: Colors.white,
        closeIconColor: Colors.red));
  }
}
