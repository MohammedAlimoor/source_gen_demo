import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations/FeatureFamcare.dart';

class RemoteDataSorceGenerator extends Generator {
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

      buffer.writeln('class \$${name}RemoteDataSorce {');
      buffer.writeln('  final ApiClient client;');
      buffer.writeln('  \$${name}RemoteDataSorce(this.client);');

      _class.methods.forEach((method) {
        if (_FCApiChecker.firstAnnotationOfExact(method) != null) {
          method.returnType;

          final parametersWithValues = method.parameters.map((field) {
            var defultValue =
                field.hasDefaultValue ? "=${field.defaultValueCode}" : "";
            return '${field.type.toString().replaceAll("*", "")} ${field.displayName.toString().replaceAll("*", "")} $defultValue';
            // }
          });

          buffer.writeln(
              '  ${method.returnType.getDisplayString(withNullability: false)}  ${method.displayName}({ ${parametersWithValues.join(', ')}}) async {');

          var url = _FCApiChecker.firstAnnotationOfExact(method)
              .getField("url")
              .toStringValue();

          var reqMethod = _FCApiChecker.firstAnnotationOfExact(method)
              .getField("method")
              .toStringValue()
              .toString()
              .toLowerCase()
              .trim();
          // buffer.writeln('//req $reqMethod');

          if (reqMethod == "post") {
            buffer.writeln('//final response = await client.post( "$url"');
            final parametersData = method.parameters.map((field) {
              return '"${field.displayName}": ${field.displayName}';
              // }
            });

            if (parametersData.isNotEmpty) {
              buffer.writeln('//,body:{${parametersData.join(', ')} }');
            }
            buffer.writeln('//) ');
          } else {
            final parametersData = method.parameters.map((field) {
              return '${field.displayName}=\$${field.displayName}';
              // }
            });

            buffer.writeln(
                '//final response = await client.get( "$url?${parametersData.join('&')}"');

            buffer.writeln('//) ');
          }

          buffer.writeln('// if (response.statusCode <= 204) {');
          if (method.returnType.toString().contains("Future")) {
            final regex =
                RegExp(r'Future<(.+)>', caseSensitive: false, multiLine: false);

            var returnType =
                method.returnType.getDisplayString(withNullability: false);

            var matches = regex.allMatches(returnType);
            var returnTypeWithoutFuture = matches.first.groups([1])[0];
            buffer.writeln(
                '// return $returnTypeWithoutFuture.fromResponse(response.data)');
          } else {
            buffer.writeln('//  return response.data; ');
          }

          buffer.writeln('// } else {');
          buffer
              .writeln('// throw ServerException.fromResponse(response.data);');
          buffer.writeln('// }');
          buffer.writeln('//}');

          buffer.writeln('}');

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
