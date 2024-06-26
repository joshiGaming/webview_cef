import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:webview_cef/webview_cef.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final baseUrl = "https://api.curseforge.com";
  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
    "x-api-key":
        "\$2a\$10\$zApu4/n/e1nylJMTZMv5deblPpAWUHXc226sEIP1vxCjlYQoQG3QW",
  };

  Future<String> getbody() async {
    print("body!");
    final res = await http.get(Uri.parse('$baseUrl/v1/mods/643605/description'),
        headers: userHeader);
    final hit = jsonDecode(utf8.decode(res.bodyBytes));
    return hit["data"];
  }

  bool isopened = false;

  @override
  Widget build(BuildContext context) {
    print("build!");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
            floatingActionButton: FloatingActionButton(onPressed: (() async {
              setState(() {
                isopened = !isopened;
              });
            })),
            body: Container(
                color: Color.fromARGB(255, 30, 30, 30),
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.all(100),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(78, 137, 137, 137)),
                        color: Color.fromARGB(255, 30, 30, 30),
                        borderRadius: BorderRadius.circular(18)),
                    child: isopened
                        ? FutureBuilder(
                            future: getbody(),
                            builder: (context, snapshot) {
                              print("future builder!");
                              if (snapshot.hasData) {
                                print("ja");
                                return WebviewWidget(
                                  body: snapshot.data as String,
                                  cacheFilePath: File(
                                      "C:\\Users\\joshi\\Documents\\GitHub\\webview_cef\\example\\lib\\index.html"),
                                );
                              } else {
                                return Container();
                              }
                            })
                        : Container()))));
  }
}
