import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/utils.dart';

class SimpleField extends StatelessWidget {
  final TextEditingController controller;
  final String title, hintText;
  final Color iconColor;
  final Color filledColor;
  final IconData icon;
  final Function(String value) onChanged;
  final Function(String d) onChangedCurrency;
  final bool isCurrency;
  final String selectedCurrency;
  final bool isDate;
  final Function(int value) onDatePicked;

  const SimpleField({
    Key key,
    this.controller,
    this.hintText,
    this.icon,
    this.title,
    this.iconColor,
    this.filledColor,
    this.onChanged,
    this.onChangedCurrency,
    this.isCurrency = false,
    this.selectedCurrency,
    this.isDate = false,
    this.onDatePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currency = selectedCurrency ?? "USD";
    var date = DateTime.now();
    var currentDate = dateToString(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.didactGothic(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8.0),
        if (isDate) ...[
          StatefulBuilder(builder: (context, setter) {
            return Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: filledColor ?? Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1.0,
                    color: Colors.black.withOpacity(.1),
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Material(
                borderRadius: BorderRadius.circular(5.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5.0),
                  onTap: () async {
                    var s = await showDatePicked(context);

                    if (s != null) {
                      var strDate = dateToString(parseTimestampToDate(s));
                      setter(() => currentDate = strDate);
                      onDatePicked(s);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          color: iconColor ?? Colors.deepPurple,
                          size: 18.0,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: Text(
                            currentDate,
                            style: GoogleFonts.didactGothic(
                                fontWeight: FontWeight.w600, fontSize: 16.0),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.black,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ] else ...[
          Container(
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
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? Colors.deepPurple,
                    size: 18.0,
                  ),
                  Flexible(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: GoogleFonts.didactGothic(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8.0),
                        hintText: hintText,
                        hintStyle: GoogleFonts.didactGothic(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                  if (isCurrency) ...[
                    StatefulBuilder(builder: (context, setter) {
                      return SizedBox(
                        width: 70.0,
                        child: DropdownButton(
                          menuMaxHeight: 200,
                          dropdownColor: Colors.white,
                          alignment: Alignment.centerLeft,
                          borderRadius: BorderRadius.circular(5.0),
                          style: GoogleFonts.didactGothic(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          value: currency,
                          underline: const SizedBox(),
                          hint: Text(
                            "Devise",
                            style: GoogleFonts.didactGothic(
                              color: Colors.indigo,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          isExpanded: true,
                          items: ["USD", "CDF"].map((e) {
                            return DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: GoogleFonts.didactGothic(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                  color: Colors.grey[800],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            onChangedCurrency(value);
                            setter(() {
                              currency = value;
                            });
                          },
                        ),
                      );
                    })
                  ]
                ],
              ),
            ),
          ),
        ]
      ],
    );
  }
}
