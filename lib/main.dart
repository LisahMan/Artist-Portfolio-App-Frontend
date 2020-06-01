import 'package:flutter/material.dart';
import 'package:intern_project_app/screens/startscreen.dart';
import 'package:intern_project_app/screens/signupscreen.dart';
import 'package:intern_project_app/screens/loginscreen.dart';
import 'package:intern_project_app/screens/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intern_project_app/screens/loadingscreen.dart';
import 'package:intern_project_app/screens/selectimagescreen.dart';
import 'package:intern_project_app/screens/searchscreen.dart';
import 'package:intern_project_app/screens/searchresultscreen.dart';

void main()=> runApp(MainScreen());

class MainScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen>{

  Widget screen = LoadingScreen();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLoggedIn();

  }
  
  void _checkLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('loggedIn')!=null){
      if(prefs.getBool('loggedIn')){
        setState(() {
          screen = HomeScreen();
        });
      }else{
        setState(() {
          screen = Startscreen();
        });
      }
    }
    else{
      setState(() {
        screen = Startscreen();
      });
    }
    
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Photo App",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        primaryColorLight: Colors.deepPurpleAccent,
      ),
      routes: <String,WidgetBuilder>{
        '/start' : (context) => Startscreen(),
        '/signup' : (context) => SignupScreen(),
        '/login' : (context) => LoginScreen(),
        '/home' : (context) => HomeScreen(),
        '/selectimage' : (context) => SelectImageScreen(),
        '/searchuser' : (context) => SearchScreen(),
        '/searchresult' : (context) => SearchResultScreen(),

      },
      home: screen,
    );
  }
}