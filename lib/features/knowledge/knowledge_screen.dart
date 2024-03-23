import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qa_teacher/api/api.dart';
import 'package:qa_teacher/api/model/question.dart';
import 'package:qa_teacher/router/router.dart';

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
      appBar: KnowledgeAppBar(onAddQuestionPressed: onAddQuestionPressed,),
      body: QuestionListView(
        questionList: questionList,
        onQuestionUpdated: onQuestionUpdated,
      ),
    );
  }

  void onQuestionUpdated() {
    setState(() {
      questionList = apiClient.getQuestionList();
    });
  }

  void onAddQuestionPressed() {
    AutoRouter.of(context).push(AddQuestionRoute()).then((_) => onQuestionUpdated());
  }
}

class KnowledgeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onAddQuestionPressed;
  const KnowledgeAppBar({Key? key, required this.onAddQuestionPressed}) : super(key: key);

  @override
  State<KnowledgeAppBar> createState() => _KnowledgeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _KnowledgeAppBarState extends State<KnowledgeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey,
      leading: IconButton(
        icon: Icon(Icons.home),
        tooltip: 'Главная', // Текст, который будет показан при долгом нажатии
        onPressed: () {
          // Логика для возвращения на главный экран
          AutoRouter.of(context).replace(const HomeRoute());
        },
      ),
      title: const Text(
        'База знаний',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            widget.onAddQuestionPressed();
          },
          child: const Text('Добавить новый вопрос',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white, // Указываем цвет текста
              )),
        ),
      ],
    );
  }
}

class QuestionListView extends StatefulWidget {
  const QuestionListView({
    Key? key,
    required this.questionList, required this.onQuestionUpdated,
  }) : super(key: key);
  final Future<List<Question>> questionList;
  final VoidCallback onQuestionUpdated;

  @override
  State<QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        FutureBuilder<List<Question>>(
          future: widget.questionList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return SliverFillRemaining(
                child: Center(child: Text('Ошибка: ${snapshot.error}')),
              );
            } else if (snapshot.hasData) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final question = snapshot.data![index];
                    return QuestionRow(
                      onQuestionUpdated: widget.onQuestionUpdated,
                      index: index + 1, // Передаем порядковый номер строки, начиная с 1
                      question: question.questionText,
                      answerForTeacher: question.answerForTeacherText,
                      lessonNumber: question.lessonNumber,
                      questionId: question.questionId,
                    );
                  },
                  childCount: snapshot.data!.length,
                ),
              );
            } else {
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
  final VoidCallback onQuestionUpdated;
  const QuestionRow({
    Key? key,
    required this.index,
    required this.question,
    required this.answerForTeacher,
    required this.lessonNumber,
    required this.questionId, required this.onQuestionUpdated, // Добавьте questionId здесь
  }) : super(key: key);

  final int index;
  final int lessonNumber;
  final String question;
  final String answerForTeacher;
  final int questionId; // И здесь

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
      child: Row( // Используем Row для горизонтального расположения элементов
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [ // Правильно используем children для списка виджетов в Row
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Вопрос к занятию ${widget.lessonNumber}', // номер урока
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4), // Добавляем небольшой отступ
                Text(
                  'Номер вопроса ${widget.index}', // Порядковый номер вопроса
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8), // Отступ между номером вопроса и его текстом
                Text(
                  widget.question, // Текст вопроса
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4), // Отступ между вопросом и ответом
                Text(
                  widget.answerForTeacher, // Ответ для учителя
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              var result = await AutoRouter.of(context).push(EditQuestionRoute(
                  questionId: widget.questionId, questionText: widget.question, answerForTeacherText: widget.answerForTeacher, lessonNumber: widget.lessonNumber));
              if (result == true) {
                // Если вопрос был успешно отредактирован, используйте callback для обновления списка вопросов
                widget.onQuestionUpdated();
              }
            },
          ),
        ],
      ),
    );
  }
}
@RoutePage()
class EditQuestionScreen extends StatefulWidget {
  final int questionId;
  final String questionText;
  final String answerForTeacherText;
  final int lessonNumber; // Добавляем номер урока

  const EditQuestionScreen({
    Key? key,
    required this.questionId,
    required this.questionText,
    required this.answerForTeacherText,
    required this.lessonNumber, // Инициализируем номер урока
  }) : super(key: key);

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late final QaTeacherApiClient apiClient;
  late TextEditingController _questionController;
  late TextEditingController _answerController;
  late TextEditingController _lessonNumberController; // Контроллер для номера урока

  @override
  void initState() {
    super.initState();
    apiClient = QaTeacherApiClient.create(apiUrl: dotenv.env['API_URL']);
    _questionController = TextEditingController(text: widget.questionText);
    _answerController = TextEditingController(text: widget.answerForTeacherText);
    _lessonNumberController = TextEditingController(text: widget.lessonNumber.toString()); // Инициализация контроллера
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _lessonNumberController.dispose(); // Не забываем очистить контроллер
    super.dispose();
  }

  Future<void> _updateQuestion() async {
    // Здесь будет логика обновления вопроса через API
    // Не забудьте обновить API для включения номера урока в запросе на обновление

    //Пример вызова API:
    await apiClient.updateQuestion(
      questionId: widget.questionId,
      questionText: _questionController.text,
      answerForTeacherText: _answerController.text,
      lessonNumber: int.tryParse(_lessonNumberController.text) ?? widget.lessonNumber
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактирование вопроса'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Текст вопроса'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Ответ для учителя'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _lessonNumberController, // Добавляем поле для номера урока
              decoration: InputDecoration(labelText: 'Номер урока'),
              keyboardType: TextInputType.number, // Устанавливаем тип клавиатуры
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateQuestion,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
@RoutePage()
class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({Key? key}) : super(key: key);

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _lessonNumberController = TextEditingController();
  late final QaTeacherApiClient apiClient;

  Future<void> _addQuestion() async {
    await apiClient.addQuestion(
      questionText: _questionController.text,
      answerForTeacherText: _answerController.text,
      lessonNumber: int.tryParse(_lessonNumberController.text) ?? 1 // Примерная логика
    );

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    // Инициализация apiClient здесь
    apiClient = QaTeacherApiClient.create(apiUrl: dotenv.env['API_URL']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить новый вопрос'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Текст вопроса'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Ответ для учителя'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _lessonNumberController,
              decoration: InputDecoration(labelText: 'Номер урока'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _lessonNumberController.dispose();
    super.dispose();
  }
}

