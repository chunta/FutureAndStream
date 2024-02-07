import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> mockNetworkData() async {
  return Future.delayed(Duration(seconds: 2), () => "我是从互联网上获取的数据");
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
      } =>
        Album(
          userId: userId,
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

void main() {
  test();
  runApp(const MyApp());
}

void test() async {
  await for (final name in femaleNames().map((name) => name.toUpperCase())) {
    print(name);
  }
  final controller = StreamController<String>();
  controller.sink.add('sss');
  controller.sink.add('Joas');

  await for (final value in controller.stream.testccap2) {
    print(value);
  }
}

extension on Stream<String> {
  Stream<String> get testccap => transform(UpperCaseTramsformer());
  Stream<String> get testccap2 => map((name) => name.toUpperCase());
}

class UpperCaseTramsformer extends StreamTransformerBase<String, String> {
  @override
  Stream<String> bind(Stream<String> stream) {
    return stream.map((name) => name.toUpperCase());
  }
}

Stream<String> maleNames() async* {
  yield 'John';
  yield 'Jordan';
}

Stream<String> femaleNames() async* {
  yield 'Mary';
  yield 'Jolin';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Album>(
          future: fetchAlbum(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return RichText(
                text: TextSpan(
                  text: '~~~~${snapshot.data!.title}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textDirection: TextDirection.ltr,
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
