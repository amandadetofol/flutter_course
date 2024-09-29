import 'package:flutter_course/lib/domain/usecases/usecases.dart';
import 'package:flutter_course/lib/main/factorys/http/http.dart';

import '../../../../data/usecases/usecases.dart';

Authentication makeRemoteAuthentication() {
  const method = 'post';

  return RemoteAuthentication(
    url: makeUrl('login'),
    httpClient: makeHttpAdapter(),
    method: method,
  );
}
