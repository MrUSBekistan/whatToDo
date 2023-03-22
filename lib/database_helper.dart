import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/models/todo.dart';

class DatabaseHelper{

  Future<Database> databaseOpen() async{
    return openDatabase(
      join(await getDatabasesPath(),'zuTun.db'),
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        return db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, title TEXT, taskId INTEGER, isDone INTEGER)");
        // final Database database = db;
        //return db;
      },
      version: 1,
    );
  }

  /*
  Future<void> deleteDB() async {
    Database _db = await databaseOpen();
    await _db.rawQuery('DROP TABLE IF EXISTS tasks');
    await _db.rawQuery('DROP TABLE IF EXISTS todo');
    print("Datenbank wurde gelöscht");
   */

  Future<void> deleteTask(int id) async {
    Database _db = await databaseOpen();
    await _db.rawDelete("DELETE FROM tasks WHERE id = $id",);
    await _db.rawDelete("DELETE FROM todo WHERE taskId = $id",);
    print("Aufgabe $id gelöscht");
  }

  Future<int> insertTask(Task task) async {
    int Id = 0;
    Database _db = await databaseOpen();
    await _db.insert('tasks', task.toMap(),conflictAlgorithm: ConflictAlgorithm.replace).then((value){
      Id = value;
    });
    print("Aufgabe erstellt mit ID: $Id");
    return Id;
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await databaseOpen();
    await _db.insert('todo', todo.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    print("Todo erstellt");
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await databaseOpen();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
    print("Aufgabenlisten Titel wurde geupdatet");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await databaseOpen();
    await _db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id'");
    print("Aufgabenlisten Beschreibung wurde geupdatet");
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await databaseOpen();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
    print("Todo isDone wurde geupdatet");
  }

  Future<List<Task>> getTasks() async {
    Database _db = await databaseOpen();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]['id'],title: taskMap[index]['title'],description: taskMap[index]['description']);
    });
  }

  Future<List<Todo>> getTodos(int taskID) async {
    Database _db = await databaseOpen();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = '$taskID'");
    //List<Map<String, dynamic>> todoMap = await _db.query('todo');
    print("Ausgabe der Übergebenen TaskID an die DB: "+taskID.toString());
    print("Ausgabe der Liste aus der DB: "+todoMap.toString());
    return List.generate(todoMap.length, (index) {
      return Todo(id: todoMap[index]['id'],title: todoMap[index]['title'],taskId: todoMap[index]['taskId'], isDone: todoMap[index]['isDone']);
    });
  }

}