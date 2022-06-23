import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class LoggerService{
  LoggerService._privateConstructor();
  static final LoggerService _instance = LoggerService._privateConstructor();
  static LoggerService get instance => _instance;

  Future<void> logFatalError({ required Object error, required StackTrace stackTrace, String reason = "" }) async{
    debugPrint("$error\n$stackTrace");
    await FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: reason, fatal: true);
  }

  Future<void> logError({ required Object error, required StackTrace stackTrace, String reason = "" }) async{
    debugPrint("$error\n$stackTrace");
    await FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: reason);
  }

}