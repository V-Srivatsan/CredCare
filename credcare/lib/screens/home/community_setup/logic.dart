import 'package:credcare/net/main.dart' as net;

Future<net.Response> createCommunity(String name) async {
  return await net.makeRequest("/community/", .POST, data: { "name": name });
}

Future<net.Response> getCommunities() async {
  return await net.makeRequest("/community/", .GET);
}

Future<net.Response> joinCommunity(String uid) async {
  return await net.makeRequest('/community/join/$uid', .POST);
}