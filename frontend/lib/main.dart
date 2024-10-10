import 'package:flutter/material.dart';

import 'app.dart';
import 'features/auth/repository/auth_repository.dart';

void main() {
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  runApp(MyApp(authenticationRepository: authenticationRepository));
}
