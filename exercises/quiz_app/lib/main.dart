import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizEnded = false;
  Timer? _timer;
  int _timeRemaining = 60;

  dynamic _selectedAnswer;
  final List<String> _selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  void _loadQuestions() async {
    String data = await rootBundle.loadString('assets/questions.json');
    List<dynamic> questions = json.decode(data);
    questions.shuffle(); // Randomize question order
    setState(() {
      _questions = questions.take(10).toList(); // Take first 10 questions
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _quizEnded = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _nextQuestion() {
    setState(() {
      _selectedAnswer = null;
      _selectedAnswers.clear();

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      _selectedAnswer = null;
      _selectedAnswers.clear();

      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      }
    });
  }

  void _checkAnswer(dynamic question, dynamic selectedAnswer) {
    if (question['type'] == 'multiple_choice_one' ||
        question['type'] == 'true_false') {
      if (selectedAnswer == question['correct']) {
        _score++;
      }
    } else if (question['type'] == 'multiple_choice_multiple') {
      List<String> correctAnswers = List<String>.from(question['correct']);

      List<String> userAnswers;
      if (selectedAnswer is String) {
        userAnswers = [selectedAnswer];
      } else {
        userAnswers = List<String>.from(selectedAnswer);
      }

      correctAnswers.sort();
      userAnswers.sort();

      if (ListEquality().equals(correctAnswers, userAnswers)) {
        _score++;
      }
    }
  }

  void _submitQuiz() {
    setState(() {
      _quizEnded = true;
      _timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizEnded) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz Completed')),
        body: Center(
          child: Text('Your Score: $_score / ${_questions.length}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time Remaining: $_timeRemaining sec',
                style: TextStyle(fontSize: 18, color: Colors.red)),
            SizedBox(height: 20),
            Text(question['question'],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ...question['options'].map<Widget>((option) {
              return ListTile(
                title: Text(option),
                leading: question['type'] == 'multiple_choice_multiple'
                    ? Checkbox(
                        value: _selectedAnswers.contains(option),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedAnswers.add(option);
                            } else {
                              _selectedAnswers.remove(option);
                            }
                          });
                        },
                      )
                    : Radio(
                        value: option,
                        groupValue: _selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswer = value;
                          });
                          _checkAnswer(question, value);
                        },
                      ),
              );
            }).toList(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:
                      _currentQuestionIndex > 0 ? _previousQuestion : null,
                  child: Text('Previous'),
                ),
                if (_currentQuestionIndex < _questions.length - 1)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text('Next'),
                  ),
                if (_currentQuestionIndex == _questions.length - 1)
                  ElevatedButton(
                    onPressed: _submitQuiz,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Submit'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
