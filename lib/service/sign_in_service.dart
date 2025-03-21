import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/constant/database_config.dart';
import 'package:my_app/screen/to_do_list_screen.dart';

class SignInService {
  static Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$api_url/login'),
        headers: api_headers,
        body: jsonEncode(<String, String>{
          'user_email': email,
          'user_password': password,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('user_id') && data.containsKey('user_email') && data.containsKey('user_fname') && data.containsKey('user_lname')) {
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
                  Icon(
                    Icons.warning,
                    color: Colors.orange,
                    size: 40.0,
                  ),
                ],
              ),
              content: const Text(
                'Email or password is incorrect',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
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
}