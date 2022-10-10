import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockDetailCard extends StatelessWidget {
  final MaterialColor color;
  final IconData icon;
  final String title;
  final String value;

  const StockDetailCard(
      {Key key, this.color, this.title, this.value, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      width: 180.0,
      margin: const EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    color.shade500,
                    color.shade900,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: color.shade50,
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.didactGothic(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    value.padLeft(2, '0'),
                    style: GoogleFonts.staatliches(
                      color: color.shade50,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      fontSize: 25.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
