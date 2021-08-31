import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import 'homePage.dart';

import 'package:provider/provider.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'animationWidgets.dart';

class PdfViewer extends StatefulWidget {
  static var route = '/pdfViewer';

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var pdfUrl = args.toString();

    bool isConnected = context.watch<InternetProvider>().isConnected;
    if (!isConnected) {
      return Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimationWidgets().noInternet,
        )),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Pdf Viewer'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomePage.route, (r) => false);
                },
                icon: Icon(Icons.home),
              ),
            ],
          ),
          body: PDF().cachedFromUrl(
            pdfUrl,
            placeholder: (progress) => Center(child: Text('$progress %')),
            errorWidget: (error) => Center(child: Text(error.toString())),
          ));
    }
  }
}
