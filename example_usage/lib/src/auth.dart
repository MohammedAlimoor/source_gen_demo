import 'package:my_generators/src/annotations/FeatureFamcare.dart';

part 'auth.g.dart';

@FeatureFamcare(label: 'Auth')
abstract class Auth {
  int id;

  @FCApi(url: 'api/login',method: "post")
  Future<User> login(username, {String passord = "123456"});

  @FCApi(
    url: 'api/register',
  )
  Future<User> reg(username, {String passord = "123456", sendSms = false});

}

class User {}
