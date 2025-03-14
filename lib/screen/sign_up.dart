import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController userFnameController = TextEditingController();
    final TextEditingController userLnameController = TextEditingController();

    Future<void> signUp(String email, String password, String userFname, String userLname) async {
      final response = await http.post(
        Uri.parse('http://10.91.114.23:6004/api/create_user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
        },
        body: jsonEncode(<String, String>{
          'user_fname' : userFname,
          'user_lname' : userLname,
          'user_email': email,
          'user_password': password,
        }),
      );
      // print('333 ${response.statusCode}');
      // print('444 ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // print('222 ${data}');
        Navigator.pushReplacementNamed(
          context,
          '/home',
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up')),
        );
      }
    }
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 55,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Image.asset(
                'assets/images/icon_arrow_left.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Please enter the information',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Text(
                  'below to access.',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/signup_logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0), // กำหนด borderRadius ให้เงาโค้งตาม
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // ตำแหน่งเงา
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: userFnameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'First name',
                        filled: true,
                        fillColor: Colors.transparent, // เปลี่ยนเป็น transparent เพราะสีถูกกำหนดใน Container แล้ว
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0), // กำหนด borderRadius ให้เงาโค้งตาม
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // ตำแหน่งเงา
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: userLnameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Last name',
                        filled: true,
                        fillColor: Colors.transparent, // เปลี่ยนเป็น transparent เพราะสีถูกกำหนดใน Container แล้ว
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100], // ต้องใส่สีตรงนี้แทนที่ใน InputDecoration เพื่อให้เงาแสดงผลถูกต้อง
                      borderRadius: BorderRadius.circular(12.0), // กำหนด borderRadius ให้เงาโค้งตาม
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // ตำแหน่งเงา
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.transparent, // เปลี่ยนเป็น transparent เพราะสีถูกกำหนดใน Container แล้ว
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100], // ต้องใส่สีตรงนี้แทนที่ใน InputDecoration เพื่อให้เงาแสดงผลถูกต้อง
                      borderRadius: BorderRadius.circular(12.0), // กำหนด borderRadius ให้เงาโค้งตาม
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // ตำแหน่งเงา
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.transparent, // เปลี่ยนเป็น transparent เพราะสีถูกกำหนดใน Container แล้ว
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 55),
                SizedBox(
                  width: 350,
                  height: 70,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF53CD9F), Color(0xFF0D7A5C)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        signUp (emailController.text, passwordController.text, userFnameController.text, userLnameController.text);
                      },
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}