import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/network_controller.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screen/to_do_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final NetworkController networkController = Get.find<NetworkController>();
  bool _obscureText = true;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  
  Future<void> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.91.114.48:6004/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
        },
        body: jsonEncode(<String, String>{
          'user_email': email,
          'user_password': password,
        }),
      );
      // print('1234: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('user_id') &&
            data.containsKey('user_email') &&
            data.containsKey('user_fname') &&
            data.containsKey('user_lname')) {
          // Save user data to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id', data['user_id'].toString());
          await prefs.setString('user_email', data['user_email']);
          await prefs.setString('user_fname', data['user_fname']);
          await prefs.setString('user_lname', data['user_lname']);
          await prefs.setBool('is_logged_in', true);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ToDoList(userData: data)),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid response from server')),
          );
        }
      } else if (response.statusCode == 400 && response.body == '{"message":"Email or password is incorrect."}') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 40.0,),
                ],
              ),
              content:const Text('Email or password is incorrect', textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
              actions: <Widget>[
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(76, 197, 153, 1),
                          Color.fromRGBO(13, 122, 92, 1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to sign in: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      resizeToAvoidBottomInset: false, //for prevent the keyboard from pushing the background
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // Obx(() {
            //    print("Network status: ${networkController.isConnected.value}");
            //   return Text(
            //     networkController.isConnected.value ? "Connected" : "No Internet",
            //     style: TextStyle(
            //       fontSize: 20,
            //       color: networkController.isConnected.value ? Colors.green : Colors.red,
            //     ),
            //   );
            // }),
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Text(
                      'SIGN IN',
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
                      'assets/images/signin_logo.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: emailController,
                          focusNode: emailFocusNode,
                          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))], // Add this line
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(passwordFocusNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!value.contains('@') || !value.endsWith('.com') || (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) || (RegExp(r'[ก-๙]').hasMatch(value))) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))], // Add this line
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Password',
                            filled: true,
                            fillColor: Colors.transparent,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                                size: 20.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureText,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(left: 190.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forget Password ?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 55),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color.fromRGBO(76, 197, 153, 1),
                                Color.fromRGBO(13, 122, 92, 1),
                              ],
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
                              if (formKey.currentState!.validate()) {
                                signIn(emailController.text, passwordController.text);
                              }
                            },
                            child: const Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0D7A5C), Color(0xFF0D7A5C)],
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
                              Navigator.of(context).pushNamed('/sign_up');
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}