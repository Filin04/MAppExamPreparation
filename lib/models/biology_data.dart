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

final List<TheoryItem> biologyTheory = [
  TheoryItem(
    topic: 'Клетка',
    content: 'Клетка — основная структурная единица живого. Содержит ядро, цитоплазму и органоиды, выполняющие различные функции.',
  ),
  TheoryItem(
    topic: 'Генетика',
    content: 'Генетика изучает наследственность и изменчивость. Ген — это участок ДНК, несущий информацию о признаке.',
  ),
  TheoryItem(
    topic: 'Фотосинтез',
    content: 'Фотосинтез — процесс, при котором растения преобразуют солнечную энергию в химическую, производя глюкозу и кислород.',
  ),
  TheoryItem(
    topic: 'Эволюция',
    content: 'Эволюция — это процесс изменения организмов с течением времени под действием естественного отбора и мутаций.',
  ),
];

final List<TaskItem> biologyTasks = [
  TaskItem(
    question: 'Какая структура управляет всеми процессами клетки?',
    answer: 'Ядро',
  ),
  TaskItem(
    question: 'Сколько хромосом у человека в соматической клетке?',
    answer: '46 хромосом',
  ),
  TaskItem(
    question: 'Какие органоиды участвуют в синтезе белков?',
    answer: 'Рибосомы',
  ),
  TaskItem(
    question: 'Какой газ поглощают растения при фотосинтезе?',
    answer: 'Углекислый газ (CO₂)',
  ),
  TaskItem(
    question: 'Как называется наука, изучающая гены и наследование?',
    answer: 'Генетика',
  ),
  TaskItem(
    question: 'Кто предложил теорию естественного отбора?',
    answer: 'Чарльз Дарвин',
  ),
  TaskItem(
    question: 'Как называется пигмент, участвующий в фотосинтезе?',
    answer: 'Хлорофилл',
  ),
  TaskItem(
    question: 'Сколько этапов включает митоз?',
    answer: '4 (профаза, метафаза, анафаза, телофаза)',
  ),
  TaskItem(
    question: 'Что такое мутация?',
    answer: 'Изменение структуры ДНК',
  ),
  TaskItem(
    question: 'Какой орган отвечает за фильтрацию крови?',
    answer: 'Почка',
  ),
  TaskItem(
    question: 'Где происходит газообмен у человека?',
    answer: 'В альвеолах лёгких',
  ),
  TaskItem(
    question: 'Что является единицей наследственности?',
    answer: 'Ген',
  ),
];