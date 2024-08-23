import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:bluetooth_thermal_printer_example/screenshot_history.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as im;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  bool connected = false;
  List availableBluetoothDevices = [];
  ScreenshotController screenshotController = ScreenshotController();

  List<CardHistory> history = [
    CardHistory(
      amount: 10,
      date: DateTime.now(),
      kiosk: "Second Kiosk",
      paymentType: 1,
      transactionId: "trsh2_1_638410042484031148",
    )
  ];

  Future<void> getBluetooth() async {
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print("Print $bluetooths");
    setState(() {
      availableBluetoothDevices = bluetooths!;
    });
  }

  Future<void> setConnect(String mac) async {
    try {
      debugPrint("Connecting to printer - $mac");
      final String? result = await BluetoothThermalPrinter.connect(mac);
      print("state conneected $result");
      if (result == "true") {
        setState(() {
          connected = true;
        });
      }
    } catch (e) {
      debugPrint('=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
      debugPrint("Error while connecting to printer");
      debugPrint(e.toString());
      debugPrint('=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
    }
  }

  Future<void> printTicket() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      // List<int> bytes = await getTicket();
      // List<int> bytes = await printADIBFReciept();
      List<int>? bytes = await getScreenshot();
      if (bytes == null) {
        return;
      }
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<void> printGraphics() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getGraphicsTicket();
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<List<int>> getGraphicsTicket() async {
    List<int> bytes = [];

    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // Print QR Code using native function
    bytes += generator.qrcode('example.com');

    bytes += generator.hr();

    // Print Barcode using native function
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    bytes += generator.cut();

    return bytes;
  }

  Future<List<int>> getTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.text("Demo Shop",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text(
        "18th Main Road, 2nd Phase, J. P. Nagar, Bengaluru, Karnataka 560078",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: +919591708470',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'No',
          width: 1,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Item',
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Price',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);

    bytes += generator.row([
      PosColumn(text: "1", width: 1),
      PosColumn(
          text: "Tea",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "10",
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: "10", width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "2", width: 1),
      PosColumn(
          text: "Sada Dosa",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "30",
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: "30", width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "3", width: 1),
      PosColumn(
          text: "Masala Dosa",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "50",
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: "50", width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "4", width: 1),
      PosColumn(
          text: "Rova Dosa",
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "70",
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
      PosColumn(text: "70", width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size4,
            width: PosTextSize.size4,
          )),
      PosColumn(
          text: "160",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size4,
            width: PosTextSize.size4,
          )),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text("26-11-2020 15:22:45",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text(
        'Note: Goods once sold will not be taken back or exchanged.',
        styles: PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> printADIBFReciept() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.text(
      "ADIBF 2022",
      styles: PosStyles(
        fontType: PosFontType.fontA,
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
      linesAfter: 1,
    );

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
        text: 'KIOSK',
        width: 6,
        styles: PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: 'Second Kiosk',
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += generator.hr();

    bytes += generator.text(
      "History",
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
      linesAfter: 1,
    );
    // const utf8Encoder = Utf8Encoder();
    // final encodedStr = utf8Encoder.convert('عملية');

    bytes += generator.row([
      PosColumn(
        text: "Transaction",
        width: 3,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: "Type",
        width: 2,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: "Amount",
        width: 2,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: "Method",
        width: 2,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: "Action Date",
        width: 3,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
    ]);

    history.forEach((item) {
      bytes += generator.row([
        PosColumn(
          text: item.transactionId ?? "-",
          width: 12,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
      ]);
      bytes += generator.row([
        PosColumn(
          text: "",
          width: 3,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: item.transactionType.toString(),
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: item.amount.toString(),
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: item.paymentType.toString(),
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: "25-1-2024 11:30",
          width: 3,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
      ]);
    });

    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>?> getScreenshot() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    var screenshotImageBytes = await screenshotController.captureFromLongWidget(
      ScreenshotHistory(
        history: history,
        dpr: pixelRatio,
      ),
    );
    if (screenshotImageBytes != null) {
      final im.Image? screenshotImage = im.decodeImage(screenshotImageBytes);
      if (screenshotImage == null) return null;
      bytes += generator.image(screenshotImage);
    }

    bytes += generator.cut();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    history.clear();
    for (var i = 0; i < 10; i++) {
      history.add(
        CardHistory(
          amount: 10,
          date: DateTime.now(),
          kiosk: "Second Kiosk - $i",
          paymentType: 1,
          transactionType: 2,
          transactionId: "trsh2_1_638410042484031148",
        ),
      );
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Thermal Printer Demo'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Stack(
            children: [
              // Positioned(
              //   child: ScreenshotHistory(
              //     history: history,
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image.asset("assets/alc-logo.png"),
                  Text("Search Paired Bluetooth"),
                  TextButton(
                    onPressed: () {
                      this.getBluetooth();
                    },
                    child: Text("Search"),
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: availableBluetoothDevices.length > 0
                          ? availableBluetoothDevices.length
                          : 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            String select = availableBluetoothDevices[index];
                            List list = select.split("#");
                            // String name = list[0];
                            String mac = list[1];
                            debugPrint('=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
                            debugPrint(mac.toString());
                            debugPrint('=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
                            this.setConnect(mac);
                          },
                          title: Text('${availableBluetoothDevices[index]}'),
                          subtitle: Text("Click to connect"),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    connected.toString(),
                  ),
                  TextButton(
                    onPressed: connected ? this.printGraphics : null,
                    child: Text("Print"),
                  ),
                  TextButton(
                    onPressed: connected
                        ? () async {
                            this.printTicket();
                          }
                        : null,
                    child: Text("Print Ticket"),
                  ),
                  TextButton(
                    onPressed: () async {
                      String? res = await BluetoothThermalPrinter.disconnect();
                      if (res == "true") {
                        connected = false;
                        if (mounted) {
                          setState(() {});
                        }
                      }
                    },
                    child: Text("Disconnect"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
