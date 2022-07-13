import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart' as e;
import 'package:build/build.dart';
import 'package:path/path.dart' as Path;
class DBAnnotation {
  const DBAnnotation();
}

class DBPKAnnotation {
  const DBPKAnnotation();
}
const _coreDBPKChecker = const TypeChecker.fromRuntime(DBPKAnnotation);

class DBGenerator extends GeneratorForAnnotation<DBAnnotation> {
  @override
  generateForAnnotatedElement(e.Element element, ConstantReader annotation, BuildStep buildStep) {
    return '''
part of '${Path.basename(buildStep.inputId.path)}';
class ${element.name}DBMetadata {
  ${analyseElement(element)}
}
''';
  }

  String analyseElement(e.Element element) {
    switch (element.kind) {
      case e.ElementKind.CLASS:
        return _analyseElementForClass(element as e.ClassElement);
      case e.ElementKind.FUNCTION:
      default:
        return "";
    }
  }

  String _analyseElementForClass(e.ClassElement classElement) {
    var fieldStr = "";
    for (var e in classElement.fields) {
      if (_coreDBPKChecker.hasAnnotationOfExact(e)) {
        // _coreDBPKChecker.firstAnnotationOfExact(e).getField(name)
        fieldStr += "DeleteBy${e.name}() {}";
      }
      
      fieldStr += '''
static var ${e.name}Field = "${e.name}";
''';
    }
    var schema = "";
    for (var e in classElement.fields) {
      schema += '''
  ${e.name} ${e.type.isDartCoreString ? "TEXT" : "INTEGER"};
  ''';
    }
    fieldStr += '''
static var dbTable = "${classElement.name}";
static var dbSchema = \'''
create table ${classElement.name} (
$schema
);
\''';
''';
    return fieldStr;
  }
}