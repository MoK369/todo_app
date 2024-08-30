class Task {
  String? id;
  String? title;
  String? describtion;
  int? time;
  int? date;
  bool? isDone;
  bool? isLTR;

  Task(
      {this.id,
      this.title,
      this.describtion,
      this.time,
      this.date,
      this.isDone = false,
      this.isLTR});

  Task.fromFirestore(Map<String, dynamic>? data)
      : this(
            id: data?["id"],
            title: data?["title"],
            describtion: data?["describtion"],
            time: data?["time"],
            date: data?["date"],
            isDone: data?["isDone"],
            isLTR: data?["isLTR"]);

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "title": title,
      "describtion": describtion,
      "time": time,
      "date": date,
      "isDone": isDone,
      "isLTR": isLTR
    };
  }
}
