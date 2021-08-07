import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/productList.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

class ShopCourse extends StatefulWidget {
  static var route = '/shopCourse';

  @override
  _ShopCourseState createState() => _ShopCourseState();
}

class _ShopCourseState extends State<ShopCourse> {
  Future<List<Courses>> _getUsers() async {
    var response = await post(
      Uri.parse('https://chickensmood.com/api/category.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"mobile_number": "none", "token": "none"}
      ]),
    );
    var jsonData = json.decode(response.body);

    var listUser = jsonData;

    List<Courses> users = [];

    var u = listUser;

    for (int i = 0; i <= listUser.length - 1; i++) {
      var name = u[i]['category_name'];
      var id = u[i]['cat_id'].toString();
      var pic = "https://chickensmood.com/api/" + u[i]['category_photo'];
      Courses user = Courses(id, name, pic);

      users.add(user);
    }

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
                  child: SpinKitCubeGrid(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, ProductList.route,
                                arguments: snapshot.data[index].id);
                          },
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(snapshot.data[index].avatar),
                          ),
                          title: Text(
                            snapshot.data[index].name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        child: Divider(
                          thickness: 3,
                        ),
                      ),
                    ],
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

class Courses {
  final String id;
  final String name;
  final String avatar;

  Courses(this.id, this.name, this.avatar);
}
