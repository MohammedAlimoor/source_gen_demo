import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/data_repo_generator.dart';
import 'src/data_sorce_generator.dart';
// import 'src/class_extras_generator.dart';
// import 'src/serialize_generator.dart';

Builder infoGeneratorBuilder(BuilderOptions options) =>
    SharedPartBuilder([RemoteDataSorceGenerator()], 'sorce');

Builder repoGeneratorBuilder(BuilderOptions options) =>
    SharedPartBuilder([DataRepoGenerator()], 'fields');

// Builder serializeGeneratorBuilder(BuilderOptions options) =>
//     SharedPartBuilder([SerializeGenerator()], 'serialize');
