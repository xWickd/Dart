import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController amController = TextEditingController();
  final Map<String, int> students = {
    'std1@uoi.gr': 34531,
    'std2@uoi.gr': 119204,
    'std3@uoi.gr': 9312,
  };

  void _login() {
    final String email = emailController.text;
    final int am = int.tryParse(amController.text) ?? 0;

    if (students.containsKey(email) && students[email] == am) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or student number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: amController,
              decoration: InputDecoration(labelText: 'Student Number'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  void _startExam(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExamPage()),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _startExam(context),
              child: Text('Start Exam'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final List<Question> questions = [
    Question('What is Flutter?', QuestionType.multipleChoice, options: ['SDK', 'Programming Language', 'IDE'], correctAnswer: 'SDK'),
    Question('Explain the concept of State in Flutter.', QuestionType.shortAnswer, correctAnswer: 'State is an object that holds some data that may change over the lifetime of the widget.'),
    Question('Is Dart a programming language?', QuestionType.trueFalse, correctAnswer: 'True'),
    Question('What is the capital of France?', QuestionType.shortAnswer, correctAnswer: 'Paris'),
    Question('Is Flutter used for web development?', QuestionType.trueFalse, correctAnswer: 'True'),
    Question('What is the square root of 16?', QuestionType.shortAnswer, correctAnswer: '4'),
    Question('Which programming language is used by Flutter?', QuestionType.multipleChoice, options: ['Java', 'Dart', 'Python'], correctAnswer: 'Dart'),
    Question('Is Android an operating system?', QuestionType.trueFalse, correctAnswer: 'True'),
    Question('Who developed Flutter?', QuestionType.shortAnswer, correctAnswer: 'Google'),
    Question('What is 2 + 2?', QuestionType.shortAnswer, correctAnswer: '4'),
  ];

  final Map<int, String> answers = {};

  void _submitExam() {
    int score = 0;
    answers.forEach((index, answer) {
      if (questions[index].correctAnswer == answer) {
        score++;
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultPage(score: score)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question.text),
                        if (question.type == QuestionType.multipleChoice)
                          ...question.options!.map((option) {
                            return RadioListTile(
                              title: Text(option),
                              value: option,
                              groupValue: answers[index],
                              onChanged: (value) {
                                setState(() {
                                  answers[index] = value as String;
                                });
                              },
                            );
                          }).toList(),
                        if (question.type == QuestionType.shortAnswer)
                          TextField(
                            onChanged: (value) {
                              answers[index] = value;
                            },
                            decoration: InputDecoration(labelText: 'Your Answer'),
                          ),
                        if (question.type == QuestionType.trueFalse) ...[
                          RadioListTile(
                            title: Text('True'),
                            value: 'True',
                            groupValue: answers[index],
                            onChanged: (value) {
                              setState(() {
                                answers[index] = value as String;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text('False'),
                            value: 'False',
                            groupValue: answers[index],
                            onChanged: (value) {
                              setState(() {
                                answers[index] = value as String;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submitExam,
              child: Text('Submit Exam'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;

  ResultPage({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Text('Your score is $score'),
      ),
    );
  }
}

class Question {
  final String text;
  final QuestionType type;
  final List<String>? options;
  final String correctAnswer;

  Question(this.text, this.type, {this.options, required this.correctAnswer});
}

enum QuestionType {
  multipleChoice,
  shortAnswer,
  trueFalse,
}
