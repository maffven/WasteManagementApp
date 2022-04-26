import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> tt = [1, 2, 4];
  List<User> users = [new User("Rawan", "Manar"), new User("Rawan", "Lina")];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
                onTap: () {},
              );
            }),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(user.name),
    ));
  }
}

class User {
  final String name;
  final String email;

  User(this.name, this.email);
}
