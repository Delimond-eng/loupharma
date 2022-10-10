import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutlinedBtn extends StatelessWidget {
  final bool isActived;
  final Function onPressed;
  final String label;
  final IconData icon;
  final MaterialColor color;
  const OutlinedBtn({
    Key key,
    this.isActived,
    this.onPressed,
    this.label,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: color.shade700,
          width: .5,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 10.0,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 14.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  label,
                  style: GoogleFonts.didactGothic(
                    color: color.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
