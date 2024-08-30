class Task {
  String? id;
  String? title;
  String? description;
  int? time;
  int? date;
  bool? isDone;
  bool? isLTR;

  Task(
      {this.id,
      this.title,
      this.description,
      this.time,
      this.date,
      this.isDone = false,
      this.isLTR});

  Task.fromFirestore(Map<String, dynamic>? data)
      : this(
            id: data?["id"],
            title: data?["title"],
            description: data?["description"],
            time: data?["time"],
            date: data?["date"],
            isDone: data?["isDone"],
            isLTR: data?["isLTR"]);

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "time": time,
      "date": date,
      "isDone": isDone,
      "isLTR": isLTR
    };
  }
}
