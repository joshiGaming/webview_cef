import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
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





class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final _controller = WebViewController();
  final _textController = TextEditingController();
  String title = "";
  Map allCookies = {};
  late Animation<double> animation;
  late AnimationController _anicontroller;


  @override
  void initState() {
    super.initState();

    _anicontroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animation =
        CurvedAnimation(parent: _anicontroller, curve: Curves.easeOut);

    animation.addListener(() {
      print("object");
    });
    //  initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    print("instance");
    if (!_controller.value) {
      await _controller.initialize();
      
    }

    //onUrlchanged is called when trying to nevigate to difrent site by a user gesture
    _controller.setWebviewListener(WebviewEventsListener(onUrlChanged: (url) => Process.run('open', [url]), onConsoleMessage: (level, message, source, line) => print("level/line: $level, $line | message: $message | source: $source",)));
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
            floatingActionButton: FloatingActionButton(onPressed: (() async {
              await _controller.loadUrl(
                  "file:///Users/joshig/Documents/GitHub/webview_cef/example/lib/index.html");
              dom.Document docs = html.parse(await File(
                      "/Users/joshig/Documents/GitHub/webview_cef/example/lib/index.html")
                  .readAsString());

              final res = await http.get(
                  Uri.parse('https://api.modrinth.com/v2/project/BYN9yKrV'));
              final hit = jsonDecode(utf8.decode(res.bodyBytes));

              docs.body!.innerHtml = md.markdownToHtml(hit["body"]);

              //docs.head!.innerHtml = "";
              File("/Users/joshig/Documents/GitHub/webview_cef/example/lib/index.html")
                  .writeAsStringSync(docs.outerHtml);
              _controller.reload();
              print("relaoded");

              setState(() {});
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
                    child: Stack(
                      children: [
                        FutureBuilder(
                            future: initPlatformState(),
                            builder: ((context, snapshot) {
                              return _controller.value
                                  ? WebView(_controller)
                                  : const Text("not init");
                            })),
                        Positioned.fill(
                            top: 0,
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: MouseRegion(
                                    onEnter: (event) {
                                      print("enter");
                                      _anicontroller.forward();
                                    },
                                    onExit: (event) =>
                                        _anicontroller.reverse(),
                                    hitTestBehavior:
                                        HitTestBehavior.translucent,
                                    child: Container(
                                        height: 100,
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: SizeTransition(
                                                axis: Axis.vertical,
                                                axisAlignment: 2.0,
                                                sizeFactor: animation,
                                                child: Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(44, 0, 0, 0),
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        78,
                                                                        137,
                                                                        137,
                                                                        137)))),
                                                    child: ClipRect(
                                                       
                                                        // <-- clips to the 200x200 [Container] below
                                                        child: BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                            sigmaX: 20.0,
                                                            sigmaY: 20.0,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                  onPressed: () =>
                                                                      _controller
                                                                          .goBack(),
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_back_ios,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 18,
                                                                  )),
                                                                     IconButton(
                                                                  onPressed: () =>
                                                                      _controller
                                                                          .goForward(),
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 18,
                                                                  )),
                                                                     IconButton(
                                                                  onPressed: () =>
                                                                      _controller
                                                                          .reload(),
                                                                  icon: Icon(
                                                                    Icons
                                                                        .redo,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 18,
                                                                  ))
                                                            ],
                                                          ),
                                                        )))))))))
                      ],
                    )))));
  }
}
