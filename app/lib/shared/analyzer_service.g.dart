// Copyright (c) 2017, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: prefer_final_locals

part of pub_dartlang_org.shared.analyzer_service;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

AnalysisData _$AnalysisDataFromJson(Map<String, dynamic> json) =>
    new AnalysisData(
        packageName: json['packageName'] as String,
        packageVersion: json['packageVersion'] as String,
        analysis: json['analysis'] as int,
        timestamp: json['timestamp'] == null
            ? null
            : DateTime.parse(json['timestamp'] as String),
        panaVersion: json['panaVersion'] as String,
        flutterVersion: json['flutterVersion'] as String,
        analysisStatus: json['analysisStatus'] == null
            ? null
            : AnalysisStatus.values.singleWhere((x) =>
                x.toString() == "AnalysisStatus.${json['analysisStatus']}"),
        analysisContent: json['analysisContent'] as Map<String, dynamic>);

abstract class _$AnalysisDataSerializerMixin {
  String get packageName;
  String get packageVersion;
  int get analysis;
  DateTime get timestamp;
  String get panaVersion;
  String get flutterVersion;
  AnalysisStatus get analysisStatus;
  Map<dynamic, dynamic> get analysisContent;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'packageName': packageName,
        'packageVersion': packageVersion,
        'analysis': analysis,
        'timestamp': timestamp?.toIso8601String(),
        'panaVersion': panaVersion,
        'flutterVersion': flutterVersion,
        'analysisStatus': analysisStatus == null
            ? null
            : analysisStatus.toString().split('.')[1],
        'analysisContent': analysisContent
      };
}

AnalysisExtract _$AnalysisExtractFromJson(Map<String, dynamic> json) =>
    new AnalysisExtract(
        health: (json['health'] as num)?.toDouble(),
        maintenance: (json['maintenance'] as num)?.toDouble(),
        popularity: (json['popularity'] as num)?.toDouble(),
        platforms:
            (json['platforms'] as List)?.map((e) => e as String)?.toList(),
        timestamp: json['timestamp'] == null
            ? null
            : DateTime.parse(json['timestamp'] as String));

abstract class _$AnalysisExtractSerializerMixin {
  double get health;
  double get maintenance;
  double get popularity;
  List<String> get platforms;
  DateTime get timestamp;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'health': health,
        'maintenance': maintenance,
        'popularity': popularity,
        'platforms': platforms,
        'timestamp': timestamp?.toIso8601String()
      };
}
