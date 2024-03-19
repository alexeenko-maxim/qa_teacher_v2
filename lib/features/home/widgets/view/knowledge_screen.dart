import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qa_teacher/api/api.dart';
import 'package:qa_teacher/api/model/question.dart';

@RoutePage()
class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({Key? key}) : super(key: key);

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  late final QaTeacherApiClient apiClient;
  late Future<List<Question>> questionList;

  @override
  void initState() {
    super.initState();
    apiClient = QaTeacherApiClient.create(apiUrl: dotenv.env['API_URL']);
    questionList = apiClient.getQuestionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Убран const
      appBar: const KnowledgeAppBar(),
      body: QuestionListView(
        questionList: questionList,
      ),
    );
  }
}

class KnowledgeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KnowledgeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey,
      title: const Text(
        'База знаний',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: () {
                // Действия при нажатии на Кнопка 1
              },
              child: const Text(
                'Добавить вопрос',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class QuestionListView extends StatefulWidget {
  const QuestionListView({
    Key? key,
    required this.questionList,
  }) : super(key: key);
  final Future<List<Question>> questionList;

  @override
  State<QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        // Другие Sliver виджеты, если они есть...
        FutureBuilder<List<Question>>(
          future: widget.questionList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Показываем индикатор загрузки, пока данные загружаются
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              // Показываем сообщение об ошибке, если что-то пошло не так
              return SliverFillRemaining(
                child: Center(child: Text('Ошибка: ${snapshot.error}')),
              );
            } else if (snapshot.hasData) {
              // Данные доступны, создаем список вопросов
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final question = snapshot.data![index];
                    return QuestionRow(
                      index: index + 1, // Передаем порядковый номер строки, начиная с 1
                      question: question.questionText,
                      answerForTeacher: question.answerForTeacherText,
                      lessonNumber: question.lessonNumber,
                    );
                  },
                  childCount: snapshot.data!.length,
                ),
              );
            } else {
              // Данные не найдены
              return const SliverFillRemaining(
                child: Center(child: Text('Нет данных')),
              );
            }
          },
        ),
        // Другие Sliver виджеты, если они есть...
      ],
    );
  }
}

class QuestionRow extends StatefulWidget {
  const QuestionRow({
    super.key,
    required this.index, // Добавлен порядковый номер строки
    required this.question,
    required this.answerForTeacher,
    required this.lessonNumber,
  });

  final int index; // Порядковый номер строки
  final int lessonNumber;
  final String question;
  final String answerForTeacher;

  @override
  State<QuestionRow> createState() => _QuestionRowState();
}

class _QuestionRowState extends State<QuestionRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.lessonNumber}', // номер урока
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.index}', // Порядковый номер строки
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.question,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.answerForTeacher,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () async {

              },
              child: const Text('Изменить',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )))
        ],
      ),
    );
  }
}
