class TheoryItem {
  final String topic;
  final String content;

  TheoryItem({required this.topic, required this.content});
}

class TaskItem {
  final String question;
  final String answer;

  TaskItem({required this.question, required this.answer});
}

final List<TheoryItem> obshchestvoTheory = [
  TheoryItem(
    topic: 'Право',
    content: 'Право — это система норм, установленных и охраняемых государством. Оно регулирует общественные отношения.',
  ),
  TheoryItem(
    topic: 'Экономика',
    content: 'Экономика изучает производство, распределение, обмен и потребление товаров и услуг.',
  ),
  TheoryItem(
    topic: 'Политика',
    content: 'Политика — деятельность по управлению обществом. Включает в себя государственную власть, политические партии и выборы.',
  ),
  TheoryItem(
    topic: 'Социальные отношения',
    content: 'Социальные отношения — взаимодействия между людьми, основанные на социальном статусе, ролях и институтах.',
  ),
];

final List<TaskItem> obshchestvoTasks = [
  TaskItem(
    question: 'Что регулирует поведение людей в обществе?',
    answer: 'Правовые нормы',
  ),
  TaskItem(
    question: 'Кто обладает законодательной властью в РФ?',
    answer: 'Федеральное Собрание',
  ),
  TaskItem(
    question: 'Какой фактор влияет на спрос на товар?',
    answer: 'Цена',
  ),
  TaskItem(
    question: 'Что такое демократия?',
    answer: 'Форма правления, основанная на участии граждан в управлении государством',
  ),
  TaskItem(
    question: 'Что такое социальная мобильность?',
    answer: 'Изменение социального статуса индивида или группы',
  ),
  TaskItem(
    question: 'Кто является субъектом гражданского права?',
    answer: 'Физические и юридические лица',
  ),
  TaskItem(
    question: 'Что такое инфляция?',
    answer: 'Общее повышение цен на товары и услуги',
  ),
  TaskItem(
    question: 'Какой орган следит за исполнением законов?',
    answer: 'Прокуратура',
  ),
  TaskItem(
    question: 'Какой политический режим характеризуется отсутствием конкуренции?',
    answer: 'Тоталитаризм',
  ),
  TaskItem(
    question: 'Что является источником власти в демократическом государстве?',
    answer: 'Народ',
  ),
  TaskItem(
    question: 'Какой признак характеризует правовое государство?',
    answer: 'Верховенство закона',
  ),
  TaskItem(
    question: 'Что такое налоги?',
    answer: 'Обязательные платежи, взимаемые государством с граждан и организаций',
  ),
];
