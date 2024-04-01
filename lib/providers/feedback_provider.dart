import 'package:flutter/material.dart';
import 'package:menu/api/api_4uRest.dart';
import 'package:menu/models/device_tracking_info.dart';
import 'package:menu/models/feedback_info.dart';

class FeedbackProvider with ChangeNotifier {
  Future<void> submitFeedback(FeedbackInfo feedbackInfo) async {
    try {
      await Api4uRest.httpPost(
          '/digital-menu/submit-feedback', feedbackInfo.toJson());
    } catch (e) {
      print('Error al enviar el feedback: $e');
    }
  }
}
