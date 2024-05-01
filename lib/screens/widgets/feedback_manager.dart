/*

import 'package:flutter/material.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/models/feedback_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackManager {
  //static void showFeedbackModal(BuildContext context, Function setState) {

  static void _showFeedbackModal(BuildContext context) {
    String? _errorFeedback;
    String? _selectedFeedback;
    String _userComment = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                '¿Qué tál tu experiencia con el Menú Digital?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...['sad', 'normal', 'happy']
                          .map((type) {
                            String assetName;
                            switch (type) {
                              case 'sad':
                                assetName = 'assets/feedback/triste.png';
                                break;
                              case 'normal':
                                assetName = 'assets/feedback/confuso.png';
                                break;
                              case 'happy':
                              default:
                                assetName = 'assets/feedback/feliz.png';
                                break;
                            }
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedFeedback = type;
                                      _errorFeedback = null;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _selectedFeedback == type
                                          ? Colors.blue
                                          : Colors.transparent,
                                    ),
                                    child: Opacity(
                                      opacity:
                                          _selectedFeedback == type ? 1.0 : 0.5,
                                      child: Image.asset(assetName, width: 40),
                                    ),
                                  ),
                                ),
                                if (type != 'happy') SizedBox(width: 20),
                              ],
                            );
                          })
                          .expand((widget) => [widget])
                          .toList(),
                    ],
                  ),
                  TextField(
                    decoration:
                        InputDecoration(hintText: 'Deja un comentario...'),
                    onChanged: (value) {
                      _userComment = value;
                    },
                  ),
                  if (_errorFeedback != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _errorFeedback!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_selectedFeedback == null) {
                      setState(() {
                        _errorFeedback =
                            'Por favor, selecciona un emoji antes de enviar.';
                      });
                    } else {
                      _submitFeedback('withComment');
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //static void submitFeedback(BuildContext context, String? selectedFeedback, String userComment) async 

  static void submitFeedback(BuildContext context, String? selectedFeedback, String userComment) async {
    if (selectedFeedback == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecciona un emoji antes de enviar.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final branchCatalogProvider =
        Provider.of<BranchCatalogProvider>(context, listen: false);
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);

    int score = selectedFeedback == 'sad'
        ? 1
        : (selectedFeedback == 'normal' ? 2 : 3);
    FeedbackInfo feedbackInfo = FeedbackInfo(
      sessionId: branchCatalogProvider.sessionId,
      branchId: branchCatalogProvider.branchCatalog?.branchId ?? '',
      score: score,
      comment: userComment ?? "",
    );
    feedbackProvider.submitFeedback(feedbackInfo).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Gracias por ayudarnos a mejorar!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocurrió un error al enviar tu feedback.'),
          duration: Duration(seconds: 2),
        ),
      );
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('feedbackSubmitted', true);

    setState(() {
      isFeedbackSubmitted = true;
      selectedFeedback = null;
      userComment = '';
    });
  }

*/
/*
import 'package:flutter/material.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/models/feedback_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackManager {
  
  static void showFeedbackModal(BuildContext context, Function setState) {
    String? selectedFeedback;
    String userComment = '';
    String? errorFeedback;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                '¿Qué tál tu experiencia con el Menú Digital?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Widgets del feedback aquí...
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => submitFeedback(context, selectedFeedback, userComment),
                  child: Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void submitFeedback(BuildContext context, String? selectedFeedback, String userComment) async {
    if (selectedFeedback == null) {
      // Manejo de error si no se selecciona un feedback
      return;
    }

    final feedbackProvider = Provider.of<FeedbackProvider>(context, listen: false);

    FeedbackInfo feedbackInfo = FeedbackInfo(
      // Propiedades de feedbackInfo
    );

    feedbackProvider.submitFeedback(feedbackInfo).then((_) {
      // Confirmación de envío
    }).catchError((error) {
      // Manejo de errores
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('feedbackSubmitted', true);
  }
}

 */