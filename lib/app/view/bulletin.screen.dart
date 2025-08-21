import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kkr_intermediate_2025/app/service/api.service.dart';
import 'package:kkr_intermediate_2025/app/view/addbulletin.screen.dart';
import 'package:kkr_intermediate_2025/app/widget/drawer.widget.dart';

class BulletinScreen extends StatefulWidget {
  const BulletinScreen({super.key});

  @override
  State<BulletinScreen> createState() => _BulletinScreenState();
}

class _BulletinScreenState extends State<BulletinScreen> {
  List data = [];

  @override
  void initState(){
    super.initState();
    getBulletins();
  }

  void refresh(){
    getBulletins();
  }

  void getBulletins() async {
    try {
      var result = await api.getDio('/news');

      if(result is Map && result.containsKey("data")){
        setState(() {
          data = result["data"];
        });
        // log(data.toString());
      }
      // log(jsonEncode(result));
    } catch (e){
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Bulletin KKR'),
      ),
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => AddBulletin())
          ).then((isRefresh){
            if(isRefresh){
              refresh();
            }
          });
        }
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: data.length,
        itemBuilder: (context, index){
          final bulletin = data[index];
          return BuildBulletinItem(item: bulletin);
        }
      )

      //BuildBulletinItem(),
    );
  }
}

class BuildBulletinItem extends StatelessWidget {
   const BuildBulletinItem({
    super.key, required this.item
  });

  final Map<String,dynamic> item;

  @override
  Widget build(BuildContext context) {
    var path = 'http://10.0.2.2:8888/api';
    String title = item['title'].toString();
    String date = item['date'].toString();
    String image = (item['image_url']).toString();
    
    if(image.split('/')[0] != 'https:'){
      image = path+image;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1)
          )
        ]
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1)
                  )
                ]
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(image, fit: BoxFit.cover),
                // image.isNotEmpty 
                //  ?Image.network(
                //   image,
                //   fit: BoxFit.cover,
                //   // errorBuilder: (context, error, stackTrace){
                //   //   return Container(
                //   //     color: Colors.blueGrey,
                //   //     child: Icon(Icons.image_not_supported, size: 40),
                //   //   );
                //   // },
                // )
                // : Image.asset('assets/images/shapes.png', fit: BoxFit.cover,),
              ),
            ),
            SizedBox(width: 12,),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w500, 
                  color: Colors.black
                ),
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.normal, 
                  color: Colors.grey
                ),
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              width: 24,
              child: Icon(
                Icons.arrow_forward,
                size: 16,
                color: Colors.grey,
              )
            ),
          ],
        ),
      ),
    );
  }
}