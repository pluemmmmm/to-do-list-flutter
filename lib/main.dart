import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/screen/add_to_do.dart';
import 'package:my_app/screen/sign_up.dart';
import 'package:my_app/screen/to_do_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    String userId = (prefs.getInt('user_id') ?? '').toString();
    String userFname = prefs.getString('user_fname') ?? '';
    String userLname = prefs.getString('user_lname') ?? '';
    // print('888 ${prefs.getString('user_id')}');
    // print('78 $isLoggedIn');

    if (isLoggedIn) {
      // Navigator.of(context).pushReplacementNamed('/to_do_list');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ToDoList(userData: {'user_id': userId, 'user_fname': userFname, 'user_lname': userLname})));
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
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
    final formKey = GlobalKey<FormState>();

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
        // print('3333: ${response.statusCode}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);

          if (data.containsKey('user_id') && data.containsKey('user_email') &&
              data.containsKey('user_fname') && data.containsKey('user_lname')) {
            // Save user data to SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_id', data['user_id'].toString());
            await prefs.setString('user_email', data['user_email']);
            await prefs.setString('user_fname', data['user_fname']);
            await prefs.setString('user_lname', data['user_lname']);
            await prefs.setBool('is_logged_in', true);

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ToDoList(userData: data,))
            );
          } else {
            print('API response does not contain expected keys');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid response from server')),
            );
          }
        } else {
          print('Failed to sign in: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign in: ${response.statusCode}')),
          );
        }
      } catch (e) {
        // print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No internet connection')),
        );
      }
    }
    return Scaffold(
      // appBar: AppBar(),
      resizeToAvoidBottomInset: false, //for prevent the keyboard from pushing the background
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Form(
              key: formKey,
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
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
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
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      obscureText: true,
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
          ),
        ],
      ),
    );
  }
}
