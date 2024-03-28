import 'dart:async';
import 'dart:io';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:webview_cef/webview_cef.dart';
import 'package:html/parser.dart' as html;

class WebviewWidget extends StatefulWidget {
  double? height;
  double? width;
  String body;
  Function(String)? onUrlChange;
  Function(int, String, String, int)? onConsoleMessage;
  File cacheFilePath;
  WebviewWidget({Key? key, this.height, this.width, required this.body, this.onUrlChange, required this.cacheFilePath, this.onConsoleMessage}) : super(key: key);

  @override
  _WebviewWidgetState createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> {
  final _controller = WebViewController();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    print("instance");
    if (!_controller.value) {
      await _controller.initialize();
    }
    Future.delayed(Duration(milliseconds: 50)).then((value) => _controller.loadUrl(
        "file://${widget.cacheFilePath.path}"));

    dom.Document docs = html.parse(await 
            widget.cacheFilePath
        .readAsString());


    docs.body!.innerHtml = md.markdownToHtml(widget.body);

    widget.cacheFilePath
        .writeAsStringSync(docs.outerHtml);
    //onUrlchanged is called when trying to nevigate to difrent site by a user gesture
    _controller.setWebviewListener(WebviewEventsListener(
        onUrlChanged: (url) {
          if(widget.onUrlChange != null) {
            widget.onUrlChange!(url);
          }
          Process.run('open', [url]);
        } ,
        onConsoleMessage: (level, message, source, line) {
          if(widget.onConsoleMessage == null) return;
          widget.onConsoleMessage!(level, message, message, line);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.height,
        width: widget.width,
        child: FutureBuilder(
            future: initPlatformState(),
            builder: ((context, snapshot) {
           //   print("inner builder! : " + _controller.value.toString());
              return Stack(
                children: [
                  AnimatedOpacity(
                      opacity: _controller.value ? 0 : 1,
                      duration: Duration(milliseconds: 400),
                      child: Text("Loading")),
                  AnimatedOpacity(
                      opacity: _controller.value ? 1 : 0,
                      duration: Duration(milliseconds: 400),
                      child: _controller.value
                          ? WebView(_controller)
                          : Container()),
                ],
              );
            })));
  }
}
