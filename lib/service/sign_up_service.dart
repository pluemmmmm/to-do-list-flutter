import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/constant/database_config.dart';

class SignUpService {
  static Future<void> signUp(BuildContext context, String email, String password, String userFname, String userLname) async {
    try {
      final response = await http.post(
        Uri.parse('$api_url/create_user'),
        headers: api_headers,
        body: jsonEncode(<String, String>{
          'user_fname': userFname,
          'user_lname': userLname,
          'user_email': email,
          'user_password': password,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(
          context,
          '/home',
        );
      } else if (response.statusCode == 400 && response.body == '{"message":"This e-mail has already been used.."}') {
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
                'Email already exists',
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign up')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection')),
      );
    }
  }
}