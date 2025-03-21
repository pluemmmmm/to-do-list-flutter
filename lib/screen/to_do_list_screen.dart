import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_app/screen/add_to_do_screen.dart';
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
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.pink,
    Colors.teal,
  ];

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

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
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load to-do list');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection')),
      );
      return [];
    }
  }

  Future<void> deleteToDoListById(String userTodoListId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.91.114.48:6004/api/delete_todo/$userTodoListId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delete successfully')),
        );
        setState(() {});
      } else {
        throw Exception('Failed to delete to-do list');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection')),
      );
    }
  }

  void _showSignOutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 270,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'SIGN OUT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
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
                    child: InkWell(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('user_id');
                        await prefs.remove('user_email');
                        await prefs.remove('user_fname');
                        await prefs.remove('user_lname');
                        await prefs.remove('is_logged_in');
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
                          const Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF0D7A5C),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 150.0),
                            child: Image.asset(
                              'assets/images/icon_arrow_right.png',
                              width: 40,
                              height: 40,
                            ),
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          flexibleSpace: Container(
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
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
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
                _showSignOutBottomSheet(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(
                  child: Text(
                    firstName[0],
                    style: const TextStyle(
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
            child: InkWell(
              onTap: () {
                _showSignOutBottomSheet(context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
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
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.toLowerCase();
                              });
                            },
                            style: const TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              hintText: 'Search.......',
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: const Icon(Icons.search_sharp,
                                  color: Colors.grey),
                              suffixIcon: Visibility(
                                visible: searchController.text.isNotEmpty,
                                child: IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      searchController.clear();
                                      searchQuery = '';
                                    });
                                  },
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<List<dynamic>>(
                      future: getToDoListById(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'No Data',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[400]),
                            ),
                          );
                        } else {
                          var filteredList = snapshot.data!.where((item) {
                            return item['user_todo_list_title']
                                .toLowerCase()
                                .contains(searchQuery);
                          }).toList();

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              var item = filteredList[index];
                              return ToDoListItem(
                                item: item,
                                onEdit: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddToDo(
                                        userData: {
                                          'user_id': userId,
                                          'user_fname': firstName,
                                          'user_lname': lastName,
                                          'user_todo_list_id':
                                              item['user_todo_list_id'],
                                        },
                                      ),
                                    ),
                                  );
                                },
                                onDelete: () {
                                  deleteToDoListById(
                                      item['user_todo_list_id'].toString());
                                },
                                color: colors[index % colors.length],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 25.0,
              right: 25.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddToDo(
                        userData: {
                          'user_id': userId,
                          'user_fname': firstName,
                          'user_lname': lastName,
                        },
                      ),
                    ),
                  );
                },
                child: Transform.scale(
                  scale: 1.5, // ปรับขนาดตามต้องการ
                  child: Image.asset(
                    'assets/images/icon_calendar.png',
                    width: 45.0,
                    height: 45.0,
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

class ToDoListItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color color;

  const ToDoListItem({
    Key? key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Column(
        children: [
          Container(
            height: 140.0,
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
                  left: 27.0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              '${item['user_todo_list_title']}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: color,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('hh:mm a -MM/dd/yy', 'en').format(
                                DateTime.parse(
                                        item['user_todo_list_last_update'])
                                    .toLocal()),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                '${item['user_todo_list_desc']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
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
                          return SizedBox(
                            height: 270,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50.0, bottom: 5.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: onEdit,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/icon_edit.png',
                                                width: 40,
                                                height: 40,
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                'Edit',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFF0D7A5C),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 170.0),
                                                child: Image.asset(
                                                  'assets/images/icon_arrow_right.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                            ],
                                          ),
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
                                      padding: const EdgeInsets.only(
                                          left: 50.0, top: 5.0),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.warning,
                                                        color: Colors.red,
                                                        size: 40.0),
                                                  ],
                                                ),
                                                content: const Text(
                                                  'Are you sure you want to delete?',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            colors: <Color>[
                                                              Color.fromRGBO(
                                                                  169,
                                                                  169,
                                                                  169,
                                                                  1),
                                                              Color.fromRGBO(
                                                                  105,
                                                                  105,
                                                                  105,
                                                                  1),
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        child: TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            colors: <Color>[
                                                              Color.fromRGBO(
                                                                  255, 0, 0, 1),
                                                              Color.fromRGBO(
                                                                  139, 0, 0, 1),
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        child: TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                          ),
                                                          onPressed: () {
                                                            onDelete();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/icon_delete.png',
                                              width: 40,
                                              height: 40,
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              'Delete',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF0D7A5C),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 150.0),
                                              child: Image.asset(
                                                'assets/images/icon_arrow_right.png',
                                                width: 40,
                                                height: 40,
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
                        },
                      );
                    },
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.grey,
                      size: 27.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
