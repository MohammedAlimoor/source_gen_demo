import 'package:my_generators/src/annotations/FeatureFamcare.dart';

part 'example.g.dart';

@FeatureFamcare(label: 'AAAAA')
abstract class Auth {
  // final int id;
  // final String name;
  // final String price;

  // const Auth(
  //   this.id,
  //   this.name,
  //   this.price,
  // );


  @FCApi(url:'api/login')
  Future<User> login(username,{String passord="123456"});


  @FCApi(url:'api/login',header: {"ssss":"value"})
  Future<User> reg(username,{String passord="123456"});



  Future<User> test(username,passord);
}

class User{
}
