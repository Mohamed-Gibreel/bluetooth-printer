import 'package:flutter/material.dart';

class ScreenshotHistory extends StatelessWidget {
  final List<CardHistory> history;
  final double dpr;

  const ScreenshotHistory({
    required this.history,
    required this.dpr,
  });

  @override
  Widget build(BuildContext context) {
    var smallFontSize = 21 / dpr;

    double transactionIDColumnSize = 136.5 / dpr;
    double paymentTypeColumnSize = 59.5 / dpr;
    double paymentMethodColumnSize = 77 / dpr;
    double amountColumnSize = 94 / dpr;
    double dateColumnSize = 157.5 / dpr;

    return DefaultTextStyle.merge(
      style: Theme.of(context)
          .textTheme
          .headlineLarge
          ?.copyWith(fontFamily: "Roboto"),
      child: Container(
        width: 558 / dpr,
        color: Colors.black.withOpacity(.1),
        child: Column(
          children: [
            SizedBox(
              width: 445 / dpr,
              child: Image.asset("assets/alc-logo.png"),
            ),
            Text(
              "ADIBF 2022",
              style: TextStyle(fontSize: smallFontSize),
            ),
            SizedBox(
              height: 7 / dpr,
            ),
            Text(
              "------------------------------------------------------------------------------------------",
              style: TextStyle(fontSize: smallFontSize),
            ),
            SizedBox(
              height: 7 / dpr,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kiosk".toUpperCase(),
                  style: TextStyle(fontSize: smallFontSize),
                ),
                Text(
                  "Second Kiosk",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: smallFontSize,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 7 / dpr,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date".toUpperCase(),
                  style: TextStyle(fontSize: smallFontSize),
                ),
                Text(
                  "15/12/2023".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: smallFontSize),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "------------------------------------------------------------------------------------------",
              style: TextStyle(fontSize: smallFontSize),
            ),
            Text(
              "History",
              style: TextStyle(
                fontSize: smallFontSize,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                SizedBox(
                  width: transactionIDColumnSize,
                  child: Text(
                    "Transcation",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: smallFontSize),
                  ),
                ),
                SizedBox(
                  width: paymentTypeColumnSize,
                  child: Text(
                    "Type",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: smallFontSize),
                  ),
                ),
                SizedBox(
                  width: amountColumnSize,
                  child: Text(
                    "Amount",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: smallFontSize),
                  ),
                ),
                SizedBox(
                  width: paymentMethodColumnSize,
                  child: Text(
                    "Method",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: smallFontSize),
                  ),
                ),
                SizedBox(
                  width: dateColumnSize,
                  child: Text(
                    "Action Date",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: smallFontSize),
                  ),
                ),
              ],
            ),
            Text(
              "------------------------------------------------------------------------------------------",
              style: TextStyle(fontSize: smallFontSize),
            ),
            const SizedBox(
              height: 4,
            ),
            ...history.map((item) {
              // final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm');
              // final String formattedDate =
              //     formatter.format(item.date ?? DateTime.now());
              return Column(
                children: [
                  Row(
                    children: [
                      Text(
                        item.transactionId.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: smallFontSize),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: transactionIDColumnSize,
                      ),
                      SizedBox(
                        width: paymentTypeColumnSize,
                        child: FittedBox(
                          child: Text(
                            "Top up",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: smallFontSize),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: amountColumnSize,
                        child: Text(
                          item.amount?.toStringAsFixed(0).toString() ?? "-",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: smallFontSize),
                        ),
                      ),
                      SizedBox(
                        width: paymentMethodColumnSize,
                        child: Text(
                          "Cash",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: smallFontSize),
                        ),
                      ),
                      SizedBox(
                        width: dateColumnSize,
                        child: FittedBox(
                          child: Text(
                            "25-1-2024 10:24",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: smallFontSize),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  )
                ],
              );
            }).toList(),
            Text(
              "------------------------------------------------------------------------------------------",
              style: TextStyle(fontSize: smallFontSize),
            ),
          ],
        ),
      ),
    );
  }
}

class CardHistory {
  double? amount;
  int? paymentType;
  int? transactionType;
  String? transactionId;
  String? kiosk;
  DateTime? date;

  CardHistory({
    this.amount,
    this.paymentType,
    this.transactionId,
    this.transactionType,
    this.kiosk,
    this.date,
  });

  CardHistory.fromJson(Map<String, dynamic> json) {
    amount = double.tryParse(json['amount'].toString());
    paymentType = int.tryParse(json['paymentType'].toString());
    transactionId = json['transactionId'];
    transactionType = 1;
    kiosk = json['kiosk'];
    date = DateTime.tryParse(json['date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['paymentType'] = paymentType;
    data['transactionId'] = transactionId;
    data['transactionType'] = transactionType;
    data['kiosk'] = kiosk;
    data['date'] = date;
    return data;
  }
}
