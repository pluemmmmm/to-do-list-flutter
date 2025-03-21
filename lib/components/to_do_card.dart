import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screen/add_to_do_screen.dart';

class ToDoCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final String userId;
  final String firstName;
  final String lastName;
  final List<Color> colors;
  final int index;
  final Function(String) deleteToDoListById;

  const ToDoCard({
    Key? key,
    required this.item,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.colors,
    required this.index,
    required this.deleteToDoListById,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Column(
        children: [
          if (index != 0) const SizedBox(height: 6.0),
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
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: colors[index % colors.length],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                DateFormat('hh:mm a -MM/dd/yy', 'en')
                                    .format(DateTime.parse(item['user_todo_list_last_update']).toLocal()),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.77,
                              child: Text(
                                '${item['user_todo_list_desc']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
                                      padding: const EdgeInsets.only(left: 50.0, bottom: 5.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AddToDo(
                                                  userData: {
                                                    'user_id': userId,
                                                    'user_fname': firstName,
                                                    'user_lname': lastName,
                                                    'user_todo_list_id': item['user_todo_list_id'],
                                                  },
                                                ),
                                              ),
                                            );
                                          },
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
                                                padding: const EdgeInsets.only(left: 170.0),
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
                                      padding: const EdgeInsets.only(left: 50.0, top: 5.0),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.warning, color: Colors.red, size: 40.0),
                                                  ],
                                                ),
                                                content: const Text(
                                                  'Are you sure you want to delete?',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            colors: <Color>[
                                                              Color.fromRGBO(255, 0, 0, 1),
                                                              Color.fromRGBO(139, 0, 0, 1),
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
                                                            deleteToDoListById(item['user_todo_list_id'].toString());
                                                            Navigator.of(context).pop();
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                              color: Colors.white,
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