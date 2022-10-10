import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/controllers.dart';
import '../global/utils.dart';
import '../models/compte.dart';
import '../reports/models/month.dart';
import '../reports/report.dart';
import '../responsive/base_widget.dart';
import '../utilities/modals.dart';
import '../widgets/costum_table.dart';
import '../widgets/custom_page.dart';
import '../widgets/empty_table.dart';
import '../widgets/filter_btn.dart';
import 'modals/inventory_details_modal.dart';

class Inventories extends StatefulWidget {
  const Inventories({Key key}) : super(key: key);

  @override
  State<Inventories> createState() => _InventoriesState();
}

class _InventoriesState extends State<Inventories> {
  List<Month> months = <Month>[];

  double _entrees = 0.0;
  double _sorties = 0.0;

  double get _solde => _entrees - _sorties;

  @override
  void initState() {
    super.initState();
    initData();
    dataController.loadAllComptes();
  }

  initData() async {
    var m = await Report.getMonths();
    months.clear();
    months.addAll(m);
    setState(() {});
  }

  initTot() {
    double en = 0;
    double so = 0;
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        for (var e in dataController.inventories) {
          if (e.operationType.toLowerCase() == 'entrée') {
            en += e.totalPayment;
          }
          if (e.operationType.toLowerCase() == 'sortie') {
            so += e.totalPayment;
          }
        }
        _entrees = en;
        _sorties = so;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomPage(
        title: "Inventaires",
        icon: CupertinoIcons.doc_chart_fill,
        child: LayoutBuilder(builder: (context, constraints) {
          return Responsive(builder: (context, responsive) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _inventoriesFilters(context),
                      Expanded(
                        child: FadeInUp(
                          child: Obx(() {
                            return dataController.inventories.isEmpty
                                ? const EmptyTable()
                                : ListView(
                                    padding: const EdgeInsets.all(10.0),
                                    children: [
                                      CostumTable(
                                        cols: const [
                                          "Date",
                                          "Montant",
                                          "Compte",
                                          "Status compte",
                                          ""
                                        ],
                                        data: _createRows(),
                                      ),
                                    ],
                                  );
                          }),
                        ),
                      ),
                      _rightSide(context),
                    ],
                  ),
                )
              ],
            );
          });
        }),
      ),
    );
  }

  List<DataRow> _createRows() {
    return dataController.inventories
        .map(
          (e) => DataRow(
            cells: [
              DataCell(
                Text(
                  e.operationDate,
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${e.totalPayment.toStringAsFixed(2)} ${e.operationDevise}',
                  style: GoogleFonts.didactGothic(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  e.compte.compteLibelle,
                  style: GoogleFonts.didactGothic(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: (e.compte.compteStatus == "actif")
                        ? Colors.green[200]
                        : Colors.red[100],
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Text(
                    e.compte.compteStatus,
                    style: GoogleFonts.didactGothic(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.0,
                      color: (e.compte.compteStatus == "actif")
                          ? Colors.green[700]
                          : Colors.red[700],
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 2,
                        padding: const EdgeInsets.all(8.0),
                      ),
                      child: Text(
                        "Voir détals",
                        style: GoogleFonts.didactGothic(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                      onPressed: () async {
                        dataController.loadPayments(
                          "details",
                          field: int.parse(e.operationTimestamp.toString()),
                        );
                        inventoryDetailsModal(context, data: e);
                      },
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        )
        .toList();
  }

  Widget _rightSide(BuildContext context) {
    return FadeInUp(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 160.0,
        margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            bottom: BorderSide(color: Colors.indigo, width: 6.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.1),
              blurRadius: 5,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 60.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200],
                    width: 3,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.pink,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Vue synthétique",
                      style: GoogleFonts.didactGothic(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: SyntheseInfo(
                      amount: _entrees,
                      currency: "USD",
                      title: "Total des entrées",
                      icon: CupertinoIcons.up_arrow,
                      thikness: .1,
                      titleColor: Colors.green[700],
                    ),
                  ),
                  Flexible(
                    child: SyntheseInfo(
                      amount: _sorties,
                      currency: "USD",
                      title: "Total des sorties",
                      titleColor: Colors.red,
                      icon: CupertinoIcons.down_arrow,
                      thikness: .1,
                    ),
                  ),
                  Flexible(
                    child: SyntheseInfo(
                      amount: _solde,
                      currency: "USD",
                      title: "Solde",
                      titleColor: Colors.indigo,
                      icon: CupertinoIcons.arrow_right_circle_fill,
                      thikness: .1,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  var fWord = "all";
  Widget _inventoriesFilters(BuildContext context) {
    return FadeInUp(
      child: Row(
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(
                  top: BorderSide(color: Colors.indigo, width: 2.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.1),
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Filtrer par : ",
                      style: GoogleFonts.didactGothic(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    FilterBtn(
                      width: 80.0,
                      icon: Icons.filter_alt_rounded,
                      title: "Tous",
                      isSelected: fWord == "all",
                      onPressed: () async {
                        setState(() => fWord = "all");
                        Xloading.showLottieLoading(context);
                        await dataController.loadInventories("all");
                        initTot();
                        emptyCo();
                        emptyMo();
                        Xloading.dismiss();
                      },
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    FilterBtn(
                      icon: Icons.filter_list_sharp,
                      title: "Date",
                      width: 130.0,
                      isSelected: fWord == "date",
                      onPressed: () async {
                        var date = await showDatePicked(context);
                        if (date != null) {
                          Xloading.showLottieLoading(context);
                          var strDate =
                              dateToString(parseTimestampToDate(date));
                          await dataController.loadInventories("all");
                          await dataController.loadInventories("date",
                              fkey: strDate);
                          initTot();
                          setState(() => fWord = "date");
                          emptyCo();
                          emptyMo();
                          Xloading.dismiss();
                        }
                      },
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    _dropdowMonth(),
                    const SizedBox(
                      width: 8.0,
                    ),
                    _dropdowCompte(),
                    const SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Month selectedMonth;

  emptyMo({Month o}) {
    setState(() {
      selectedMonth = o;
    });
  }

  Widget _dropdowMonth() {
    return Container(
      width: 140.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: selectedMonth != null ? Colors.indigo[400] : Colors.transparent,
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
              Icon(
                Icons.filter_list_sharp,
                size: 15.0,
                color: selectedMonth != null ? Colors.white : Colors.indigo,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: DropdownButton<Month>(
                  menuMaxHeight: 200,
                  dropdownColor: Colors.white,
                  alignment: Alignment.centerLeft,
                  iconEnabledColor:
                      selectedMonth != null ? Colors.white : Colors.grey[600],
                  borderRadius: BorderRadius.circular(5.0),
                  style: GoogleFonts.didactGothic(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  value: selectedMonth,
                  underline: const SizedBox(),
                  hint: Text(
                    "Mois",
                    style: GoogleFonts.didactGothic(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  isExpanded: true,
                  items: months.map((e) {
                    return DropdownMenuItem<Month>(
                      value: e,
                      child: Text(
                        e.label,
                        style: GoogleFonts.didactGothic(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.grey[800],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (m) async {
                    setter(() {
                      selectedMonth = m;
                    });
                    await dataController.loadInventories("all");
                    await dataController.loadInventories("mois", fkey: m.value);
                    setState(() {
                      fWord = "mois";
                    });
                    emptyCo();
                    initTot();
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Compte selectedCompte;
  emptyCo({Compte c}) {
    setState(() {
      selectedCompte = c;
    });
  }

  Widget _dropdowCompte() {
    return Container(
      width: 140.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: selectedCompte != null ? Colors.indigo[400] : Colors.transparent,
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
              Icon(
                Icons.filter_list_sharp,
                size: 15.0,
                color: selectedCompte != null ? Colors.white : Colors.indigo,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: DropdownButton<Compte>(
                  menuMaxHeight: 200,
                  dropdownColor: Colors.white,
                  alignment: Alignment.centerLeft,
                  iconEnabledColor:
                      selectedCompte != null ? Colors.white : Colors.grey[600],
                  borderRadius: BorderRadius.circular(5.0),
                  style: GoogleFonts.didactGothic(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  value: selectedCompte,
                  underline: const SizedBox(),
                  hint: Text(
                    "Compte",
                    style: GoogleFonts.didactGothic(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  isExpanded: true,
                  items: dataController.allComptes.map((e) {
                    return DropdownMenuItem<Compte>(
                      value: e,
                      child: Text(
                        e.compteLibelle,
                        style: GoogleFonts.didactGothic(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.grey[800],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (c) async {
                    setter(() {
                      selectedCompte = c;
                    });
                    await dataController.loadInventories("compte",
                        fkey: c.compteId);
                    setState(() {
                      fWord = "compte";
                    });
                    initTot();
                    emptyMo();
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

class SyntheseInfo extends StatelessWidget {
  final Color titleColor;
  final String title, currency;
  final double thikness;
  final double amount;
  final IconData icon;
  const SyntheseInfo({
    Key key,
    this.titleColor,
    this.title,
    this.thikness,
    this.amount,
    this.currency,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: thikness ?? .5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: titleColor,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.didactGothic(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: titleColor ?? Colors.green[700],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: amount.toStringAsFixed(2),
                          style: GoogleFonts.staatliches(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 20.0,
                          ),
                        ),
                        TextSpan(
                          text: " $currency",
                          style: GoogleFonts.didactGothic(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class XButton extends StatelessWidget {
  final bool isActived;
  final Function onPressed;
  const XButton({
    Key key,
    this.isActived,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Colors.grey.withOpacity(.3),
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 10.0,
            ),
            child: Row(
              children: [
                Text(
                  isActived ? "Réduire catégories" : "Voir catégories",
                  style: GoogleFonts.didactGothic(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Icon(
                  isActived
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  color: Colors.black,
                  size: 14.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
