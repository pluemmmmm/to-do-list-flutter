import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/dependency_injection.dart';
import 'package:my_app/screen/add_to_do_screen.dart';
import 'package:my_app/screen/sign_in_screen.dart';
import 'package:my_app/screen/sign_up_screen.dart';
import 'package:my_app/screen/splash_screen.dart';
import 'package:my_app/screen/to_do_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init(); // call Injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(), // use outfit all project
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const SignIn(),
        '/sign_up': (context) => const SignUp(),
        '/to_do_list': (context) => const ToDoList(),
        '/add_to_do': (context) => const AddToDo(),
      },
    );
  }
}