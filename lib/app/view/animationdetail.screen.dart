import 'package:flutter/material.dart';
import 'package:kkr_intermediate_2025/app/widget/appbar.widget.dart';

class AnimationDetailScreen extends StatelessWidget {
  const AnimationDetailScreen({super.key, required this.product });

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Product Details'),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //image
          Container(
            margin: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Hero(
              tag: product, 
              child: Image.network(
                product['image_url'], 
                fit: BoxFit.contain,
              )
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 3),
            // width: MediaQuery.of(context).size.width,
            child: Text(
              product['title'], 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      )
    );
  }
}