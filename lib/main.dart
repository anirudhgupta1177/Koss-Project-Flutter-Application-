import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Album {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Album(this.albumId, this.id, this.title, this.url, this.thumbnailUrl);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Album KOSS Project',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          canvasColor: const Color.fromARGB(255, 247, 195, 212)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getUserData() async {
    var response =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'photos'));
    var jsonData = jsonDecode(response.body);

    List<Album> albums = [];

    for (var u in jsonData) {
      Album album =
          Album(u['albumId'], u['id'], u['title'], u['url'], u['thumbnailUrl']);
      albums.add(album);
    }
    print(albums.length);
    return albums;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Album')),
        body: Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          child: FutureBuilder(
            future: getUserData(),
            builder: ((context, snapshot) {
              if (snapshot.data == null) {
                return const Text('Loading...');
              } else {
                return GridView(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2/3,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20),
                    children: (snapshot.data as List)
                        .map((e) => Card(
                            color: const Color.fromARGB(255, 146, 115, 150),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Image.network(e.thumbnailUrl,
                                      fit: BoxFit.cover),
                                  Expanded(
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 146, 115, 150),
                                      padding: const EdgeInsets.all(10),
                                      child: Text(e.title,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          textAlign: TextAlign.center),
                                    ),
                                  )
                                ],
                              ),
                            )))
                        .toList());
              }
            }),
          ),
        ));
  }
}
