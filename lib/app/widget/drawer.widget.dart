import 'package:flutter/material.dart';
import 'package:kkr_intermediate_2025/app/view/animation.screen.dart';
import 'package:kkr_intermediate_2025/app/view/bulletin.screen.dart';
import 'package:kkr_intermediate_2025/app/view/home.screen.dart';
import 'package:kkr_intermediate_2025/app/view/map.screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    'Main Menu',
                    style: TextStyle(
                      color: Colors.cyanAccent, 
                      fontSize: 24,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                MenuItem(
                  itemTitle: 'State Management', 
                  itemIcon: Icons.star_rate, 
                  widgetScreen: MyHomePage(),
                ),
                MenuItem(
                  itemTitle: 'Map & Geolocation', 
                  itemIcon: Icons.map, 
                  widgetScreen: MapScreen(),
                ),
                MenuItem(
                  itemTitle: 'Bulletin', 
                  itemIcon: Icons.newspaper, 
                  widgetScreen: BulletinScreen(),
                ),
                MenuItem(
                  itemTitle: 'Animation', 
                  itemIcon: Icons.flutter_dash, 
                  widgetScreen: AnimationScreen(),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.itemTitle,
    required this.widgetScreen,
    required this.itemIcon
  });

  final String itemTitle;
  final Widget widgetScreen;
  final IconData itemIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(itemIcon),
      title: Text(itemTitle, style: TextStyle(
          color: Colors.black, 
          fontSize: 14,
          fontWeight: FontWeight.w400
        ),
      ),
      onTap: (){
        Navigator.pop(context);
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => widgetScreen
          )
        );
      },
    );
  }
}