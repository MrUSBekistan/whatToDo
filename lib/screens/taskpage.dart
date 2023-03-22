import 'package:flutter/material.dart';
import 'package:what_todo/database_helper.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/models/todo.dart';
import 'package:what_todo/widgets.dart';

class Taskpage extends StatefulWidget {
  //const Taskpage({Key? key}) : super(key: key);
  final Task? task;
  Taskpage({required this.task});

  @override
    _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {

  DatabaseHelper _dbHelper = DatabaseHelper();
  int _taskId = 0;
  bool _contentvisibil = false;
  String _taskDescription = "";
  String _taskTitle = "";
  Task? _newTask = null;
  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  @override
  void initState(){
    print("ID: ${widget.task?.id}");
    if (widget.task != null){
      _taskTitle = widget.task!.title!;
      _taskId = widget.task!.id!;
      _contentvisibil = true;
      if (widget.task?.description != null) {
        _taskDescription = widget.task!.description!;
      }
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    //_dbHelper.deleteDB();
    super.initState();
  }

  @override
  void dispose(){
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Todo>> _todoList = _dbHelper.getTodos(_taskId);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xFF6A9BEB),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 24.0,
                        bottom: 6.0,
                      ),
                      child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage('assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              //Checks if field is not empty
                              if(value != ""){
                                //Checks if taskID is not null
                                _taskTitle = value;
                                if(_taskId == 0){
                                   _newTask = Task(
                                      title: value);
                                      _taskId = await _dbHelper.insertTask(_newTask!);
                                        setState(() {});
                                        _contentvisibil = true;
                                      print("Neue Aufgabe wurde erstellt mit der ID Nr. "+_taskId.toString());
                                  } else {
                                     await _dbHelper.updateTaskTitle(_taskId, _taskTitle);
                                  print("Die vorhandene Aufgabe wurde angepasst mit dem Titel:"+_taskTitle);
                                  }
                                _descriptionFocus.requestFocus();
                                }
                            },
                            controller: TextEditingController()..text= _taskTitle,
                            decoration: InputDecoration(
                              hintText: "Aufgabentitel eingeben ...",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC9E9F0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                    Visibility(
                      visible: _contentvisibil,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 12.0
                        ),
                        child: TextField(
                          focusNode: _descriptionFocus,
                          onSubmitted: (value) async {
                            if (value != ""){
                              if(_taskId != 0){
                                await _dbHelper.updateTaskDescription(_taskId, value);
                                _taskDescription = value;
                              }
                            }
                              _todoFocus.requestFocus();
                            },
                          controller: TextEditingController()..text = _taskDescription,
                          decoration: InputDecoration(
                              hintText: "Hier Beschreibung eingeben ...",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 24.0,
                            )
                          ),
                          style: TextStyle(
                          color: Color(0xFFC9E9F0),
                        ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _contentvisibil,
                      child: FutureBuilder<List<Todo>>(
                        initialData: [],
                        future: _todoList,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          else {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data?.length ?? 5,
                                itemBuilder: (context, index) {
                                  //print("snapshot zu String "+snapshot.data?.length.toString());
                                  return GestureDetector(
                                    onTap: () async {
                                      if(snapshot.data[index].isDone == 0){
                                        await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                                      }else{
                                        await _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                                      }
                                      setState(() {});
                                    },
                                    child: TodoWidget(
                                      text: snapshot.data?[index].title,
                                      isDone: snapshot.data?[index].isDone == 0
                                          ? false
                                          : true,
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: _contentvisibil,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                        ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20.0,
                                    height: 20.0,
                                    margin: EdgeInsets.only(
                                      right: 12.0,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(6.0),
                                        border: Border.all(
                                          color: Color(0xFFC9E9F0),
                                          width: 1.5,
                                        )
                                    ),
                                    child: Image(
                                      image: AssetImage("assets/images/check_icon.png"),
                                    ),
                                  ),
                                  Expanded(
                                      child: TextField(
                                        focusNode: _todoFocus,
                                        controller: TextEditingController()..text = "",
                                        onSubmitted: (value) async{
                                          //checkt ob Feld gefüllt
                                          _newTask = Task(id: _taskId);
                                          if(value != ""){
                                            //Checks if task is not null
                                            if(widget.task != null) {
                                              Todo _newTodo = Todo(
                                                title: value,
                                                isDone: 0,
                                                taskId: widget.task!.id,
                                                );
                                              await _dbHelper.insertTodo(_newTodo);
                                              setState(() {});
                                              _todoFocus.requestFocus();
                                              //print("Die eingegeben ToDo wurden erstellt mit der TaskID "+_taskId.toString());
                                            }
                                            else{
                                              if(_newTask != null) {
                                                Todo _newTodo = Todo(
                                                  title: value,
                                                  isDone: 0,
                                                  taskId: _newTask!.id,
                                                );
                                                await _dbHelper.insertTodo(_newTodo);
                                                setState(() {});
                                                _todoFocus.requestFocus();
                                                //print("neue Todo aus _newTask erstellt ");
                                                //print("Task= " + _newTask.toString());
                                              }
                                            }
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Gib eine Aufgabe ein.",
                                          border: InputBorder.none,
                                        ),
                                          style: TextStyle(
                                            color: Color(0xFFC9E9F0)),
                                      )
                                  )
                                ],
                              ),
                            ),
                    ),
                ],
              ),
              Visibility(
                visible: _contentvisibil,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if(_taskId != 0) {
                       await _dbHelper.deleteTask(_taskId);
                       Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0xFFE6D2E6)
                      ),
                      child: Image(
                        image: AssetImage(
                            "assets/images/delete_icon.png"
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
