import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/network_controller.dart';
import 'package:my_app/screen/sign_up_screen.dart';
import 'package:my_app/service/sign_in_service.dart';

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
    await SignInService.signIn(context, email, password);
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
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUp()), // แทนที่ SignUp ด้วยหน้าที่คุณต้องการ
                                (Route<dynamic> route) => false,
                              );
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
