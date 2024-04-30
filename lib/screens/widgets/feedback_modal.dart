import 'package:flutter/material.dart';

class FeedbackDialog extends StatefulWidget {
  final Function(String, String) onSubmitFeedback;

  const FeedbackDialog({Key? key, required this.onSubmitFeedback})
      : super(key: key);

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  String? _selectedFeedback;
  String _userComment = '';
  String? _errorFeedback;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '¿Qué tal tu experiencia con el Menú Digital?',
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
                              opacity: _selectedFeedback == type ? 1.0 : 0.5,
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
            decoration: InputDecoration(hintText: 'Deja un comentario...'),
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
              widget.onSubmitFeedback(_selectedFeedback!, _userComment);
              Navigator.of(context).pop();
            }
          },
          child: Text('Enviar'),
        ),
      ],
    );
  }
}
