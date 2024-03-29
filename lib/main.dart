import 'dart:convert';
import 'dart:async';
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
  runApp(const MyApp());
}

void test() async {
  final allall = await maleNames().toList();
  print(allall);
  final result = await getTmpNames()
      .asyncMap((name) => extractCharacters(name))
      .fold('', (previous, element) {
    final elements = element.join(' ');
    return '$previous $elements';
  });

  final threeTimes = getTmpNames().asyncExpand((event) => times3(event));
  await for (final name in threeTimes) {
    (name);
  }

  final controller = StreamController<String>.broadcast();
  // ignore: unused_local_variable
  final sub1 = controller.stream.listen((event) {
    print(" line 76 ${event}");
  });

  controller.sink.add("1");
  controller.sink.add("2");
}

extension BecomeDouble on int {
  int doubleIt() {
    return this * 2;
  }
}

Stream<String> getTmpNames() async* {
  yield 'REX';
  yield 'HELLO';
}

Stream<String> times3(String value) =>
    Stream.fromIterable(Iterable.generate(3, (_) => value));

extension AbsorbErrors<T> on Stream<T> {
  Stream<T> aabb() => handleError((_, __) {});

  Stream<T> aabbs() => transform(StreamTransformer.fromHandlers(
        handleError: (_, __, sink) {
          sink.close();
        },
      ));
}

Future<List<String>> extractCharacters(String from) async {
  final characters = <String>[];
  for (final character in from.split('')) {
    await Future.delayed(Duration(microseconds: 100));
    characters.add(character);
  }
  return characters;
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

  @override
  Widget build(BuildContext context) {
    test();
    return Center(
      child: FutureBuilder<Album>(
          future: fetchAlbum(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text(
                  "Error",
                  textDirection: TextDirection.ltr,
                );
              }
              return RichText(
                text: TextSpan(
                  text: '~~~~${snapshot.data!.title}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                textDirection: TextDirection.ltr,
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
