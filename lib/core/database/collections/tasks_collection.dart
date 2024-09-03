import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/core/database/models/task.dart';

class TasksCollection {
  CollectionReference<Task> getTasksCollection(String userId) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return db.collection("Users").doc(userId).collection("Tasks").withConverter(
      fromFirestore: (snapshot, options) {
        return Task.fromFirestore(snapshot.data());
      },
      toFirestore: (taskObj, options) {
        return taskObj.toFirestore();
      },
    );
  }

  Future<void> createTask(String userId, Task task) {
    DocumentReference docRef = getTasksCollection(userId).doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  // Future<List<Task>> getAllTask(String userId, DateTime selectedDate) async {
  //   QuerySnapshot<Task> querySnapshot = await getTasksCollection(userId)
  //       .where("date", isEqualTo: selectedDate.daySinceEpoch())
  //       .orderBy("time")
  //       .get();
  //
  //   return querySnapshot.docs.map<Task>(
  //     (docSnapshot) {
  //       return docSnapshot.data();
  //     },
  //   ).toList();
  // }
  Stream<QuerySnapshot<Task>> getAllTasks(
      String userId, DateTime selectedDate) async* {
    // print(
    //     "getAllTasksStart: ${DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0).millisecondsSinceEpoch}");
    // print(
    //     "getAllTasksEnd: ${DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59).millisecondsSinceEpoch}");
    yield* getTasksCollection(userId)
        .where(Task.dateKey,
            isGreaterThanOrEqualTo: DateTime(
                    selectedDate.year, selectedDate.month, selectedDate.day, 0)
                .millisecondsSinceEpoch)
        .where(Task.dateKey,
            isLessThanOrEqualTo: DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, 23, 59, 59)
                .millisecondsSinceEpoch)
        .orderBy(Task.dateKey)
        .snapshots();
  }

  Future<void> removeTask(String userId, Task task) {
    var docRef = getTasksCollection(userId).doc(task.id);
    return docRef.delete();
  }

  Future<void> changeIsDone(String userId, Task task) {
    var docRef = getTasksCollection(userId).doc(task.id);
    return docRef.update({
      Task.isDoneKey: !task.isDone!,
    });
  }

  Future<void> updateTask(String userId, Task task,
      {required String newTitle,
      required String newDescribtion,
      required int newDate,
      required bool newIsLTR}) {
    var docRef = getTasksCollection(userId).doc(task.id);
    return docRef.update({
      Task.titleKey: newTitle,
      Task.descriptionKey: newDescribtion,
      Task.dateKey: newDate,
      Task.isLTRKey: newIsLTR
    });
  }

  Future<void> deleteTasksCollect(String userId) async {
    var snapShot = await getTasksCollection(userId).get();
    for (var element in snapShot.docs) {
      element.reference.delete();
    }
  }
}
