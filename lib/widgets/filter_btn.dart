import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBtn extends StatelessWidget {
  final String title;
  final bool isSelected;
  final double width;
  final IconData icon;
  final double margin;
  final Function onPressed;
  const FilterBtn({
    Key key,
    this.title,
    this.isSelected = false,
    this.width,
    this.icon,
    this.margin,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: margin ?? 0.0),
      width: width,
      decoration: BoxDecoration(
        color: isSelected ? Colors.indigo : Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          width: 1.5,
          color: Colors.indigo,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 15.0,
                    color: isSelected ? Colors.white : Colors.indigo,
                  ),
                  const SizedBox(
                    width: 5.0,
                  )
                ],
                Text(
                  title,
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.indigo,
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
