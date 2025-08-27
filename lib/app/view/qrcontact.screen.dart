import 'package:flutter/material.dart';
import 'package:kkr_intermediate_2025/app/styles/styles.dart';
import 'package:kkr_intermediate_2025/app/view/scanqr.screen.dart';
import 'package:kkr_intermediate_2025/app/widget/appbar.widget.dart';
import 'package:kkr_intermediate_2025/app/widget/drawer.widget.dart';

class QRContactScreen extends StatefulWidget {
  const QRContactScreen({super.key});

  @override
  State<QRContactScreen> createState() => _QRContactScreenState();
}

class _QRContactScreenState extends State<QRContactScreen> {
  String qrText = '';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarWidget(title: 'QR and Contact List'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('QR Text: $qrText', style: normalText,),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => ScanQrScreen()
                    )
                  ).then((response){
                    if(response != null){
                      setState(() {
                        qrText = response;
                      });
                    }
                  });
                }, 
                child: Text('Scan QR Code', style: appStyles.normalTextStyle(30),)
              ),
            ),
            Text('Contact Picker ', style: appStyles.normalTextStyle(25),),
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }

  
}