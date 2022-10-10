import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCard extends StatelessWidget {
  final Function onPressed;
  final bool isColored;
  const CategoryCard({
    Key key,
    this.onPressed,
    this.isColored = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    return Container(
      decoration: isColored
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: isColored == true ? Colors.white : Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  blurRadius: 10.0,
                  offset: const Offset(0, 2),
                )
              ],
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: isColored == true ? color.shade50 : Colors.transparent,
            ),
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    color: color.shade300,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isColored == true
                          ? Colors.transparent
                          : color.shade300,
                      width: .8,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/svgs/food.svg",
                      height: 30.0,
                      width: 30.0,
                      color: color.shade900,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  getRandomString(10),
                  style: GoogleFonts.didactGothic(
                    color: Colors.grey[800],
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length,
      (_) => 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz'.codeUnitAt(
          Random().nextInt(
              'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz'.length))));
}
