import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterDrop extends StatelessWidget {
  final List<String> data;
  final String hintText;
  final IconData icon;
  final Function(String value) onChanged;
  const FilterDrop(
      {Key key, this.data, this.hintText, this.onChanged, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedValue;
    return Container(
      width: 140.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          width: 1.5,
          color: Colors.indigo,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: StatefulBuilder(builder: (context, setter) {
          return Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 15.0,
                  color: Colors.indigo,
                ),
                const SizedBox(
                  width: 5.0,
                )
              ],
              Flexible(
                child: DropdownButton(
                  menuMaxHeight: 200,
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
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
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
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
