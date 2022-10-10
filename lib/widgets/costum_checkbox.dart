import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

class CostumCheckBox extends StatelessWidget {
  final bool checked;
  final String title;
  final Function(bool checked) onChanged;

  const CostumCheckBox(
      {Key key, this.checked = false, this.onChanged, this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    return StatefulBuilder(builder: (_, setter) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(5.0),
            onTap: () {
              setter(() => isChecked = !isChecked);
              onChanged(isChecked);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 25.0,
                    width: 25.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.5),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.indigo,
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(.1),
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(2.0),
                    child: isChecked
                        ? Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.indigo,
                                  Colors.indigo[200],
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.checkmark_alt,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.didactGothic(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
