import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jsonplaceholderapi/User.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future ontenerDatos() async {
    var response =
        await http.get(Uri.http("jsonplaceholder.typicode.com", "users"));
    var jsonData = jsonDecode(response.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(
          u['name'], u['email'], u['address']['city'], u['company']['name']);
      users.add(user);
    }

    print(users.length);

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usuarios',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Usuarios'),
          backgroundColor: Colors.blueGrey[700],
        ),
        body: Container(
          child: FutureBuilder(
            future: ontenerDatos(),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.blueGrey,
                        ),
                        Text(
                          "Cargando",
                          style: TextStyle(
                            fontSize: 21,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[200],
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            )),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.blueGrey[900],
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data[i].name,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data[i].email,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Ciudad:",
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data[i].city,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Empresa:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data[i].company,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
