import 'package:flutter/material.dart';
import 'package:my_app/screen/to_do_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    String userId = prefs.getString('user_id') ?? '';
    String userFname = prefs.getString('user_fname') ?? '';
    String userLname = prefs.getString('user_lname') ?? '';
    // print('1111 $isLoggedIn');
    // print('2222 $userId');
    // print('3333 $userFname');
    // print('4444 $userLname');

    if (isLoggedIn) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => ToDoList(
            userData: {
              'user_id': userId,
              'user_fname': userFname,
              'user_lname': userLname,
            },
          ),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
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