import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ribbon/ribbon.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({Key key, this.statusColor}) : super(key: key);
  final MaterialColor statusColor;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Ribbon(
      nearLength: 30,
      farLength: 60,
      title: 'status',
      titleStyle: GoogleFonts.didactGothic(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
      color: widget.statusColor.withOpacity(.7),
      location: RibbonLocation.topStart,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0,
              color: Colors.grey.withOpacity(.3),
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _orderTitle(),
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                radius: const Radius.circular(5.0),
                thickness: 5.0,
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < 2; i++) ...[
                        const OrderItemCard(),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: const Border(
                  top: BorderSide(
                    color: Colors.black,
                    width: .4,
                  ),
                ),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "X5 items",
                          style: GoogleFonts.didactGothic(
                            color: Colors.grey[800],
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "6550.00",
                                style: GoogleFonts.staatliches(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18.0,
                                ),
                              ),
                              TextSpan(
                                text: " CDF",
                                style: GoogleFonts.didactGothic(
                                  color: Colors.grey[800],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: const [
                        CustomIconBtn(
                          color: Colors.green,
                          icon: CupertinoIcons.checkmark_alt,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        CustomIconBtn(
                          color: Colors.red,
                          icon: CupertinoIcons.clear,
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statusColor() {
    return Container(
      height: 1.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.statusColor.shade800,
      ),
    );
  }

  Widget _orderTitle() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/svgs/food.svg",
            color: Colors.grey,
            height: 20.0,
            width: 20.0,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Commande #001",
                  style: GoogleFonts.didactGothic(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 12.0,
                      color: Colors.grey,
                    ),
                    Text(
                      " 20 Juin 2022",
                      style: GoogleFonts.didactGothic(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    const Icon(
                      CupertinoIcons.time,
                      size: 12.0,
                      color: Colors.grey,
                    ),
                    Text(
                      " 8:00 PM",
                      style: GoogleFonts.didactGothic(
                        color: widget.statusColor.shade900,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[400],
            width: .3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 60.0,
              width: 60.0,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage("assets/images/img_2.jpg"),
                  fit: BoxFit.scaleDown,
                ),
              ),
              margin: const EdgeInsets.only(right: 8.0),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Item name",
                    style: GoogleFonts.didactGothic(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "category of item",
                    style: GoogleFonts.didactGothic(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$ 10",
                        style: GoogleFonts.didactGothic(
                          color: Colors.deepPurple,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "Qté : 1",
                        style: GoogleFonts.didactGothic(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomIconBtn extends StatelessWidget {
  final IconData icon;
  final MaterialColor color;
  const CustomIconBtn({Key key, this.icon, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40.0),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 15.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
