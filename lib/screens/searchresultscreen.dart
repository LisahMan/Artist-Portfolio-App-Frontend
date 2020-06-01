import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intern_project_app/args/screenarguments.dart';

class SearchResultScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchResultScreenState();
  }
}

class _SearchResultScreenState extends State<SearchResultScreen>{

  List<ImageDetail> _imageList;
  String _id;
  String _username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  void getImages() async{
    String url = "http://10.0.2.2:8000/image/user/"+_id+'/';

    var result = await http.get(url);

    int length = result.contentLength;
    debugPrint('contentLengt : $length');
    var data = json.decode(result.body);
    List<ImageDetail> imageList = new List<ImageDetail>();

    for(var d in data){
      imageList.add(ImageDetail.fromJson(d));
    }
    debugPrint('imageData: $data');

    setState(() {
      _imageList=imageList;
    });



  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ScreenArguments screenArguments = ModalRoute.of(context).settings.arguments;
    _id = screenArguments.id;
    _username = screenArguments.username;

    if(_imageList==null){
      _imageList = new List<ImageDetail>();
      getImages();
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_username),
        ),
        body: (_imageList.length==0)
            ? Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child:  Text("No Image",style: TextStyle(fontSize: 20.0),),
          ),
        )

            : GridView.builder(
            itemCount: _imageList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 5.0,crossAxisSpacing: 5.0),
            itemBuilder: (context,postion){
              return Container(
                width: 200.0,
                height: 300.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("http://10.0.2.2:8000"+_imageList[postion].image),
                        fit: BoxFit.fill
                    )

                ),
              );
            }

        )
    );
  }
}

class ImageDetail{

  String _id;
  String _image;

  ImageDetail(this._id,this._image);

  String get id => this._id;
  String get image => this._image;

  void set id(String _id){
    this._id=_id;
  }

  void set image(String _image){
    this._image = _image;
  }

  ImageDetail.fromJson(Map<String,dynamic> json){
    this._id = json['id'];
    this._image = json['image'];
  }


}