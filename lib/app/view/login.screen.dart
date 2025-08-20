import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kkr_intermediate_2025/app/service/api.service.dart';
import 'package:kkr_intermediate_2025/app/service/sharedpreference.service.dart';
import 'package:kkr_intermediate_2025/app/view/bulletin.screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void onLogin() async{
    FormData formData = FormData.fromMap({
      "email": emailController.text,
      "password": passwordController.text
    });

    try {
      var res = await api.postDio('/login', formData);
      log('res==>');
      
      if(res != null && res.statusCode == 200){
        
        final data = res.data;
        final bool status = data['status'];
        // log(status.toString());
        if(status == true && data['data'] != null){
                  // log("asdsa");
          await UserSharedPreferences.setLocalStorage('token', jsonEncode(data['token']));
          if(!mounted) return;
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BulletinScreen())
          );
        } else {
          log("Invalid password");
        }
      } 
    } catch(e){
        log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 201, 161, 161),
              shape: BoxShape.rectangle
            ),
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height * 0.3,
          //   decoration: BoxDecoration(
          //     color: Colors.white, 
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(50),
          //       bottomRight: Radius.circular(50)
          //     )
          //   ),
          // ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    width: MediaQuery.of(context).size.width,
                    child: Text("My Jalan KKR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w600
                    ),),
                  ),

                  Card(
                    margin: EdgeInsets.all(32),
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Container(
                        //   margin: EdgeInsets.symmetric(horizontal: 16),
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        // ),
                        // Email Label
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Alamat e-mel",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Email Text Field
                          Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Emel Anda',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Password Label
                          Container(
                            margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Kata laluan",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Password Text Field
                          Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Kata laluan',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                  // Eye Icon
                                  
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 30),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                textStyle: TextStyle(fontSize: 20),
                              ),
                              onPressed: onLogin,
                              child: Text('Log masuk'),
                            ),
                          ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}