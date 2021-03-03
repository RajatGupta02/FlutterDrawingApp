import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DrawingScreen.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';


void main() {
  runApp(MyApp());  //*******************NEW MODIFICATION****************

}




class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.teal,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Delineate_it'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;

  final items = List<String>.generate(1, (_counter) => "Drawing $_counter");
  void _incrementCounter() {
    setState(() {
      items.add('Drawing $_counter');
      _counter++;
    }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: GradientAppBar(
        title: Text('DELINEATE_IT', style: TextStyle( letterSpacing: 5.0),textAlign: TextAlign.center ,),
        titleSpacing: 10.0,
        backgroundColorStart: Color(0xFF136a8a),
        // backgroundColorEnd: Color(0xFF267871),
        backgroundColorEnd: Colors.black,
      ),
      body: _buildListView(context),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Add A New Drawing',
        child: Icon(Icons.add),
        backgroundColor: Colors.black87,
        elevation: 8.0,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ListView _buildListView(BuildContext context){

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context,index){
        return Dismissible(
            background: Container(color: Colors.red[800],child: Icon(Icons.delete, color: Colors.white,)),
            secondaryBackground: Container(color: Colors.red[800], child: Icon(Icons.delete, color: Colors.white,)),
            resizeDuration: Duration(seconds: 1),
            onDismissed: (direction){

            setState(() {
              items.removeAt(index);

            });
          },
          key: ValueKey(items.elementAt(index)),
            child: Card(
             child:ListTile(
              title:Text('Drawing ${index+1}'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){

              Navigator.push(
               context,
               MaterialPageRoute(
               builder: (context) => DrawingArea(index),
               ),
             );
            },


         ),
        ));
       }
    );
  }

  //


}

