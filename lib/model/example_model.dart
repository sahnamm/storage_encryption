// To parse this JSON data, do
//
//     final exampleModel = exampleModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

ExampleModel exampleModelFromJson(String str) =>
    ExampleModel.fromJson(json.decode(str));

String exampleModelToJson(ExampleModel data) => json.encode(data.toJson());

@HiveType(typeId: 0)
class ExampleModel {
  @HiveField(0)
  String? stringValue;

  @HiveField(1)
  bool? boolValue;

  @HiveField(2)
  int? intValue;

  ExampleModel({
    this.stringValue,
    this.boolValue,
    this.intValue,
  });

  ExampleModel copyWith({
    String? stringValue,
    bool? boolValue,
    int? intValue,
  }) =>
      ExampleModel(
        stringValue: stringValue ?? this.stringValue,
        boolValue: boolValue ?? this.boolValue,
        intValue: intValue ?? this.intValue,
      );

  factory ExampleModel.fromJson(Map<String, dynamic> json) => ExampleModel(
        stringValue: json["stringValue"],
        boolValue: json["boolValue"],
        intValue: json["intValue"],
      );

  Map<String, dynamic> toJson() => {
        "stringValue": stringValue,
        "boolValue": boolValue,
        "intValue": intValue,
      };

  factory ExampleModel.fromMap(Map<dynamic, dynamic> json) => ExampleModel(
        stringValue: json["stringValue"],
        boolValue: json["boolValue"],
        intValue: json["intValue"],
      );

  Map<String, dynamic> toMap() => {
        "stringValue": stringValue,
        "boolValue": boolValue,
        "intValue": intValue,
      };
}
