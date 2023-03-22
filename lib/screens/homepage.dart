import 'package:flutter/material.dart';
import 'package:what_todo/database_helper.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/screens/taskpage.dart';
import 'package:what_todo/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  DatabaseHelper _dbHelper = DatabaseHelper();


  @override
  Widget build(BuildContext context) {
    Future<List<Task>> _taskList = _dbHelper.getTasks();
    return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
              //vertical: 50.0,
            ),
            color: Color(0xFF5073CC),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 40.0,
                        bottom: 12.0,
                      ),
                      child: Image(
                        image: AssetImage(
                          'assets/images/logo.png'
                        ),
                      ),
                    ),
                    Expanded(
                        child: FutureBuilder<List<Task>>(
                          initialData: [],
                          future: _taskList,
                          builder: (context, snapshot) {
                            return ScrollConfiguration(
                              behavior: NoGlowBehavior(),
                              child: ListView.builder(
                                  itemCount: snapshot.data?.length ,
                                  itemBuilder: (context, index){
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Taskpage(
                                                  task: snapshot.data?[index],
                                                ),
                                            ),
                                          ).then(
                                              (value){
                                                setState(() {});
                                          },
                                        );
                                      },
                                      child: TaskCardWidget(
                                        title: snapshot.data?[index].title,
                                        desc: snapshot.data?[index].description,
                                      ),
                                    );
                                    },
                              ),
                            );
                          },
                        ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 24.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Taskpage(task: null)),
                      ).then((value){
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        /*gradient: LinearGradient(
                          colors: [Color(0xF5FE49BC), Color(0xFF643FDB)],
                          begin: Alignment(0.0,-1.0),
                          end: Alignment(0.0,1.0),
                        ),*/
                        color: Color(0xFF57AFFA),
                      ),
                      child: Image(
                        image: AssetImage(
                          "assets/images/add_icon.png"
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
