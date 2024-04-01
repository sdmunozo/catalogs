import 'package:flutter/material.dart';
import 'package:menu/api/api_4uRest.dart';

class FeedbackProvider with ChangeNotifier {
  Future<void> submitFeedback(
      String sessionId, String branchId, int score, String? comment) async {
    final data = {
      "score": score,
      "comment": comment ?? "",
      "branchId": branchId,
      "sessionId": sessionId,
    };

    try {
      //print('Enviando feedback con datos: $data');
      await Api4uRest.httpPost('/digital-menu/submit-feedback', data);
    } catch (e) {
      //print('Error al enviar el feedback: $e ');
    }
  }
}
