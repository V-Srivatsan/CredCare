import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Response {
  final bool success;
  final Map<String, dynamic> data;

  Response(this.success, this.data);
}

enum REQUEST { GET, POST, PUT, DELETE, PATCH }

Future<Response> makeRequest(
  String path, REQUEST method, {
    Map<String, dynamic>? data = null,
  }
) async {
  final url = Uri.https("sponge-romantic-pangolin.ngrok-free.app", path);

  final Map<String, String> headers = method == REQUEST.GET ? {} : {"Content-Type": "application/json"};
  final http.Response response;

  final token = await FlutterSecureStorage().read(key: "token");
  if (token != null)
    headers["Authorization"] = "Bearer $token";

  switch (method) {
    case REQUEST.GET:
      response = await http.get(url, headers: headers);
      break;
    case REQUEST.POST:
      response = await http.post(url, headers: headers, body: jsonEncode(data));
      break;
    case REQUEST.PUT:
      response = await http.put(url, headers: headers, body: jsonEncode(data));
      break;
    case REQUEST.DELETE:
      response =
      await http.delete(url, headers: headers, body: jsonEncode(data));
      break;
    default:
      response =
      await http.patch(url, headers: headers, body: jsonEncode(data));
      break;
  }

  return Response(response.statusCode == 200, jsonDecode(response.body));
}