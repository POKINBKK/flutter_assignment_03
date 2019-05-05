import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment_03/utils/firestore.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  } 
}

class MainPageState extends State<MainPage> {
  int _state = 0;

  @override
  Widget build(BuildContext context) {

    final List list_button = <Widget>[
      IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            Navigator.pushNamed(context, "/newsubject");
            },
          ),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            FirestoreTools.deleteAllTask();
            },
          ),
    ];

    return DefaultTabController(
      length: 2,
      initialIndex: _state,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            _state == 0 ? list_button[0] : list_button[1]
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _state,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.assignment),
                title: Text("Task"),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.assignment_turned_in),
                title: Text("Complete"),
              ),
            ],
            onTap: (index){
              setState(() {
                _state = index;
              });
              print(_state);
            }
          ),
        body: _state == 0 ?
        //is that screen 1 ? true ! 
        Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('todo').where('done', isEqualTo: false).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.data.documents.length == 0 ?
              Center(child: Text('No data found..'))
              : 
              ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return CheckboxListTile(
                    title: Text(document['title']),
                    value: document['done'],
                    onChanged: (bool value) {
                      FirestoreTools.updateTask(document.documentID, value);
                    },
                  );
                }).toList(),
              );
            },
          ),
        )
        :
        //Second screen
        Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('todo').where('done', isEqualTo: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.data.documents.length == 0 ?
              Center(child: Text('No data found..'))
              :
              ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return CheckboxListTile(
                    title: Text(document['title']),
                    value: document['done'],
                    onChanged: (bool value) {
                      FirestoreTools.updateTask(document.documentID, value);
                    },
                  );
                }).toList(),
              );
            },
          ),
        )
      ),  
    );
  }
}