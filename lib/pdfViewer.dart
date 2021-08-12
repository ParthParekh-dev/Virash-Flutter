import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewer extends StatefulWidget {
  static var route = '/pdfViewer';

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var pdf_url = args.toString();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Pdf Viewer'),
        ),
        body: PDF().cachedFromUrl(
          pdf_url,
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => Center(child: Text(error.toString())),
        ));
  }
}
