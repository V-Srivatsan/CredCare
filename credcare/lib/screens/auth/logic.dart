import 'package:credcare/net/main.dart' as net;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<net.Response> login(String phone) async {
  return await net.makeRequest(
      "/user/login", .POST,
      data: { "phone": phone }
  );
}

Future<net.Response> register(String name, String phone) async {
  return await net.makeRequest(
    "/user/register", .POST,
    data: { "phone": phone, "name": name }
  );
}

Future<net.Response> verifyOTP(String phone, String otp) async {
  final res = await net.makeRequest(
    "/user/verify-otp", .POST,
    data: { "phone": phone, "otp": otp }
  );

  if (res.success) {
    final storage = FlutterSecureStorage();
    await storage.write(key: "token", value: res.data["token"]);
  }

  return res;
}

Future<bool> isLogged() async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: "token");
  return token != null;
}