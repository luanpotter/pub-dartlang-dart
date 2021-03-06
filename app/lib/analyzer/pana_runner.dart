// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:pana/pana.dart';

import '../shared/analyzer_service.dart';
import '../shared/configuration.dart';
import '../shared/task_scheduler.dart' show Task, TaskRunner;

import 'backend.dart';
import 'models.dart';

final Logger _logger = new Logger('pub.analyzer.pana');

class PanaRunner implements TaskRunner {
  final AnalysisBackend _analysisBackend;

  PanaRunner(this._analysisBackend);

  @override
  Future<bool> hasCompletedRecently(Task task) async {
    return !(await _analysisBackend.isValidTarget(
        task.package, task.version, task.updated));
  }

  @override
  Future<bool> runTask(Task task) async {
    final DateTime timestamp = new DateTime.now().toUtc();
    Future<Summary> analyze() async {
      Directory tempDir;
      try {
        tempDir = await Directory.systemTemp.createTemp('pana');
        final pubCacheDir = await tempDir.resolveSymbolicLinks();
        final PackageAnalyzer analyzer = new PackageAnalyzer(
          flutterDir: envConfig.flutterSdkDir,
          pubCacheDir: pubCacheDir,
        );
        return await analyzer.inspectPackage(
          task.package,
          version: task.version,
          keepTransitiveLibs: false,
        );
      } catch (e, st) {
        _logger.severe('Pana execution failed.', e, st);
      } finally {
        if (tempDir != null) {
          await tempDir.delete(recursive: true);
        }
      }
      return null;
    }

    Summary summary = await analyze();
    if (summary == null || (summary.toolProblems?.isNotEmpty ?? false)) {
      _logger.info('Retrying $task...');
      await new Future.delayed(new Duration(seconds: 15));
      summary = await analyze();
    }

    final Analysis analysis =
        new Analysis.init(task.package, task.version, timestamp);

    if (summary == null) {
      analysis.analysisStatus = AnalysisStatus.aborted;
    } else {
      if (summary.toolProblems == null || summary.toolProblems.isEmpty) {
        analysis.analysisStatus = AnalysisStatus.success;
      } else {
        analysis.analysisStatus = AnalysisStatus.failure;
      }
      analysis.analysisJson = summary.toJson();
    }

    final backendStatus = await _analysisBackend.storeAnalysis(analysis);

    try {
      await _analysisBackend.deleteObsoleteAnalysis(task.package, task.version);
    } catch (e) {
      _logger.warning('Analysis GC failed: $task', e);
    }

    return backendStatus.wasRace;
  }
}
