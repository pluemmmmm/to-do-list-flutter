import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:my_app/screen/sign_in_screen.dart';
import 'package:my_app/service/sign_up_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userFnameController = TextEditingController();
  final TextEditingController userLnameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final FocusNode fnameFocusNode = FocusNode();
  final FocusNode lnameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  Future<void> signUp(String email, String password, String userFname, String userLname) async {
    await SignUpService.signUp(context, email, password, userFname, userLname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // can up or down for touch
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
            SingleChildScrollView(
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignIn()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/icon_arrow_left.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
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
                            controller: userFnameController,
                            focusNode: fnameFocusNode,
                            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'First name',
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(lnameFocusNode);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
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
                            controller: userLnameController,
                            focusNode: lnameFocusNode,
                            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Last name',
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(emailFocusNode);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
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
                            controller: emailController,
                            focusNode: emailFocusNode,
                            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
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
                              } else if (!value.contains('@') ||
                                  !value.endsWith('.com') ||
                                  (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) ||
                                  (RegExp(r'[ก-๙]').hasMatch(value))) {
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
                            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
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
                                  signUp(emailController.text, passwordController.text, userFnameController.text, userLnameController.text);
                                }
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
            ),
          ],
        ),
      ),
    );
  }
}
