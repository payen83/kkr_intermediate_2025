import 'dart:math';

import 'package:flutter/material.dart';

class BulletinScreen extends StatefulWidget {
  const BulletinScreen({super.key});

  @override
  State<BulletinScreen> createState() => _BulletinScreenState();
}

class _BulletinScreenState extends State<BulletinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Bulletin'),
      ) ,
      body: Container(
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
                  child: Image.asset(
                    'assets/images/shapes.png',
                    fit: BoxFit.cover,
                    // errorBuilder: (context, error, stackTrace){
                    //   return Container(
                    //     color: Colors.blueGrey,
                    //     child: Icon(Icons.image_not_supported, size: 40),
                    //   );
                    // },
                  ),
                ),
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Text(
                  'Bulletin Title2',
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
                  '2025-08-19',
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
      ),
    );
  }
}