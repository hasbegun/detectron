import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:lens/controls/web_app.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart' as mime;

final logger = Logger();

class FileUploadApp extends StatefulWidget {
  @override
  _FileUploadAppState createState() => _FileUploadAppState();
}

class _FileUploadAppState extends State<FileUploadApp> {
  dynamic _filesToUpload;
  dynamic _loadError;
  double _progressValue = 0;
  int _progressPercentValue = 0;

  List<int> _selectedFile;
  Uint8List _bytesData;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final String server_endpoint = "http://localhost:8888/upload";

  startWebFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      _filesToUpload = uploadInput.files;
      final file = _filesToUpload[0];
      final reader = new html.FileReader();

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result);
      });
      reader.readAsDataUrl(file);
    });
  }

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedFile = _bytesData;
    });
  }

  Future<String> makeRequest() async {
    var url = Uri.parse(server_endpoint);
    var request = new http.MultipartRequest("POST", url);
    print('make request to $url');

    final reader = new html.FileReader();
    reader.onLoadEnd.listen((e) {
      _handleResult(reader.result);
    });

    // method 1
    var file = _filesToUpload[0];
//    for (var i = 0; i < uploadFiles.length; i++) {
//      var f = uploadFiles[i];
//      print('Processig ${f.name}');
//    }
//      reader.readAsDataUrl(f);
    print("About to send ${file.name} to $url.");
    request.files.add(await http.MultipartFile.fromBytes('file', _selectedFile,
        contentType: new MediaType('application', 'octet-stream'),
        filename: file.name));
    request.send().then((response) {
      if (response.statusCode == 200)
        print("${file.name} uploaded!");
      else
        print('${file.name} upload failed: ${response.statusCode}');
    });

    // optional. show dialog to confirm.
//    showDialog(
//        barrierDismissible: false,
//        context: context,
//        child: new AlertDialog(
//          title: new Text("Details"),
//          content: new SingleChildScrollView(
//            child: new ListBody(
//              children: <Widget>[
//                new Text("Upload successfull"),
//              ],
//            ),
//          ),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text('ok'),
//              onPressed: () {
//                Navigator.pushAndRemoveUntil(
//                  context,
//                  MaterialPageRoute(builder: (context) => WebUploadApp()),
//                  (Route<dynamic> route) => false,
//                );
//              },
//            ),
//          ],
//        ));
  }

  Widget imageView({img_idx = 0}) {
//    if (_uploadFiles.length != 0) {
//      var currentFile = _uploadFiles[0];
//      if (currentFile) {
//        return Container(
//            alignment: Alignment.center, child: Image.file(currentFile));
//      }
//    } else {
//      return Container(
//          alignment: Alignment.center,
//          child: Text('No image has been selected'));
//    }

    // display text
    return Container(
        alignment: Alignment.center, child: Text('No image has been selected'));
    // load img from asserts
//    return Container(
//        alignment: Alignment.center,
//        child: Image(image: AssetImage('images/test1.jpg')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lense file picker'),
        ),
        body: Container(
          child: new Form(
            autovalidate: true,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 28),
              child: new Container(
                  width: 350,
                  child: Column(children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.pink,
                            elevation: 8,
                            highlightElevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            textColor: Colors.white,
                            child: Text('Select a file'),
                            onPressed: () {
                              startWebFilePicker();
                            },
                          ),
                          Divider(
                            color: Colors.teal,
                            thickness: 10,
                          ),
                          MaterialButton(
                            color: Colors.purple,
                            elevation: 8.0,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onPressed: () {
                              makeRequest();
                            },
                            child: Text('Send file to server'),
                          ),
                        ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          color: Colors.red,
                          elevation: 8,
                          highlightElevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          textColor: Colors.white,
                          child: Text('PLACE HOLDER'),
                          onPressed: () {
                            startWebFilePicker();
                          },
                        ),
                        imageView(),
                      ],
                    ),
                  ])),
            ),
          ),
        ),
      ),
    );
  }
}
