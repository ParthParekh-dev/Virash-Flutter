import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'dart:convert';

class WhatsappForm extends StatefulWidget {
  WhatsappForm({Key? key}) : super(key: key);

  static var route = '/whatsappForm';

  @override
  _WhatsappFormState createState() => _WhatsappFormState();
}

class _WhatsappFormState extends State<WhatsappForm> {
  List _courses = [];
  var selectedCourse;

  List _exams = [];
  var selectedExam;

  List _attempts = [];
  var selectedAttempt;

  var selectedGender;

  var name = TextEditingController();
  var email = TextEditingController();
  var number = TextEditingController();

  bool loading = false;

  List _cities = [];
  var selectedCity;

  List _purpose = ["Testing", "Testing 2", "Testing 3"];
  var selectedPurpose;

  Future<String> fetchCourse() async {
    final url = "https://virashtechnologies.com/unique/api/course.php";
    var res = await get(Uri.parse(url));
    final resBody = jsonDecode(res.body) as List;
    setState(() {
      _courses = resBody;
    });
    return "Success";
  }

  Future<String> fetchExams(int courseId) async {
    final url = "https://virashtechnologies.com/unique/api/exam.php";
    var res = await post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        <String, int>{"course_id": courseId}
      ]),
    );
    final resBody = jsonDecode(res.body) as List;
    setState(() {
      _exams = resBody;
      selectedExam = null;
    });
    return "Success";
  }

  Future<String> fetchAttempts() async {
    final url = "https://virashtechnologies.com/unique/api/attempt.php";
    var res = await get(Uri.parse(url));
    final resBody = jsonDecode(res.body) as List;
    setState(() {
      _attempts = resBody;
    });
    return "Success";
  }

  Future<String> fetchCities() async {
    final url = "https://virashtechnologies.com/unique/api/cities.php";
    var res = await get(Uri.parse(url));
    final resBody = jsonDecode(res.body) as List;
    setState(() {
      _cities = resBody;
    });
    return "Success";
  }

  void submitData() async {
    if (name.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter Your Name!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    } else if (number.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter Your Mobile Number!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    } else if (number.text.length < 10) {
      Fluttertoast.showToast(
          msg: "Please Enter Valid Mobile Number!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    } else if (email.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter Your Email ID!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    } else if (selectedGender == null) {
      Fluttertoast.showToast(
          msg: "Please Select Your Gender!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    } else if (selectedCourse == null) {
      Fluttertoast.showToast(
          msg: "Please Select Your Course!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    } else if (selectedExam == null) {
      Fluttertoast.showToast(
          msg: "Please Select Your Exam!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    } else if (selectedAttempt == null) {
      Fluttertoast.showToast(
          msg: "Please Select Your Attempts!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    } else if (selectedCity == null) {
      Fluttertoast.showToast(
          msg: "Please Select Your City!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    } else if (selectedPurpose == null) {
      Fluttertoast.showToast(
          msg: "Please Select Your Purpose!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    } else {
      setState(() {
        loading = true;
      });

      // Network Call
      final url =
          "https://virashtechnologies.com/unique/api/whatsapp-group.php";
      var data = <String, String>{
        "name": name.text,
        "mobile_number": number.text,
        "email": email.text,
        "course": "$selectedCourse",
        "exam": "$selectedExam",
        "attempt": "$selectedAttempt",
        "gender": selectedGender,
        "city": "$selectedCity",
        "purpose": selectedPurpose
      };
      var res = await post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([data]),
      );
      final resBody = jsonDecode(res.body) as List;

      if (resBody[0]["success"] == "1") {
        name.text = "";
        number.text = "";
        email.text = "";
        setState(() {
          selectedGender = null;
          selectedCourse = null;
          selectedExam = null;
          selectedAttempt = null;
          selectedCity = null;
          selectedPurpose = null;
        });
      }
      Fluttertoast.showToast(
          msg: resBody[0]["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    name.dispose();
    number.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchCourse();
    fetchAttempts();
    fetchCities();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Whatsapp Group Form'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFFFF7801))),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: "Enter Name",
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF7801)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextField(
                      controller: number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFFFF7801))),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: "Enter Mobile Number",
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF7801)),
                        ),
                        counterText: "",
                      ),
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFFFF7801))),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: "Enter Email Id",
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF7801)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Text(
                    'Select your gender:',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RadioListTile(
                              value: "Male",
                              groupValue: selectedGender,
                              title: Text("Male"),
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile(
                              value: "Female",
                              groupValue: selectedGender,
                              title: Text("Female"),
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              }),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 14.0),
                    margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.6), width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedCourse,
                      hint: Text(
                        "Select Course",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                      items: _courses.map(
                        (course) {
                          return DropdownMenuItem(
                            child: Text(
                              course['course_name'],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                            value: course['course_id'] as int,
                          );
                        },
                      ).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          selectedCourse = value ?? 0;
                        });
                        fetchExams(value ?? 0);
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 14.0),
                    margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.6), width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedExam,
                      hint: Text(
                        "Select Exam",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                      items: _exams.map(
                        (exam) {
                          return DropdownMenuItem(
                            child: Text(
                              exam['exam_name'],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                            value: exam['exam_id'] as int,
                          );
                        },
                      ).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          selectedExam = value ?? 0;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 14.0),
                    margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.6), width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedAttempt,
                      hint: Text(
                        "Select Attempts",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                      items: _attempts.map(
                        (attempt) {
                          return DropdownMenuItem(
                            child: Text(
                              attempt['attempt'],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                            value: attempt['attempt_id'] as int,
                          );
                        },
                      ).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          selectedAttempt = value ?? 0;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 14.0),
                    margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.6), width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedCity,
                      hint: Text(
                        "Select City",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                      items: _cities.map(
                        (city) {
                          return DropdownMenuItem(
                            child: Text(
                              city['name'],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                            value: city['id'] as int,
                          );
                        },
                      ).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          selectedCity = value ?? 0;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 14.0),
                    margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.6), width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedPurpose,
                      hint: Text(
                        "Select Purpose",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                      items: _purpose.map(
                        (val) {
                          return DropdownMenuItem(
                            child: Text(
                              val,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                            value: val as String,
                          );
                        },
                      ).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedPurpose = value ?? "";
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    color: Color(0xFFFF7801),
                    borderRadius: BorderRadius.circular(4),
                    child: InkWell(
                      onTap: submitData,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        alignment: Alignment.center,
                        child: loading
                            ? SpinKitCircle(
                                color: Colors.white,
                                size: 25.0,
                              )
                            : Text(
                                "Submit",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
