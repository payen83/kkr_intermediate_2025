import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('State Management'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black)
        ),
        child: Column(
          children: [
            //Title
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 3),
              width: MediaQuery.of(context).size.width,
              child: Text('Title', 
                style: TextStyle(
                    fontSize: 16, 
                    fontWeight: 
                    FontWeight.w600, 
                    color: Colors.black
                  ),
                ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 3),
              width: MediaQuery.of(context).size.width,
              child: Text('Description', 
                style: TextStyle(
                    fontSize: 16, 
                    fontWeight: 
                    FontWeight.w600, 
                    color: Colors.black
                  ),
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ), 
    );
  }
}
