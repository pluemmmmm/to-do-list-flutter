import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

class ToDoList extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const ToDoList({super.key, this.userData});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  Map<String, dynamic>? userData;
  String firstName = '';
  String lastName = ''; 
  String userId = '';

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.pink,
    Colors.teal,
  ];

  @override
  void initState() {
    userData = widget.userData;
    firstName = userData?['user_fname'] ?? '';
    lastName = userData?['user_lname'] ?? '';
    userId = userData?['user_id']?.toString() ?? '';
    initializeDateFormatting('th');
    super.initState();
  }

  Future<List<dynamic>> getToDoListById() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.91.114.48:6004/api/todo_list/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
        },
      );
      print('7878 ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load to-do list');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection')),
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromRGBO(76, 197, 153, 1),
                Color.fromRGBO(13, 122, 92, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // สีเงา
                blurRadius: 4, // ค่าความเบลอของเงา
                spreadRadius: 0, // ระยะกระจายของเงา
                offset: Offset(0, 4), // ตำแหน่งเงา (x, y)
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
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('user_id');
                                  await prefs.remove('user_email');
                                  await prefs.remove('user_fname');
                                  await prefs.remove('user_lname');
                                  await prefs.remove('is_logged_in');
                                  
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
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
      body: FutureBuilder<List<dynamic>>(
        future: getToDoListById(),
        builder: (context, snapshot) {
          print('1212 $snapshot');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No to-do items found'));
          } else {
            return Stack(
              children: [
                Column(
                  children: [
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
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                            child: Column(
                              children: [
                                if (index != 0) SizedBox(height: 6.0),
                                Container(
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
                                          child: Image.asset(
                                            item['user_todo_list_completed'] == 'true'
                                                ? 'assets/images/icon_check_radio.png'
                                                : 'assets/images/icon_radio.png',
                                            width: 24.0,
                                            height: 24.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 16.0,
                                        left: 27.0, // ปรับตำแหน่งตามต้องการ
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 16.0), // ปรับ margin left ตามต้องการ
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start, // จัดตำแหน่งให้เป็น start
                                              children: [
                                                // Text('ID: ${item['user_todo_list_id']}'),
                                                Text(
                                                  '${item['user_todo_list_title']}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500, // medium
                                                    color: colors[index % colors.length],
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat('hh:mm a - MM/dd/yy', 'en') //en for AM/PM
                                                    .format(DateTime.parse(item['user_todo_list_last_update']).toLocal()),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.normal, // regular
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 7.0), // Adjust the top margin as needed
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
                                                    child: Text(
                                                      '${item['user_todo_list_desc']}',
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500, // medium
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                      // Align(
                                      //   alignment: Alignment.centerLeft,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(left: 16.0), // ปรับ margin left ตามต้องการ
                                      //     child: Column(
                                      //       mainAxisAlignment: MainAxisAlignment.center,
                                      //       crossAxisAlignment: CrossAxisAlignment.start, // จัดตำแหน่งให้เป็น start
                                      //       children: [
                                      //         Text('ID: ${item['user_todo_list_id']}'),
                                      //         Text('${item['user_todo_list_title']}'),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
            );
          }
        },
      ),
    );
  }
}
