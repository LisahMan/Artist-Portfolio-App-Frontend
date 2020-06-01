import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PortfolioScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PortfolioScreenState();
  }
}

class _PortfolioScreenState extends State<PortfolioScreen>{

  List<ImageDetail> _imageList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(_imageList==null){
      _imageList = new List<ImageDetail>();
      getImages();
    }

  }

  void getImages() async{
    final prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('id');
    String url = "http://10.0.2.2:8000/image/user/"+user+'/';

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

  void _delete(int position) async{
    String url = "http://10.0.2.2:8000"+_imageList[position].id+"/";
    void response = await http.delete(url);
    setState(() {
      _imageList.removeAt(position);
    });
  }

  void _deleteImage(BuildContext context,int position){
        AlertDialog alertDialog = AlertDialog(
          title: Text("Delete"),
          content: Text("Do you want to delete?"),
          actions: <Widget>[
            RaisedButton(
              child: Text("Delete",style: TextStyle(color: Colors.white),),
              onPressed: (){
                _delete(position);
                Navigator.of(context).pop();
                },
            ),

            FlatButton(
              child: Text("Cancel"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );

        showDialog(context: context,
            builder: (context){
          return alertDialog;
            });


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Portfolio"),
      ),
      body: (_imageList==null)
        ?Text("Loading")
        : GridView.builder(
          itemCount: _imageList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 5.0,crossAxisSpacing: 5.0),
          itemBuilder: (context,position){
            return GestureDetector(
              onLongPress: (){
                _deleteImage(context,position);
              },
              child: Container(
                width: 200.0,
                height: 300.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("http://10.0.2.2:8000"+_imageList[position].image),
                        fit: BoxFit.fill
                    )

                ),
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