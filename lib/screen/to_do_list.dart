import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  bool isChecked = false; // Moved outside of build method

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? userData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    String firstName = userData?['user_fname'] ?? '';
    String lastName = userData?['user_lname'] ?? '';
    int userId = userData?['user_id'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CC599), Color(0xFF4CC599)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // สีเงา
                blurRadius: 3, // ค่าความเบลอของเงา
                spreadRadius: 1, // ระยะกระจายของเงา
                offset: Offset(0, 2), // ตำแหน่งเงา (x, y)
              ),
            ],
          ),
        ),
        toolbarHeight: 82.0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10.0),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 270,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SIGN OUT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 13),
                          Text(
                            'Do you want to log out?',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, '/home');
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/icon_signout.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF0D7A5C),
                                      ),
                                    ),
                                    const SizedBox(width: 200),
                                    Image.asset(
                                      'assets/images/icon_arrow_right.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 40,
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
                            color: Colors.grey[200],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(
                child: Text(
                  firstName[0], // แสดงตัวอักษรตัวแรกของ firstName
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Color(0xFF4CC599),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello!',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                '$firstName $lastName',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 65.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        hintText: 'Search.......',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search_sharp, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.14,
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
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20.0,
                        left: 8.0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
                          },
                          child: Image.asset(
                            isChecked
                                ? 'assets/images/icon_check_radio.png'
                                : 'assets/images/icon_radio.png',
                            width: 24.0,
                            height: 24.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5.0,
                        right: 10.0,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 270,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 50.0, bottom: 5.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushReplacementNamed(context, '/home');
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/icon_edit.png',
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0xFF0D7A5C),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 230),
                                                  Image.asset(
                                                    'assets/images/icon_arrow_right.png',
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 40,
                                          thickness: 1,
                                          indent: 50,
                                          endIndent: 50,
                                          color: Colors.grey[200],
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 50.0, top: 5.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushReplacementNamed(context, '/home');
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/icon_delete.png',
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0xFF0D7A5C),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 230),
                                                  Image.asset(
                                                    'assets/images/icon_arrow_right.png',
                                                    width: 40,
                                                    height: 40,
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
                              },
                            );
                          },
                          child: Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                            size: 27.0,
                          ),
                        ),
                      ),
                      Center(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 25.0, 
            right: 25.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/add_to_do');
              },
              child: Transform.scale(
                scale: 1.5, // ปรับขนาดตามต้องการ
                child: Image.asset(
                  'assets/images/icon_calendar.png',
                  width: 45.0, // ขนาดดั้งเดิม
                  height: 45.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}