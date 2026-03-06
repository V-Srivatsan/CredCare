import 'package:credcare/net/main.dart' as net;

Future<net.Response> createRequest(String title, String desc) async {
  return await net.makeRequest("/requests/", .POST, data: { "title": title, "description": desc });
}

Future<net.Response> getPendingRequests() async {
  return await net.makeRequest("/requests/", .GET);
}

Future<net.Response> getCreatedRequests() async {
   return await net.makeRequest("/requests/created", .GET);
}

Future<net.Response> getAcceptedRequests() async {
  return await net.makeRequest("/requests/accepted", .GET);
}

Future<net.Response> acceptRequest(String uid) async {
  return await net.makeRequest('/requests/accept/$uid', .PUT);
}

Future<net.Response> optOutRequest(String uid) async {
  return await net.makeRequest('/requests/accept/$uid', .DELETE);
}

Future<net.Response> completeRequest(String uid) async {
  return await net.makeRequest('/requests/complete/$uid', .PUT);
}

Future<net.Response> cancelRequest(String uid) async {
  return await net.makeRequest('/requests/$uid', .DELETE);
}