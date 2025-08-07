import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> allQuizzes = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    fetchAllQuizzes();
  }

  Future<void> fetchAllQuizzes() async {
    try {
      final quizSnapshot = await FirebaseFirestore.instance.collection('quizzes').get();

      List<Map<String, dynamic>> quizzes = quizSnapshot.docs.map((doc) {
        return {
          'question': doc['question'],
          'options': List<String>.from(doc['options']),
          'answer': doc['answer'],
        };
      }).toList();

      quizzes.shuffle();

      setState(() {
        allQuizzes = quizzes;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching quizzes: $e');
    }
  }

  void checkAnswerAndNext() {
    final correctAnswer = allQuizzes[currentQuestionIndex]['answer'];
    if (selectedOption == correctAnswer) {
      score++;
    }

    setState(() {
      selectedOption = null;
      if (currentQuestionIndex < allQuizzes.length - 1) {
        currentQuestionIndex++;
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('🎉 Quiz Completed'),
            content: Text(
              'Your Score: $score / ${allQuizzes.length}',
              style: const TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuiz = allQuizzes[currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFDEE8EC),
      appBar: AppBar(
        title: const Text("Quiz Page"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${currentQuestionIndex + 1} of ${allQuizzes.length}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  currentQuiz['question'],
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 24),
                ...currentQuiz['options'].map<Widget>((option) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selectedOption == option
                            ? Colors.green
                            : Colors.grey.shade400,
                      ),
                    ),
                    child: RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: selectedOption,
                      activeColor: Colors.green[700],
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                  );
                }).toList(),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: selectedOption == null ? null : checkAnswerAndNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
