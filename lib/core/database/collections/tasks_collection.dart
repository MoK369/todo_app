import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/core/database/models/task.dart';
import 'package:todo_app/core/extension_methods/date_time_extension_methods.dart';

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
    print(selectedDate.daySinceEpoch());
    yield* getTasksCollection(userId)
        .where(Task.dateKey, isEqualTo: selectedDate.daySinceEpoch())
        .orderBy(Task.timeKey)
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
      required int newTime,
      required bool newIsLTR}) {
    var docRef = getTasksCollection(userId).doc(task.id);
    return docRef.update({
      Task.titleKey: newTitle,
      Task.descriptionKey: newDescribtion,
      Task.dateKey: newDate,
      Task.timeKey: newTime,
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
