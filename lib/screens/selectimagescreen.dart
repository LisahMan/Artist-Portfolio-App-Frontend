import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';


class SelectImageScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelectImageScreen();
  }
}

class _SelectImageScreen extends State<SelectImageScreen>{

  File _image;
  bool _sendVisible = false;
  void _getImageCamera() async{

    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if(image!=null) {
      setState(() {
        _image = image;
        _sendVisible = true;
      });
    }
  }

  void _getImageGallery() async{

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(image!=null) {
      setState(() {
        _image = image;
        _sendVisible = true;
      });
    }
  }

  void _uploadImage() async{
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id');
    String url = "http://10.0.2.2:8000/image/";

    var request = http.MultipartRequest("POST",Uri.parse(url));
    request.fields['user'] = id;
    var pic = await http.MultipartFile.fromPath('image', _image.path);
    request.files.add(pic);
    var response = await request.send();
    debugPrint("data: $response");




  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Select an Image",),
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child:  ListView(
            children: <Widget>[

              Row(
                children: <Widget>[

                  Expanded(
                    child: RaisedButton(
                        color: Colors.lightBlue,
                        child: Text("Camera"),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        onPressed: (){
                          _getImageCamera();
                        }),
                  ),

                  SizedBox(
                    width: 5.0,
                  ),

                  Expanded(
                    child: RaisedButton(
                        color: Colors.lightBlueAccent,
                        child: Text("Gallery"),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        onPressed: (){
                          _getImageGallery();
                        }),
                  )

                ],
              ),

              SizedBox(
                height: 10.0,
              ),
              Center(
                child: (_image==null)
                    ? Text("No Image Selected")
                    : Container(
                  width: 500.0,
                  height: 300.0,
                  child: Image.file(_image),
                ),
              ),

              SizedBox(
                height: 20.0,
              ),

              Visibility(
                  visible: (_sendVisible)
                      ? true
                      : false,
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    child: Text("Send",),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    onPressed: (){
                      _uploadImage();
                      Navigator.of(context).pop();
                    },
                  )
              )
            ],
          ) ,
      )


    );
  }
}