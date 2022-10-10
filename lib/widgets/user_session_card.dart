import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/auth/authenticate_screen.dart';
import '../utilities/modals.dart';

class UserSessionCard extends StatelessWidget {
  final String username;
  final String userRole;
  final Color color;
  const UserSessionCard({
    Key key,
    this.color,
    this.username,
    this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0,
              color: Colors.black.withOpacity(.2),
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 4.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 35.0,
                    width: 35.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: color ?? Colors.indigo,
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.person_solid,
                        color: color != null ? Colors.pink : Colors.white,
                        size: 15.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        username ?? "",
                        style: GoogleFonts.didactGothic(
                          color: color ?? Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        userRole ?? "",
                        style: GoogleFonts.didactGothic(
                          color: color ?? Colors.grey[700],
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 15.0,
              ),
              Icon(
                CupertinoIcons.chevron_down,
                color: color ?? Colors.black,
                size: 15.0,
              )
            ],
          ),
        ),
      ),
      onSelected: (value) {
        if (value == 1) {
          XDialog.show(
            context,
            message: "Etes-sûr de vouloir vous déconnecter de votre compte ?",
            onValidated: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthenticateScreen(),
                ),
              );
            },
            onFailed: () {},
          );
        }
        if (value == 2) {
          XDialog.show(
            context,
            message: "Voulez-vous fermer l'application  ?",
            onValidated: () {
              exit(0);
            },
            onFailed: () {},
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                child: Icon(
                  Icons.logout_sharp,
                  size: 15,
                  color: Colors.black,
                ),
              ),
              Text(
                'Déconnexion',
                style: GoogleFonts.didactGothic(
                    fontSize: 14.0, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                child: Icon(
                  CupertinoIcons.clear_circled_solid,
                  size: 20,
                  color: Colors.pink,
                ),
              ),
              Text(
                "Fermer",
                style: GoogleFonts.didactGothic(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
