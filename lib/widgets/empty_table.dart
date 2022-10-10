import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/controllers.dart';

class EmptyTable extends StatelessWidget {
  const EmptyTable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          width: .1,
          color: Colors.pink,
        ),
      ),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (dataController.dataLoading.value == true) ...[
              const SpinKitThreeBounce(
                color: Colors.pink,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "Chargement de données en cours... ",
                style: GoogleFonts.didactGothic(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else ...[
              const Icon(
                Icons.cloud_off_rounded,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "Aucune donnée répertoriée !",
                style: GoogleFonts.didactGothic(
                  color: Colors.pink[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
