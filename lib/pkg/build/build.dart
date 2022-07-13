import 'package:focus/pkg/build/db.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart' as build;

build.Builder dbBuilder(build.BuilderOptions options) => LibraryBuilder(DBGenerator(), generatedExtension: '.db.g.dart');