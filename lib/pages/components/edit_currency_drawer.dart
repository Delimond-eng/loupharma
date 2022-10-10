import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../global/controllers.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/round_icon_btn.dart';
import '../../widgets/simple_field_text.dart';

class EditCurrencyDrawer extends StatelessWidget {
  const EditCurrencyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _text = TextEditingController();
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(right: 15.0),
      height: 210.0,
      width: 400.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.pink,
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mettre à jour le taux du jour",
                  style: GoogleFonts.didactGothic(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RoundedIconBtn(
                  size: 30.0,
                  iconColor: Colors.pink,
                  color: Colors.white,
                  icon: CupertinoIcons.clear,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SimpleField(
                    hintText: "Saisir le taux du jour en CDF... ",
                    iconColor: Colors.pink,
                    controller: _text,
                    isCurrency: true,
                    icon: CupertinoIcons.money_dollar_circle_fill,
                    title: "Taux du jour",
                    selectedCurrency: "CDF",
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomBtn(
                    icon: CupertinoIcons.checkmark_alt_circle_fill,
                    color: Colors.blue,
                    label: "Valider les modifications",
                    onPressed: () async {
                      if (_text.text.isEmpty) {
                        Navigator.pop(context);
                        return;
                      }
                      await dataController
                          .editCurrency(value: _text.text)
                          .then((_) {
                        Navigator.pop(context);
                      });
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
