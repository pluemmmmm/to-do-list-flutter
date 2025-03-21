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
  //TextEditingController for manage text input
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
    return Scaffold( // Basic design of the screen (layout and other)
      // appBar: AppBar(),
      resizeToAvoidBottomInset: false, //for prevent the keyboard from pushing the background
      body: GestureDetector( // For focus out of keyboard and (การกระทำที่เกิดขึ้นเมื่อมีการแตะหน้าจอ)
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
                      child: Container( // For adjust colors, size and other properties
                        decoration: BoxDecoration( //มักใช้กับ Container หรือ BoxDecoration เพื่อกำหนดสไตล์ เช่น สีพื้นหลัง, เส้นขอบ, เงา เป็นต้น
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow( //Shadow for objects
                              color: Colors.grey.withOpacity(0.6), // For manage ความทึบ
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextFormField( // For validation
                          controller: emailController,
                          focusNode: emailFocusNode,
                          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))], // For dont space bar
                          decoration: const InputDecoration( // For custom input
                            border: InputBorder.none,
                            labelText: 'Email',
                            filled: true, //กำหนดให้พื้นหลังของช่องกรอกข้อมูลถูกเติมสี
                            fillColor: Colors.transparent,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (_) { // Out of Keyboard
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
                              spreadRadius: 1, // การกระจายของเงา ออกไปจากขอบของวัตถุ
                              blurRadius: 1, // ความเบลอของเงา ถ้ายิ่งเพิ่มค่ามาก เงาจะยิ่งฟุ้งและกระจายมากขึ้น
                              offset: const Offset(0, 1), // Shadow for x and y
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          focusNode: passwordFocusNode, // For next timing
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
                                setState(() { // Check change states for new state
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
                              if (formKey.currentState!.validate()) { // Check Form formKey ถ้าฟอร์มถูกต้อง (validate() คืนค่าเป็น true) จะทำการเรียกฟังก์ชัน signIn
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
                            gradient: const LinearGradient( // ใช้สำหรับการสร้างการไล่ระดับสี
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
