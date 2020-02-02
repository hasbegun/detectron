import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'dart:html';
import 'dart:typed_data';
import 'dart:async';

class FileUploadApp extends StatefulWidget {
  String serverEndpoint;
  final String api = 'upload';

  FileUploadApp(String protocol, String server, String port) {
    this.serverEndpoint = '$protocol://$server:$port/${this.api}';
    print(this.serverEndpoint);
  }
  @override
  _FileUploadAppState createState() => _FileUploadAppState();
}

class _FileUploadAppState extends State<FileUploadApp> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _currnet_status = 'No files have been selected';
  FileReader fileReader = FileReader();
  dynamic _uploadFiles;
  Uint8List _imagePreview;
  String fileNameToUpload;
  bool _isUploadBtnVisible = false;

  void pickFile() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      _uploadFiles = uploadInput.files;
      fileReader.readAsArrayBuffer(_uploadFiles[0]);

      fileReader.onLoad.listen((data) {
        setState(() {
          _imagePreview = fileReader.result;
          _currnet_status = 'The file has been loaded.';
          fileNameToUpload = _uploadFiles[0].name;
        });
      });

      fileReader.onError.listen((err) {
        setState(() {
          _currnet_status = "Error occured: $err";
        });
      });

      fileReader.onLoadEnd.listen((e) {
        setState(() {
          _isUploadBtnVisible = true;
        });
      });
    });
  }

  Future<String> uploadToServer() async {
    var url = Uri.parse(widget.serverEndpoint);
    var request = http.MultipartRequest("POST", url);
    // this is one way.
    //    List<int> uploadReady =
    //        Base64Decoder().convert(_imagePreview.toString().split(",").last);

    request.files.add(await http.MultipartFile.fromBytes('file', _imagePreview,
        contentType: MediaType('application', 'octet-stream'),
        filename: fileNameToUpload));
    request.send().then((response) {
      if (response.statusCode == 200)
        print("$fileNameToUpload is uploaded");
      else
        print("Failed to upload $fileNameToUpload");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Lens file analysis")),
        body: Container(
            child: new Form(
          autovalidate: true,
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: new Container(
                width: 400,
                child: Column(
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_currnet_status),
                        ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          color: Colors.red,
                          elevation: 5,
                          highlightElevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          textColor: Colors.white,
                          child: Text('Select a file'),
                          onPressed: () {
                            pickFile();
                          },
                        ),
                        Visibility(
                          visible: _isUploadBtnVisible,
                          child: MaterialButton(
                            color: Colors.red,
                            elevation: 5,
                            highlightElevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            textColor: Colors.white,
                            child: Text('Upload'),
                            onPressed: () {
                              uploadToServer();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: _imagePreview == null
                              ? Container(
                                  child: Text("Image preview shows up here."),
                                )
                              : Container(child: Image.memory(_imagePreview)),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        )));
  }
}
