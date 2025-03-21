import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/components/text_color.dart';
import 'package:my_app/components/to_do_card.dart';
import 'package:my_app/screen/add_to_do_screen.dart';
import 'package:my_app/service/to_do_service.dart';
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

  final List<Color> colors = TextColor.colors;

  late Future<List<dynamic>> toDoList;

  TextEditingController searchController = TextEditingController();
  String searchInput = '';

  @override
  void initState() {
    userData = widget.userData;
    firstName = userData?['user_fname'] ?? '';
    lastName = userData?['user_lname'] ?? '';
    userId = userData?['user_id']?.toString() ?? '';
    initializeDateFormatting('th');
    toDoList = getToDoListById();
    super.initState();
  }

  // call API
  Future<List<dynamic>> getToDoListById() async {
    return await ToDoService.getToDoListById(context, userId);
  }

  Future<void> deleteToDoListById(String userTodoListId) async {
    await ToDoService.deleteToDoListById(context, userTodoListId);
    setState(() {
      toDoList = getToDoListById();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope( // Manage back button on telephone
      onWillPop: () async {
        bool shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Confirm Exit',
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'Do you want to exit the app?',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(169, 169, 169, 1),
                          Color.fromRGBO(105, 105, 105, 1),
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
                      onPressed: () => Navigator.of(context).pop(false), //cancel
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
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
                      onPressed: () => Navigator.of(context).pop(true), //confirm
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        return shouldPop;
      },
      child: GestureDetector(
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
              child: GestureDetector( // For focus out of keyboard and (การกระทำที่เกิดขึ้นเมื่อมีการแตะหน้าจอ)
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
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
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
                                  child: GestureDetector(
                                    onTap: () async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
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
          body: RefreshIndicator( // For refresh page
            onRefresh: () async {
              getToDoListById();
            },
            color: const Color.fromRGBO(13, 122, 92, 1),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), //จะทำให้วิดเจ็ตสามารถเลื่อนได้เสมอ แม้ว่าจะมีเนื้อหาน้อยกว่าพื้นที่ที่สามารถแสดงผลได้
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
                              searchInput = value.toLowerCase();
                            });
                          },
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration( // For custom input
                            hintText: 'Search.......',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search_sharp, color: Colors.grey),
                            suffixIcon: Visibility(
                              visible: searchController.text.isNotEmpty,
                              child: IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    searchInput = '';
                                  });
                                },
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0), // vertical Y, horizontal X
                          ),
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<List<dynamic>>( // เพื่อสร้างวิดเจ็ตที่ขึ้นอยู่กับผลลัพธ์ของ Future
                    future: toDoList, // Future
                    builder: (context, snapshot) { // Snapshot for keep status of Future
                      if (snapshot.connectionState == ConnectionState.waiting) { // loading
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) { // Error
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // Empty
                        return Container(
                          margin: const EdgeInsets.only(top: 50.0), // เพิ่ม margin top 20.0
                          child: Text(
                            'No Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                        );
                      } else {
                        var filteredList = snapshot.data!.where((item) { // filteredList ถ้ามีข้อมูล จะกรองรายการตาม searchInput ที่ผู้ใช้ป้อนเข้ามา
                          return item['user_todo_list_title'].toLowerCase().contains(searchInput);
                        }).toList();

                        return ListView.builder(
                          shrinkWrap: true, // เพื่อให้ ListView ไม่เลื่อนเอง (เหมาะกับการใช้ใน SingleChildScrollView)
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            var item = filteredList[index];
                            return ToDoCard(
                              item: item,
                              userId: userId,
                              firstName: firstName,
                              lastName: lastName,
                              colors: colors,
                              index: index,
                              deleteToDoListById: deleteToDoListById,
                            );
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 25.0, right: 25.0),
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
              child: Transform.scale( // For scale FloatingActionButton
                scale: 1.5, // Size of FloatingActionButton
                child: Image.asset(
                  'assets/images/icon_calendar.png',
                  width: 45.0,
                  height: 45.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
