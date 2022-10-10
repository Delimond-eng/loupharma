import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropField extends StatelessWidget {
  final Color filledColor, iconColor;
  final IconData icon;
  final List<String> data;
  final String hintText;
  final Function(String value) onChanged;

  const DropField(
      {Key key,
      this.filledColor,
      this.iconColor,
      this.icon,
      this.data,
      this.onChanged,
      this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedValue;
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: filledColor ?? Colors.grey[300],
        boxShadow: [
          BoxShadow(
            blurRadius: 1.0,
            color: Colors.black.withOpacity(.1),
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: iconColor ?? Colors.deepPurple,
              size: 18.0,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Flexible(
              child: StatefulBuilder(builder: (context, setter) {
                return DropdownButton(
                  menuMaxHeight: 300,
                  dropdownColor: Colors.white,
                  alignment: Alignment.centerLeft,
                  borderRadius: BorderRadius.circular(5.0),
                  style: GoogleFonts.didactGothic(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  value: selectedValue,
                  underline: const SizedBox(),
                  hint: Text(
                    hintText,
                    style: GoogleFonts.didactGothic(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  isExpanded: true,
                  items: data.map((e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        style: GoogleFonts.didactGothic(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    onChanged(value);
                    setter(() {
                      selectedValue = value;
                    });
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
