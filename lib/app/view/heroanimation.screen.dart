import 'package:flutter/material.dart';
import 'package:kkr_intermediate_2025/app/view/animationdetail.screen.dart';
import 'package:kkr_intermediate_2025/app/widget/appbar.widget.dart';
import 'package:kkr_intermediate_2025/app/widget/drawer.widget.dart';

class HeroAnimationScreen extends StatefulWidget {
  const HeroAnimationScreen({super.key});

  @override
  State<HeroAnimationScreen> createState() => _HeroAnimationScreenState();
}

class _HeroAnimationScreenState extends State<HeroAnimationScreen> {
  final List<dynamic> products = [
    {
      "id": 1,
      "title": "Essence Mascara Lash Princess",
      "image_url": "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"
    },
    {
      "id": 2,
      "title": "Eyeshadow Palette with Mirror",
      "image_url": "https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/thumbnail.webp"
    },
    {
      "id": 3,
      "title": "Red Lipstick",
      "image_url": "https://cdn.dummyjson.com/product-images/beauty/red-lipstick/thumbnail.webp"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Hero Animation'),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          return InkWell(
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Image
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 0, 16),
                    width: 80,
                    height: 80,
                    child: Hero(
                      tag: product, 
                      child: Image.network(product['image_url'], fit: BoxFit.cover,)
                    ),
                  ),
                  //Title
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 3),
                    width: MediaQuery.of(context).size.width-134,
                    child: Text(
                      product['title'], 
                      style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                    ),
                  )
                ],
              ),
            ),
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => AnimationDetailScreen(product: product,),
                )
              );
            },
          );
        }
      ),
      drawer: DrawerWidget(),
    );
  }
}