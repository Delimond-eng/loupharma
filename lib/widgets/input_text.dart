import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class InputText extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyType;
  final String title;
  final bool isPassword;
  final String errorText;
  final Widget suffixChild;

  const InputText({
    Key key,
    this.controller,
    this.hintText,
    this.icon,
    this.keyType,
    this.title,
    this.isPassword = false,
    this.errorText,
    this.suffixChild,
  }) : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return (widget.keyType != TextInputType.datetime) && (!widget.isPassword)
        ? TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return widget.errorText;
              } else {
                return null;
              }
            },
            controller: widget.controller,
            keyboardType: widget.keyType ?? TextInputType.text,
            decoration: InputDecoration(
              fillColor: Colors.grey[400],
              labelStyle: GoogleFonts.didactGothic(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
              labelText: widget.title,
              hintText: "${widget.hintText}...",
              errorStyle: GoogleFonts.didactGothic(
                  color: Colors.red,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600),
              counterText: '',
              hintStyle: GoogleFonts.didactGothic(
                  color: Colors.grey[500], fontWeight: FontWeight.w600),
              prefixIcon: Icon(
                widget.icon,
                color: Colors.black,
                size: 20.0,
              ),
              suffix: widget.suffixChild,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.grey[400],
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.indigo,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          )
        : (widget.isPassword)
            ? TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.errorText;
                  } else {
                    return null;
                  }
                },
                controller: widget.controller,
                keyboardType: TextInputType.text,
                obscureText: _isObscure,
                style: const TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                  fillColor: Colors.grey[400],
                  labelStyle: GoogleFonts.didactGothic(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  labelText: widget.title,
                  hintText: "${widget.hintText}...",
                  errorStyle: GoogleFonts.didactGothic(
                      color: Colors.red,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                  counterText: '',
                  hintStyle: GoogleFonts.didactGothic(
                      color: Colors.grey[500], fontWeight: FontWeight.w600),
                  prefixIcon: Icon(
                    widget.icon,
                    color: Colors.black,
                    size: 20.0,
                  ),
                  suffix: widget.suffixChild,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.grey[400],
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.indigo,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                    ),
                    color: Colors.black54,
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              )
            : TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.errorText;
                  } else {
                    return null;
                  }
                },
                // maxLength: 10,
                keyboardType: TextInputType.datetime,
                controller: widget.controller,
                decoration: InputDecoration(
                  labelText: widget.title,
                  hintText: 'JJ / MM / AAAA',
                  fillColor: Colors.grey[400],
                  labelStyle: GoogleFonts.didactGothic(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  errorStyle: GoogleFonts.didactGothic(
                      color: Colors.red,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                  counterText: '',
                  hintStyle: GoogleFonts.didactGothic(
                      color: Colors.grey[500], fontWeight: FontWeight.w600),
                  prefixIcon: Icon(
                    widget.icon,
                    color: Colors.black,
                    size: 20.0,
                  ),
                  suffix: widget.suffixChild,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.grey[400],
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.indigo,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                inputFormatters: [
                  // ignore: deprecated_member_use
                  LengthLimitingTextInputFormatter(10),
                  DateFormatter(),
                ],
              );
  }
}

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue prevText,
    TextEditingValue currText,
  ) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = cText.substring(0, 5) + '/';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
