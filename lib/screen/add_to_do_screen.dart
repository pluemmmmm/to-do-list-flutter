import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screen/to_do_list_screen.dart';

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
      final response = await http.post(
        Uri.parse('http://10.91.114.28:6004/api/create_todo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
        },
        body: body,
      );
      // print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
      final responseData = response.body;
      // print('Response: $responseData');
      try {
        final Map<String, dynamic> data = jsonDecode(responseData);
        if (data.containsKey('code') && data['code'] == 'ER_DATA_TOO_LONG') {
          _showErrorDialog(context, 'ข้อมูลยาวเกินไป', 'กรุณาปรับลดความยาวของข้อมูลที่กรอก');
          return;
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ToDoList(userData: data)),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        if (response.body == 'OK') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ToDo created successfully')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ToDoList(
                userData: {
                  'user_id': userId,
                  'user_fname': userFname,
                  'user_lname': userLname,
                },
              ),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An unexpected error occurred.')),
          );
        }
      }
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save')),
        );
      }
    } catch (e) {
      print('error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection')),
      );
    }
  }

  Future<void>updateToDo(String userTodoListTitle, String userTodoListDesc) async {
    try {
    final body = jsonEncode({
      'user_todo_list_id': userTodoListId,
      'user_todo_list_title': userTodoListTitle,
      'user_todo_list_desc': userTodoListDesc,
      'user_todo_list_completed': isSwitchedOn.toString(),
      'user_id': userId,
      'user_todo_type_id': '1',
    });

    final response = await http.post(
      Uri.parse('http://10.91.114.28:6004/api/update_todo'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = response.body;
      // print('Response: $responseData');
      try {
        final Map<String, dynamic> data = jsonDecode(responseData);
        if (data.containsKey('code') && data['code'] == 'ER_DATA_TOO_LONG') {
          _showErrorDialog(context, 'ข้อมูลยาวเกินไป', 'กรุณาปรับลดความยาวของข้อมูลที่กรอก');
          return;
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ToDoList(userData: data)),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        if (response.body == 'OK') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ToDo created successfully')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ToDoList(
                userData: {
                  'user_id': userId,
                  'user_fname': userFname,
                  'user_lname': userLname,
                },
              ),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An unexpected error occurred.')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update ToDo')),
      );
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No internet connection')),
    );
  }
}

void _showErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 40.0,),
          ],
        ),
        content:const Text('Input is too long', textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
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
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            // Custom AppBar
            PreferredSize(
              preferredSize: const Size.fromHeight(105.0), // hieght
              child: Container(
                height: 105, // hieght
                padding: const EdgeInsets.only(left: 20, top: 50, bottom: 10), // เพิ่ม padding ด้านบน
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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
                  offset: const Offset(0, -5), // เลื่อนลง 10px
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => ToDoList(
                                userData: {
                                  'user_id': userId,
                                  'user_fname': userFname,
                                  'user_lname': userLname,
                                },
                              ),
                            ),
                            (Route<dynamic> route) => false,
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
                      const Text(
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: TextFormField(
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                                controller: userTodoListTitleController,
                                focusNode: titleFocus,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: const InputDecoration(
                                  hintText: 'Title',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                onFieldSubmitted: (_) {
                                  titleFocus.unfocus();
                                  FocusScope.of(context).requestFocus(descFocus);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your description';
                                  }
                                  if (value.trim().isEmpty) {
                                    return 'Description cannot be just spaces';
                                  }
                                  if (value.startsWith(' ') || value.endsWith(' ')) {
                                    return 'Description cannot start or end with a space';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                              controller: userTodoListDescController,
                              focusNode: descFocus,
                              decoration: const InputDecoration(
                                hintText: 'Description',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 16.0),
                              ),
                              maxLines: 7, // line
                              textInputAction: TextInputAction.done, // เปลี่ยนการกระทำของปุ่ม Enter
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your description';
                                }
                                if (value.trim().isEmpty) {
                                  return 'Description cannot be just spaces';
                                }
                                if (value.startsWith(' ') || value.endsWith(' ')) {
                                  return 'Description cannot start or end with a space';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Container(
                            width: double.infinity, // กำหนดความกว้างให้เต็มที่
                            // height: MediaQuery.of(context).size.height * 0.06,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
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
                                      color: const Color(0xFF0D7A5C),
                                    ),
                                  ),
                                ),
                                const Spacer(),
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
                            width: double.infinity, // กำหนดความกว้างให้เต็มที่
                            height: 70,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
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
                                  }
                                },
                                child: const Text(
                                  'Save',
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
            ),
          ],
        ),
      ),
    );
  }
}