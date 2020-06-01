import 'package:flutter/material.dart';

class Startscreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Center(
            child: Text("Portfolio App",style: TextStyle(fontSize: 30.0,color: Colors.white),),
          ),

          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Container(
              width: 250.0,
              height: 50.0,
              child: RaisedButton(
                  color: Colors.red,
                  child: Text("Login",style: TextStyle(fontSize: 20.0,color: Colors.white),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  onPressed: (){
                     Navigator.of(context).pushNamed('/login');
                  }),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              width: 250.0,
              height: 50.0,
              child: RaisedButton(
                  color: Colors.deepPurpleAccent,
                  child: Text("Sign Up",style: TextStyle(fontSize: 20.0,color: Colors.white),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  onPressed: (){
                      Navigator.of(context).pushNamed('/signup');
                  }),
            ),
          )
        ],
      ),
    );
  }
}