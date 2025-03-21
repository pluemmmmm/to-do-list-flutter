import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/screen/to_do_list_screen.dart';
import 'package:my_app/service/to_do_service.dart';

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
  void initState() { // เกิดอะไรขึ้นหลังจาก render ครั้งแรก
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

  // Call API
  Future<void> fetchTodoDetails() async {
    final todoItem = await ToDoService.fetchTodoDetails(context, userId, userTodoListId);
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
    }
  }

  Future<void> createToDo(String userTodoListTitle, String userTodoListDesc) async {
    await ToDoService.createToDo(
      context,
      userId,
      userFname,
      userLname,
      userTodoListTitle,
      userTodoListDesc,
      isSwitchedOn,
    );
  }

  Future<void> updateToDo(String userTodoListTitle, String userTodoListDesc) async {
    await ToDoService.updateToDo(
      context,
      userTodoListId,
      userTodoListTitle,
      userTodoListDesc,
      isSwitchedOn,
      userId,
      userFname,
      userLname,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // For focus out of keyboard and (การกระทำที่เกิดขึ้นเมื่อมีการแตะหน้าจอ)
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
                      GestureDetector( // For focus out of keyboard and (การกระทำที่เกิดขึ้นเมื่อมีการแตะหน้าจอ)
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
            Expanded( // มักจะใช้ร่วมกับ Row หรือ Column เพื่อให้ลูกวิดเจ็ตขยายขนาดตามพื้นที่ที่เหลืออยู่
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
                                textAlignVertical: TextAlignVertical.center, //vertical Y, horizontal X
                                decoration: const InputDecoration( // For custom input
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
                                contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
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
                                const Padding(
                                  padding: EdgeInsets.only(left: 17.0),
                                  child: Text(
                                    'Success',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0D7A5C),
                                    ),
                                  ),
                                ),
                                const Spacer(), // For left align
                                GestureDetector( // For focus out of keyboard and (การกระทำที่เกิดขึ้นเมื่อมีการแตะหน้าจอ)
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
