import 'package:flutter/material.dart';
import 'package:kkr_intermediate_2025/app/widget/appbar.widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final MobileScannerController scannerController = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.noDuplicates
  );

  void stopScan(String qr){
    Navigator.pop(context, qr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Scan your QR..'),
      body: MobileScanner(
        controller: scannerController,
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          String qrcode = '';
          if(barcodes.isEmpty && barcodes.first.rawValue != null){
            await Future.delayed(Duration(seconds: 1));
            qrcode = barcodes.first.rawValue.toString();
          } else {
            qrcode = 'Invalid while scan QR';
          }
          stopScan(qrcode);
        },
      ),
    );
  }
}