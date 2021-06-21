import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations/FeatureFamcare.dart';

class InfoGenerator extends Generator {
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

      _class.methods.forEach((method) {
        if (_FCApiChecker.firstAnnotationOfExact(method) != null) {
          method.returnType;

          final parametersWithValues = method.parameters
              // .where((field) => field.displayName != 'hashCode')
              .map((field) {
            // if (field.defaultValueCode != null) {
            //   return '{${field.type} ${field.displayName}=${field.defaultValueCode}}';
            // } else {
            return '${field.type} ${field.displayName}';
            // }
          });

          buffer.writeln(
              '  ${method.returnType}  ${method.displayName}(${parametersWithValues.join(', ')}) {');

          var url =
              _FCApiChecker.firstAnnotationOfExact(method).getField("url");

          buffer.writeln('//final response = await client.post( $url ');

          final parametersData = method.parameters
              // .where((field) => field.displayName != 'hashCode')
              .map((field) {
            return '"${field.displayName}": ${field.displayName}';
            // }
          });

          if (parametersData.isNotEmpty) {
            buffer.writeln('//,body:{${parametersData.join(', ')}');
          }
          if (_FCApiChecker.firstAnnotationOfExact(method).getField("header") !=
              null) {
            if (_FCApiChecker.firstAnnotationOfExact(method)
                .getField("header")
                .hasKnownValue) {
          //  _FCApiChecker.firstAnnotationOfExact(method)
          //         .getField("header")
          //         .toMapValue().keys
          //     buffer.writeln('//,headers: ${headerValue})');
            }
          }

          buffer.writeln('}');

          buffer.writeln(
              '//${_featureFamcareChecker.firstAnnotationOfExact(_class).toString()}');
        }
      });

      buffer.writeln(
          '//${_featureFamcareChecker.firstAnnotationOfExact(_class).toString()}');

      buffer.writeln('}');
    }
    return buffer.toString();
  }
}

//  Future<bool> extendConversation(Conversation conversation,
//       {String url = ""}) async {
//     Conversation conversationTemp = await getConversationCurrent(conversation);

//     final response = await client.post(
//       Api.extendConversation(conversationTemp),
//       body: {},
//       headers: Api.headers(),
//     );

//     if (response.statusCode <= 204) {
//       return true;
//     } else {
//       throw ServerException.fromResponse(response.data);
//     }
//   }
