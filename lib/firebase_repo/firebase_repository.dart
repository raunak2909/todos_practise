import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todos_practise/models/todo_model.dart';

class FirebaseRepository {
  static FirebaseFirestore mFireStore = FirebaseFirestore.instance;
  static String collectionToDo = "todos";

  /// add todo
  static void addTodo(TodoModel todo) {
    mFireStore.collection(collectionToDo).add(todo.toDoc()).then((value) {
      mFireStore
          .collection(collectionToDo)
          .doc(value.id)
          .update({"todoId": value.id});
    }).onError((error, stackTrace) {});
  }

  /// fetch all todo
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllTodo() {
    return mFireStore.collection(collectionToDo).snapshots();
  }

  static void markTodoStatus(String todoId, bool status) {
    String currTime = "";

    if (status) {
      currTime = DateTime.now().millisecondsSinceEpoch.toString();
    }

    mFireStore
        .collection(collectionToDo)
        .doc(todoId)
        .update({"isCompleted": status, "completedAt": currTime});
  }
}
