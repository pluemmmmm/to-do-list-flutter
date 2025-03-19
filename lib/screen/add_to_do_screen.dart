import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screen/to_do_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToDo extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const AddToDo({super.key, this.userData});

  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  Map<String, dynamic>? userData;
  bool isSwitchedOn = false;
  String userId = '';
  String userFname = '';
  String userLname = '';
  String userTodoListId = '';

  final TextEditingController userTodoTypeIdController = TextEditingController();
  final TextEditingController userTodoListTitleController = TextEditingController();
  final TextEditingController userTodoListDescController = TextEditingController();
  final TextEditingController userTodoListCompletedController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
    userFname = userData?['user_fname'] ?? '';
    userLname = userData?['user_lname'] ?? '';
    userId = userData?['user_id']?.toString() ?? '';
    userTodoListId = userData?['user_todo_list_id']?.toString() ?? ''; 

    if (userTodoListId.isNotEmpty) {
      fetchTodoDetails(); // ดึงข้อมูลถ้ามี user_todo_list_id
    }
  }

  @override
  void dispose() {
    userTodoTypeIdController.dispose();
    userTodoListTitleController.dispose();
    userTodoListDescController.dispose();
    userTodoListCompletedController.dispose();
    userIdController.dispose();
    super.dispose();
  }

  Future<void>fetchTodoDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.91.114.28:6004/api/todo_list/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
        },
      );
      // print('1214 ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final todoItem = data.firstWhere(
          (item) => item['user_todo_list_id'].toString() == userTodoListId,
          orElse: () => null,
        );

        if (todoItem != null) {
          setState(() {
            userTodoListTitleController.text = todoItem['user_todo_list_title'] ?? '';
            userTodoListDescController.text = todoItem['user_todo_list_desc'] ?? '';
            switch (todoItem['user_todo_list_completed']) {
              case 'true':
                isSwitchedOn = true;
                break;
              case 'false':
                isSwitchedOn = false;
                break;
              default:
                isSwitchedOn = false;
                break;
            }
          });
        } else {
          print('ToDo item not found');
        }
      } else {
        print('Failed to load ToDo details');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void>createToDo(String userTodoListTitle, String userTodoListDesc) async {
    try {
      final body = jsonEncode(<String, String>{
        'user_todo_type_id': '1',
        'user_todo_list_title': userTodoListTitle,
        'user_todo_list_desc': userTodoListDesc,
        'user_todo_list_completed': isSwitchedOn.toString(),
        'user_id': userId,
      });
      print('Request Body: $body');
      final response = await http.post(
        Uri.parse('http://10.91.114.28:6004/api/create_todo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
        },
        body: body,
      );
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        if (response.body == 'OK') {
          // Handle the plain text response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ToDo created successfully')),
          );
          Navigator.pushReplacement(
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
          final Map<String, dynamic> data = jsonDecode(response.body);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ToDoList(
                userData: data,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save')),
        );
      }
    } catch (e) {
      print('error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection')),
      );
    }
  }

  Future<void>updateToDo(String userTodoListTitle, String userTodoListDesc) async {
    try {
      final body = jsonEncode(<String, String>{
        'user_todo_list_id': userTodoListId,
        'user_todo_list_title': userTodoListTitle,
        'user_todo_list_desc': userTodoListDesc,
        'user_todo_list_completed': isSwitchedOn.toString(),
        'user_id': userId,
        'user_todo_type_id': '1',
      });
      // print('Request Body: $body');
      final response = await http.post(
        Uri.parse('http://10.91.114.28:6004/api/update_todo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
        },
        body: body,
      );
      // print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        if (response.body == 'OK') {
          // Handle the plain text response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ToDo created successfully')),
          );
          Navigator.pushReplacement(
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
          final Map<String, dynamic> data = jsonDecode(response.body);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ToDoList(
                userData: data,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save')),
        );
      }
    } catch (e) {
      print('error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom AppBar
          PreferredSize(
            preferredSize: const Size.fromHeight(105.0), // hieght
            child: Container(
              height: 105, // hieght
              padding: const EdgeInsets.only(left: 20, top: 50, bottom: 10), // เพิ่ม padding ด้านบน
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color.fromRGBO(76, 197, 153, 1),
                    Color.fromRGBO(13, 122, 92, 1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [1.0, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Transform.translate(
                offset: Offset(0, -5), // เลื่อนลง 10px
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
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
                      },
                      child: Image.asset(
                        'assets/images/icon_arrow_left.png',
                        color: Colors.white,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Add Your ToDo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Body Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // Add padding at the bottom
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        height: 65.0, // กำหนดความสูงให้เท่ากับ Search
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0), // ขอบมนเท่ากับ Search
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          controller: userTodoListTitleController,
                          focusNode: titleFocus,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                          ),
                          onFieldSubmitted: (_) {
                            titleFocus.unfocus();
                            FocusScope.of(context).requestFocus(descFocus);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        height: 175.0, // กำหนดความสูงให้เท่ากับ Search
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0), // ขอบมนเท่ากับ Search
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          controller: userTodoListDescController,
                          focusNode: descFocus,
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                          ),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 17.0),
                              child: Text(
                                'Success',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0D7A5C),
                                )
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSwitchedOn = !isSwitchedOn;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.asset(
                                  isSwitchedOn ? 'assets/images/switch_on.png' : 'assets/images/switch_off.png',
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 280),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0), // padding left and right
                      child: SizedBox(
                        width: 410,
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
                              if (userTodoListId.isNotEmpty) {
                                updateToDo(
                                  userTodoListTitleController.text,
                                  userTodoListDescController.text,
                                );
                              } else {
                                createToDo(
                                  userTodoListTitleController.text,
                                  userTodoListDescController.text,
                                );
                              }
                            },
                            child: const Text(
                              'SAVE',
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
    );
  }
}