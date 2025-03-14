import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/screen/add_to_do.dart';
import 'package:my_app/screen/sign_up.dart';
import 'package:my_app/screen/to_do_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(), // use outfit all project
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => SignIn(),
        '/sign_up': (context) => SignUp(),
        '/to_do_list': (context) => ToDoList(),
        '/add_to_do': (context) => AddToDo(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/splash_screen.png",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> signIn(String email, String password) async {
      final response = await http.post(
        Uri.parse('http://10.91.114.23:6004/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
        },
        body: jsonEncode(<String, String>{
          'user_email': email,
          'user_password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // print('222 ${data}');
        Navigator.pushReplacementNamed(
          context,
          '/to_do_list',
          arguments: {
            'user_id': data['user_id'],
            'user_email': data['user_email'],
            'user_fname': data['user_fname'],
            'user_lname': data['user_lname'],
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in')),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
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
                  padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.transparent,
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
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      obscureText: true,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: EdgeInsets.only(left: 225.0),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forget Password ?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
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
                        signIn(emailController.text, passwordController.text);
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
                const SizedBox(height: 20),
                SizedBox(
                  width: 350,
                  height: 70,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}