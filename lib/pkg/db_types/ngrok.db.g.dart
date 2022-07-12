// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'ngrok.dart';

class NgrokDBMetadata {
  static var identityField = "identity";
  static var apiKeyField = "apiKey";
  static var dbTable = "Ngrok";
  static var dbSchema = '''
create table Ngrok (
  identity TEXT;
    apiKey TEXT;
  
);
''';
}
