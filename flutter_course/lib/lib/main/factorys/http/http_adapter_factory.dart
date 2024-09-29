import 'package:flutter_course/lib/infra/http.dart';
import 'package:http/http.dart';

HttpAdapter makeHttpAdapter() {
  final client = Client();
  return HttpAdapter(client);
}
