import 'package:credcare/net/main.dart' as net;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> logout() async {
  await FlutterSecureStorage().delete(key: "token");
}

Future<net.Response> getProfile() async {
  return await net.makeRequest("/user/", .GET);
}

Future<net.Response> getCommunityRequests() async {
  return await net.makeRequest("/community/requests", .GET);
}

Future<net.Response> approve(String uid) async {
  return await net.makeRequest("/community/verify/$uid", .PUT);
}

Future<net.Response> leaveCommunity() async {
  return await net.makeRequest('/community/leave/', .DELETE);
}