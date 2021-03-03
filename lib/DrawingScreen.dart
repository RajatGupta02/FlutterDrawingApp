import 'dart:ui' as ui; //*********NEW CHANGE**********
import 'dart:typed_data';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class ActiveDrawingArea{
  Offset point;
  Paint areaPaint;
  ActiveDrawingArea({this.point,this.areaPaint});
}

class DrawingArea extends StatefulWidget{
  final int index;
  DrawingArea(this.index);

  @override
  _DrawingareaState createState() => _DrawingareaState(index);
}


  class _DrawingareaState extends State<DrawingArea>{
  GlobalKey _containerKey =GlobalKey();
  StorageReference storageReference= FirebaseStorage().ref();
  bool loading=false;



   void convertWidgetToImage()async{
       RenderRepaintBoundary imageObject= _containerKey.currentContext.findRenderObject();
       ui.Image image= await imageObject.toImage(pixelRatio: 1.0);
       ByteData byteData= await image.toByteData(format: ui.ImageByteFormat.png);
       Uint8List pngBytes =  byteData.buffer.asUint8List();

       this.setState(() {
         loading=true;
       });

       StorageUploadTask storageUploadTask = storageReference.child("Drawing_${DateTime.now().millisecondsSinceEpoch}.png").putData(pngBytes);

       await storageUploadTask.onComplete;
       this.setState(() {
         loading=false;
       });



   }



  final int index;
  _DrawingareaState(this.index);

  List<ActiveDrawingArea> points=[];
  Color selectedColor;
  double strokeWidth;




  @override
  void initState(){
    super.initState();
    selectedColor= Colors.black;
    strokeWidth= 8.0;

  }

  void selectColor(){
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: selectedColor,
            onColorChanged: (color){
              this.setState(() {
                selectedColor=color;
              });
            },

          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK',
            style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
            ),
            onPressed: () {

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {

    final double width= MediaQuery.of(context).size.width;
    final double height= MediaQuery.of(context).size.height;



    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Drawing ${index+1}'),
        backgroundColorStart: Color(0xFF136a8a),
        backgroundColorEnd: Color(0xFF267871),
      ),

        body: Stack(
            children: <Widget>[
              Container(
                decoration : BoxDecoration(
                gradient: LinearGradient(
                 begin: Alignment.bottomCenter,
                 end: Alignment.topCenter,
                 stops: [0.2,1.0],
                 colors: [Color(0xFF00bf8f),Color(0xFF267871),],
                )
               )
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     Container(
                      width: 0.96 * width,
                      height: 0.80 * height,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(20.0)),
                         boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          )
                         ],
                       ),
                       child: GestureDetector(
                         onPanDown: (details){

                          this.setState(() {
                            points.add(ActiveDrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap=StrokeCap.round
                                ..isAntiAlias=true
                                ..color=selectedColor
                                ..strokeWidth=strokeWidth
                            ));
                          });
                          },
                         onPanUpdate: (details){
                           this.setState(() {

                             points.add(ActiveDrawingArea(
                                 point: details.localPosition,
                                 areaPaint: Paint()
                                   ..strokeCap=StrokeCap.round
                                   ..isAntiAlias=true
                                   ..color=selectedColor
                                   ..strokeWidth=strokeWidth
                             ));
                           });
                         },
                         onPanEnd: (details){
                           this.setState(() {
                             points.add(null);
                           });
                         },
                         child: RepaintBoundary(
                           key: _containerKey,
                           child: ClipRRect(

                             borderRadius: BorderRadius.all(Radius.circular(20.0)),
                             child: CustomPaint(
                               child: (loading)? Center(child:CircularProgressIndicator(), ):Center(),
                               painter: MyCustomPainter(points: points, color: selectedColor),
                             ),
                           ),
                         ),

                       ),
                     ),


                     SizedBox(height: 10,),

                     Container(
                       width: 0.96*width,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.all(Radius.circular(20))
                       ),

                       child: Row(
                         children: <Widget>[
                           IconButton(icon: Icon(Icons.invert_colors_outlined, color: selectedColor,), onPressed: (){selectColor();}),
                           Expanded(child: Slider(
                             min: 3.0,
                             max: 20.0,
                             activeColor: selectedColor,
                             value: strokeWidth, onChanged: (value){
                               this.setState(() {
                                 strokeWidth=value;
                               });
                           },
                           ),),
                           IconButton(icon: Icon(Icons.replay_circle_filled), onPressed: (){
                             this.setState(() {
                               points.clear();
                             });
                           }),

                           IconButton(icon: Icon(Icons.save_outlined),
                               onPressed:() {
                             convertWidgetToImage();
                               } ),

                         ],
                       ),

                     ),

                ],
              ),
              )
            ],
       ),

    );
  }
}


class MyCustomPainter extends CustomPainter{
  List<ActiveDrawingArea> points;
  Color color;
  double strokeWidth;
  MyCustomPainter({this.points,this.color,});



  @override
  void paint(Canvas canvas, Size size) {
    Paint background=Paint()..color=Colors.white;
    Rect rect=Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);


    for(int x=0;x<points.length-1;x++){
      if(points[x] !=null && points[x+1]!=null){
         Paint paint=points[x].areaPaint;
         canvas.drawLine(points[x].point, points[x+1].point, paint);

      }

      else if(points[x]!=null && points[x+1]==null){
        Paint paint=points[x].areaPaint;
        canvas.drawPoints(ui.PointMode.points, [points[x].point], paint);

      }


    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
  
}