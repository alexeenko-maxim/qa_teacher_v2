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
    apiClient =
        QaTeacherApiClient.create(apiUrl: dotenv.env['API_URL']); // Пример инициализации, адаптируйте под свой случай
    questionList = apiClient.getQuestionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Убран const
      appBar: const KnowledgeAppBar(),
      body: QuestionListView(questionList: questionList,),
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
                'Список студентов',
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
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 30,
          ),
        ),
        SliverList.builder(
          itemBuilder: (context, index) => QuestionRow(
            question: widget.questionList[index].questionText,
            answerForTeacher: widget.questionList[index].answerForTeacherText,
            answerRate: 0,
          ),
          itemCount: widget.questionList.length,
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 240,
                  height: 40,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Завершить урок'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
          ),
        ),
      ],
    );
  }
}