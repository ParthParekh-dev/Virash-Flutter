import 'dart:convert';
import 'dart:io';

import 'package:flutter_virash/helpers/httpResponse.dart';
import 'package:flutter_virash/objective/mcqPojo.dart';
import 'package:http/http.dart';

class APIHelper {
  Future<HTTPResponse<List<MCQPojo>>> getMCQS(
      {required String mobile,
      required String userId,
      required int mcqId}) async {
    try {
      var response = await post(
        Uri.parse("https://virashtechnologies.com/unique/api/mcqQaList.php"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([
          {"mobile_number": mobile, "user_id": userId, "mcq_id": mcqId}
        ]),
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List<MCQPojo> mcqs = [];
        body.forEach((e) {
          MCQPojo mcq = MCQPojo.fromJson(e);
          mcqs.add(mcq);
        });
        return HTTPResponse<List<MCQPojo>>(
          true,
          mcqs,
          message: 'Request Successful',
          statusCode: response.statusCode,
        );
      } else {
        return HTTPResponse<List<MCQPojo>>(
          false,
          null,
          message:
              'Invalid data received from the server! Please try again in a moment.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      print('SOCKET EXCEPTION OCCURRED');
      return HTTPResponse<List<MCQPojo>>(
        false,
        null,
        message: 'Unable to reach the internet! Please try again in a moment.',
      );
    } on FormatException {
      print('JSON FORMAT EXCEPTION OCCURRED');
      return HTTPResponse<List<MCQPojo>>(
        false,
        null,
        message:
            'Invalid data received from the server! Please try again in a moment.',
      );
    } catch (e) {
      print('UNEXPECTED ERROR');
      print(e.toString());
      return HTTPResponse<List<MCQPojo>>(
        false,
        null,
        message: 'Something went wrong! Please try again in a moment!',
      );
    }
  }
}
