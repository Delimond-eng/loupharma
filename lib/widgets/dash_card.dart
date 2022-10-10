import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/controllers.dart';

class DashCard extends StatelessWidget {
  final IconData icon;
  final String title, value, currency;
  final MaterialColor color;
  const DashCard(
      {Key key, this.icon, this.title, this.value, this.currency, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: color.shade500,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (title.contains('Factures')) {
              navigatorController.navigateTo("/factures");
            }
            if (title.contains("Clients")) {
              navigatorController.navigateTo("/clients");
            }
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 60.0,
                  width: 60.0,
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
                    child: Icon(icon, color: color.shade50),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: value.padLeft(2, '0'),
                              style: GoogleFonts.staatliches(
                                color: color.shade50,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.0,
                                fontSize: 25.0,
                              ),
                            ),
                            if (currency != null) ...[
                              TextSpan(
                                text: "  $currency",
                                style: GoogleFonts.didactGothic(
                                  color: Colors.grey[200],
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
