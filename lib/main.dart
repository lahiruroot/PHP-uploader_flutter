
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Uploader',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Quick Upload'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 File _file;
 final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>(); 
  
 Future getFile()async{
   File file = await FilePicker.getFile();

   setState(() {
     _file = file;
   });
 }
 void _uploadFile(filepath)async {
   String fileName = basename(filepath.path);  
   print("file base name:$fileName");
   
   try {
    FormData formData = new FormData.fromMap({
       "name": "Lahiru",
       "age": 22, 
       "file": await MultipartFile.fromFile(filepath.path, filename: fileName),
     });
    Response response = await Dio ().post("http://devstudio.atwebpages.com/uploads.php",data:formData );
   print("file upload response:$response"); 
   _showSnackBarMsg(response.data['message']);
   } catch (e) {
     print("expectiation caugch: $e");
   }
     
        }
     _showSnackBarMsg(String msg){
      _scaffoldstate.currentState
      .showSnackBar(new SnackBar(content: new Text(msg),));
 }
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           RaisedButton(
             child: Text("UPLOAD"),
             onPressed: (){
               _uploadFile(_file);
             },
           )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getFile,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}
