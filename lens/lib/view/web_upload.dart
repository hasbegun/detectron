import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:lens/control/web_app.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart' as mime;

final logger = Logger();

class FileUploadApp extends StatefulWidget {
  @override
  _FileUploadAppState createState() => _FileUploadAppState();
}

class _FileUploadAppState extends State<FileUploadApp> {
  List<int> _selectedFile;
  Uint8List _bytesData;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final String server_endpoint = "http://localhost:8888/upload";

  var files;

  startWebFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      files = uploadInput.files;
      final file = files[0];
      final reader = new html.FileReader();

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result);
      });
      reader.readAsDataUrl(file);
    });
  }

//  Future<String> req2(file) async {
//    var url = Uri.parse(server_endpoint);
//    print("req2 url: $url");
//    var file_path = path.join(file.relativePath, file.name);
//    print('file rel path=> ${file.relativePath}');
//    print('file path=> $file_path');
//
//    var request = http.MultipartRequest('POST', url)
//      ..files.add(await http.MultipartFile.fromPath('file1', file_path));
//
//    var response = await request.send();
//    if (response.statusCode == 200)
//      print("Uploaded");
//    else
//      print("response code: ${response.statusCode}");
//
//  }

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedFile = _bytesData;
    });
  }

  Future<String> makeRequest() async {
    var url = Uri.parse(server_endpoint);
    print('make request to $url');

    // method 1
    var request = new http.MultipartRequest("POST", url);
    request.files.add(await http.MultipartFile.fromBytes('file', _selectedFile,
        contentType: new MediaType('application', 'octet-stream'),
        filename: "file_up"));

    request.send().then((response) {
      print("About to send to $url.");
      print(response.statusCode);
      if (response.statusCode == 200)
        print("Uploaded!");
      else
        print('Upload failed: ${response.statusCode}');
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('A Flutter Web file picker'),
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
                    Column(
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
                          ),
                          RaisedButton(
                            color: Colors.purple,
                            elevation: 8.0,
                            textColor: Colors.white,
                            onPressed: () {
                              makeRequest();
                            },
                            child: Text('Send file to server'),
                          ),
                        ])
                  ])),
            ),
          ),
        ),
      ),
    );
  }
}
