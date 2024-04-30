import 'dart:async';
import 'package:flutter/material.dart';
import 'package:menu/models/feedback_info.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/screens/widgets/feedback_modal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackManager {
  Timer? _timer;
  bool _isFeedbackSubmitted = false;

  // Inicia el temporizador para mostrar el modal de feedback
  void startFeedbackTimer(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    _isFeedbackSubmitted = prefs.getBool('feedbackSubmitted') ?? false;

    if (!_isFeedbackSubmitted) {
      _timer = Timer(Duration(seconds: 30), () {
        showFeedbackModal(context);
      });
    }
  }

  // Muestra el modal de feedback
  void showFeedbackModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FeedbackDialog(
            onSubmitFeedback: (selectedFeedback, userComment) {
          submitFeedback(selectedFeedback, userComment, context);
        });
      },
    );
  }

  // Envía el feedback
  void submitFeedback(String? selectedFeedback, String userComment,
      BuildContext context) async {
    if (selectedFeedback == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecciona un emoji antes de enviar.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);

    int score =
        selectedFeedback == 'sad' ? 1 : (selectedFeedback == 'normal' ? 2 : 3);
    FeedbackInfo feedbackInfo = FeedbackInfo(
      sessionId:
          '', // Aquí debes obtener el sessionId de algún modo, posiblemente pasándolo como parámetro
      branchId:
          '', // Aquí debes obtener el branchId de algún modo, posiblemente pasándolo como parámetro
      score: score,
      comment: userComment,
    );

    feedbackProvider.submitFeedback(feedbackInfo).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Gracias por ayudarnos a mejorar!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      _markFeedbackAsSubmitted();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocurrió un error al enviar tu feedback.'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  // Marca el feedback como enviado
  void _markFeedbackAsSubmitted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('feedbackSubmitted', true);
  }

  // Cancela el temporizador si es necesario
  void cancelTimer() {
    _timer?.cancel();
  }
}
