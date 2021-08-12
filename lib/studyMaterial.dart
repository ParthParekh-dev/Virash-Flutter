import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/pdfViewer.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudyMaterial extends StatefulWidget {
  static var route = '/studyMaterial';

  @override
  _StudyMaterialState createState() => _StudyMaterialState();
}

class _StudyMaterialState extends State<StudyMaterial> {
  late SharedPreferences prefs;

  Future<List<PdfDetails>> _getMaterials(String chapter_id) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('chapter_id', chapter_id);

    var response = await post(
      Uri.parse('https://virashtechnologies.com/unique/api/study-material.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {
          "mobile_number": prefs.getString('mobile')!,
          "user_id": prefs.getString('user_id')!,
          "exam_id": prefs.getString('exam_id')!,
          "subject_id": prefs.getString('subject_id')!,
          "chapter_id": prefs.getString('chapter_id')!
        }
      ]),
    );
    var jsonData = json.decode(response.body);

    var listMaterial = jsonData;

    List<PdfDetails> users = [];

    var u = listMaterial;

    for (int i = 0; i <= listMaterial.length - 1; i++) {
      var name = u[i]['title'];
      var attachment = u[i]['attachment'];
      var id = u[i]['id'].toString();
      var pic = u[i]['thumbnail'];
      PdfDetails user = PdfDetails(id, name, pic, attachment);

      users.add(user);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var chapter_id = args.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Study Material'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getMaterials(chapter_id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: SpinKitCubeGrid(
                    color: Color(0xFFFF7801),
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
                            Navigator.pushNamed(context, PdfViewer.route,
                                arguments: snapshot.data[index].attachment);
                          },
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(snapshot.data[index].avatar),
                          ),
                          title: Text(
                            snapshot.data[index].title,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 30),
                        child: Divider(
                          thickness: 1,
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

class PdfDetails {
  final String id;
  final String title;
  final String avatar;
  final String attachment;

  PdfDetails(this.id, this.title, this.avatar, this.attachment);
}
