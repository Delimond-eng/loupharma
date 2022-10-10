import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Color color;
  const FilterField({
    Key key,
    this.hintText,
    this.controller,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 300.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: color ?? Colors.white.withOpacity(.8),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Colors.grey.withOpacity(.2),
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.search,
              color: Colors.deepPurple,
              size: 16.0,
            ),
            Flexible(
              child: TextField(
                style: GoogleFonts.didactGothic(fontSize: 15.0),
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(11.0),
                  hintText: hintText ?? "Recherchez le produit...",
                  hintStyle: GoogleFonts.didactGothic(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
