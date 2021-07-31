import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations/FeatureFamcare.dart';

class DataRepoGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    var buffer = StringBuffer();

    // library.allElements.forEach((element) {
    //   buffer.writeln(
    //       '// ${element.displayName} - ${element.source.fullName} - ${element.declaration}');
    // });
    // library.allElements.whereType<TopLevelVariableElement>().forEach((element) {
    //   buffer.writeln(
    //       '// Alimor ${element.name} - ${element.kind.displayName} - ${element.declaration}');
    // });
    final _featureFamcareChecker =
        const TypeChecker.fromRuntime(FeatureFamcare);
    final _FCApiChecker = const TypeChecker.fromRuntime(FCApi);

    for (final _class in library.classes) {
      if (_featureFamcareChecker.firstAnnotationOfExact(_class) == null) {
        return buffer.toString();
      }
      final name = _class.displayName;

      buffer.writeln('class \$${name}Repository {');
      buffer.writeln(' final \$${name}RemoteDataSorce remoteDataSource;');
      buffer.writeln(' \$${name}Repository(this.remoteDataSource);');

      _class.methods.forEach((method) {
        if (_FCApiChecker.firstAnnotationOfExact(method) != null) {
          method.returnType;

          final parametersWithValues = method.parameters.map((field) {
            var defultValue =
                field.hasDefaultValue ? "=${field.defaultValueCode}" : "";
            return '${field.type.toString().replaceAll("*", "")} ${field.displayName.toString().replaceAll("*", "")} $defultValue';
          });

          final parametersCall = method.parameters.map((field) {
            return '${field.displayName.toString().replaceAll("*", "")}  : ${field.displayName.toString().replaceAll("*", "")}';
          });

          final regex =
              RegExp(r'Future<(.+)>', caseSensitive: false, multiLine: false);

          var returnType =
              method.returnType.getDisplayString(withNullability: false);

          var matches = regex.allMatches(returnType);
          var returnTypeWithoutFuture = matches.first.groups([1])[0];

          buffer.writeln(
              '//    Future<Either<Failure,  $returnTypeWithoutFuture>>   ${method.displayName}({ ${parametersWithValues.join(', ')}})  async{');

          buffer.writeln('''
          /*
            try {
      final obj = await remoteDataSource.${method.displayName}(${parametersCall.join(', ')});

      return Right(obj);
    } on ServerException catch (e) {

      return Left(e.toFailure());
    } catch (error) {
      return Left(ConnectionFailure());
    }
    */
           ''');

          buffer.writeln('//}');

          // buffer.writeln(
          //     '//${_featureFamcareChecker.firstAnnotationOfExact(_class).toString()}');
        }
      });

      // buffer.writeln(
      //     '//${_featureFamcareChecker.firstAnnotationOfExact(_class).toString()}');

      buffer.writeln('}');
    }
    return buffer.toString();
  }
}
