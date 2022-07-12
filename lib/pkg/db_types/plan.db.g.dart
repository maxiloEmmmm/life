// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'plan.dart';

class PlanDBMetadata {
  static var idField = "id";
  static var nameField = "name";
  static var descField = "desc";
  static var repeatField = "repeat";
  static var enableRepeatField = "enableRepeat";
  static var deadLineField = "deadLine";
  static var relationIDField = "relationID";
  static var enableRelationField = "enableRelation";
  static var dbTable = "Plan";
  static var dbSchema = '''
create table Plan (
  id INTEGER;
    name TEXT;
    desc TEXT;
    repeat INTEGER;
    enableRepeat INTEGER;
    deadLine INTEGER;
    relationID INTEGER;
    enableRelation INTEGER;
  
);
''';
}
