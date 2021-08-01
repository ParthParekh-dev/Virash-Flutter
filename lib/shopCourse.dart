import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'shopCoursePOJO.dart';

class ShopCourse extends StatefulWidget {
  static var route = '/shopCourse';

  @override
  _ShopCourseState createState() => _ShopCourseState();
}

class _ShopCourseState extends State<ShopCourse> {
  Future<List<Courses>> _getUsers() async {
    var response = await get(Uri.parse('https://reqres.in/api/users?page=2'));
    var jsonData = json.decode(response.body);
    print(jsonData['data']);

    var listUser = jsonData['data'];
    List<Courses> users = [];

    for (var u in listUser) {
      Courses user = Courses(
          u['id'], u['email'], u['first_name'], u['last_name'], u['avatar']);
      users.add(user);
    }

    print(users.length);

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All courses'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading'),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data[index].avatar),
                    ),
                    title: Text(
                      snapshot.data[index].firstName +
                          " " +
                          snapshot.data[index].lastName,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data[index].email,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
