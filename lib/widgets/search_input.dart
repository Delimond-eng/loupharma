import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchInput extends StatelessWidget {
  final double spacedLeft;
  final String hintText;
  final Function(String value) onChanged;
  final Function(String value) onSubmitted;
  final TextEditingController controller;
  final bool hasSubmitted;
  const SearchInput({
    Key key,
    this.spacedLeft,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.hasSubmitted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(left: spacedLeft ?? 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          width: .5,
          color: Colors.blue[200],
        ),
        color: Colors.white.withOpacity(.8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 2.0, 5.0, 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.search,
              color: Colors.blue,
              size: 16.0,
            ),
            Expanded(
              child: TextField(
                style: GoogleFonts.didactGothic(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w800,
                ),
                onChanged: onChanged,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(bottom: 12.0, left: 10.0),
                  hintText: hintText ?? "Recherche facture...",
                  hintStyle: GoogleFonts.didactGothic(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
            if (hasSubmitted) ...[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 2,
                  padding: const EdgeInsets.all(10.0),
                ),
                child: Text(
                  "Rechercher",
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
                onPressed: () => onSubmitted(controller.text),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
