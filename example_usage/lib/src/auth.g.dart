// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// DataRepoGenerator
// **************************************************************************

class $AuthRepository {
  final $AuthRemoteDataSorce remoteDataSource;
  $AuthRepository(this.remoteDataSource);
//    Future<Either<Failure,  User>>   login({ dynamic username , String passord ="123456"})  async{
  /*
            try {
      final obj = await remoteDataSource.login(username  : username, passord  : passord);

      return Right(obj);
    } on ServerException catch (e) {

      return Left(e.toFailure());
    } catch (error) {
      return Left(ConnectionFailure());
    }
    */

//}
//    Future<Either<Failure,  User>>   reg({ dynamic username , String passord ="123456", dynamic sendSms =false})  async{
  /*
            try {
      final obj = await remoteDataSource.reg(username  : username, passord  : passord, sendSms  : sendSms);

      return Right(obj);
    } on ServerException catch (e) {

      return Left(e.toFailure());
    } catch (error) {
      return Left(ConnectionFailure());
    }
    */

//}
}

// **************************************************************************
// RemoteDataSorceGenerator
// **************************************************************************

class $AuthRemoteDataSorce {
  final ApiClient client;
  $AuthRemoteDataSorce(this.client);
  Future<User> login({dynamic username, String passord = "123456"}) async {
//final response = await client.post( "api/login"
//,body:{"username": username, "passord": passord }
//)
// if (response.statusCode <= 204) {
// return User.fromResponse(response.data)
// } else {
// throw ServerException.fromResponse(response.data);
// }
//}
  }
  Future<User> reg(
      {dynamic username,
      String passord = "123456",
      dynamic sendSms = false}) async {
//final response = await client.get( "api/register?username=$username&passord=$passord&sendSms=$sendSms"
//)
// if (response.statusCode <= 204) {
// return User.fromResponse(response.data)
// } else {
// throw ServerException.fromResponse(response.data);
// }
//}
  }
}
