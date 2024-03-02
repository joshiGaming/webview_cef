import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:webview_cef/webview_cef.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = WebViewController();
  final _textController = TextEditingController();
  String title = "";
  Map allCookies = {};

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }


  @override
  void initState() {
 
    super.initState();

     //  initPlatformState();
        _controller.setWebviewListener(WebviewEventsListener(
      onTitleChanged: (t) {
        setState(() {
          title = t;
        });
        if(!(t == "Pixie" || t == "file:///Users/joshig/Documents/GitHub/webview_cef/example/lib/index.html")) {
          print("not pixie: ${t}");
        }
      },
      onUrlChanged: (url) {
        print(url);
        _textController.text = url;
      },
    ));
  }

  

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
  
    print("instance");
    if(!_controller.value){
          await _controller.initialize();
    }
   


    


  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      
      home: Scaffold(
    
        floatingActionButton: FloatingActionButton(onPressed: (() async{
        await _controller.loadUrl("file:///Users/joshig/Documents/GitHub/webview_cef/example/lib/index.html");
            dom.Document docs = html.parse( await File("/Users/joshig/Documents/GitHub/webview_cef/example/lib/index.html").readAsString());

        final res = await http.get(Uri.parse(
        'https://api.modrinth.com/v2/project/BYN9yKrV'));
    final hit = jsonDecode(utf8.decode(res.bodyBytes));

  
  docs.body!.innerHtml = md.markdownToHtml(hit["body"]);
  //docs.head!.innerHtml = "";
         File("/Users/joshig/Documents/GitHub/webview_cef/example/lib/index.html").writeAsStringSync(docs.outerHtml);
         _controller.reload();
         print("relaoded");
         setState(() {
           
         });
        })),
          body: FutureBuilder(future: initPlatformState(), builder: ((context, snapshot) {
            return  _controller.value
              ?Container(color: Color.fromARGB(255, 30, 30, 30), child: Container(clipBehavior: Clip.antiAlias, margin: EdgeInsets.all(150),decoration: BoxDecoration(border: Border.all(color: Color.fromARGB(78, 137, 137, 137)), color: Color.fromARGB(255, 30, 30, 30), borderRadius: BorderRadius.circular(18)), child:  WebView(_controller)))
              : const Text("not init");
          })
   
      
    )));
  }
}
