class Task {
  static const String idKey = "id",
      titleKey = "title",
      descriptionKey = "description",
      dateKey = "date",
      isDoneKey = "isDone",
      isLTRKey = "isLTR";
  String? id;
  String? title;
  String? description;
  int? date;
  bool? isDone;
  bool? isLTR;

  Task(
      {this.id,
      this.title,
      this.description,
      this.date,
      this.isDone = false,
      this.isLTR});

  Task.fromFirestore(Map<String, dynamic>? data)
      : this(
            id: data?[idKey],
            title: data?[titleKey],
            description: data?[descriptionKey],
            date: data?[dateKey],
            isDone: data?[isDoneKey],
            isLTR: data?[isLTRKey]);

  Map<String, dynamic> toFirestore() {
    return {
      idKey: id,
      titleKey: title,
      descriptionKey: description,
      dateKey: date,
      isDoneKey: isDone,
      isLTRKey: isLTR
    };
  }
}
