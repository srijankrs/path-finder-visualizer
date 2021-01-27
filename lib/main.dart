import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterpathfinder/Dijkstra.dart';

import 'CustomWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Path Finder Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


List<List<CustomWidget>> gridState = [];
double strokeWidth = 60.0;
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final X=35, Y=80;
  List<Offset> points = [];
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];
  var pointsMap = {};
  DrawingMode drawingMode = DrawingMode.StartPoint;
  Offset startPoint, endPoint;
  var weightMap = {};


  @override
  void initState() {
    super.initState();
    for(int i=0;i<X;i++){
      List<CustomWidget> temp = [];
      for(int j=0;j<Y;j++){
        temp.add(CustomWidget(i,j,''));
      }
      gridState.add(temp);
    }
  }

  Offset getTransformedOffset(Offset offset){
    int factor = strokeWidth.toInt();
    int factor2 = strokeWidth~/2;
    double x = offset.dx;
    double y = offset.dy-56;

    if(x<5 || y<5)
      return null;


    double newX, newY;
    newX = ((x~/factor)*factor+factor2).toDouble();
    newY = ((y~/factor)*factor+factor2).toDouble();

    Offset newOffset = new Offset(newX, newY);
    if(pointsMap[newOffset]!=null) {
//      print("same offset found");
      points.add(newOffset);
    }
//    if(drawingMode == DrawingMode.EraseMode){
//      pointsMap.remove(newOffset);
//      return null;
//    }
    pointsMap[newOffset] = drawingMode;
    if(drawingMode == DrawingMode.StartPoint) {
      pointsMap.remove(startPoint);
      points.remove(startPoint);
      startPoint = newOffset;
    }
    if(drawingMode == DrawingMode.EndPoint) {
      pointsMap.remove(endPoint);
      points.remove(endPoint);
      endPoint = newOffset;
    }
    if(drawingMode == DrawingMode.Weighted){
      weightMap[newOffset] = 2;
    }
    if(drawingMode==DrawingMode.EraseMode){
      weightMap.remove(newOffset);
    }
    return newOffset;
  }

  void reloadUI(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Path Finder Visualizer'),
        actions: [
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                drawingMode = DrawingMode.StartPoint;
              });},
            child: Text("Start Point"),
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
            color: DrawingMode.StartPoint == drawingMode ? Colors.grey: Colors.transparent,
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                drawingMode = DrawingMode.EndPoint;
              });},
            child: Text("End Point"),
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
            color: DrawingMode.EndPoint == drawingMode ? Colors.grey: Colors.transparent,
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                drawingMode = DrawingMode.Obstacles;
              });},
            child: Text("Obstacle Mode"),
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
            color: DrawingMode.Obstacles == drawingMode ? Colors.grey: Colors.transparent,
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                drawingMode = DrawingMode.Weighted;
              });},
            child: Text("Weight Mode"),
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
            color: DrawingMode.Weighted == drawingMode ? Colors.grey: Colors.transparent,
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                drawingMode = DrawingMode.EraseMode;
              });
            },
            child: Text("Erase Mode"),
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
            color: DrawingMode.EraseMode == drawingMode ? Colors.grey: Colors.transparent,
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              new Dijkstra().visualise(reloadUI,pointsMap, points, strokeWidth.toInt(), startPoint, endPoint, height, width, weightMap);
            },
            child: Text("Visualize"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                points.clear();
                pointsMap.clear();
                weightMap.clear();
              });
            },
            child: Text("Reset"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(),
              decoration: BoxDecoration(
                color: Colors.brown.shade200,
              ),
            ),
            ListTile(
              title: Text('Dijkstra Algorithm'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
//      body: Container(
//        child: _buildGameBody(height, width),
//      ),
    body: GestureDetector(
      onPanUpdate: (details) {
        if(drawingMode == DrawingMode.StartPoint || drawingMode == DrawingMode.EndPoint)
          return;
        Offset offset = this.getTransformedOffset(details.globalPosition);
        if(offset==null) {
//          points.add(null);
          return;
        }
        setState(() {
          RenderBox renderBox = context.findRenderObject();
          points.add(renderBox.globalToLocal(offset));
        });
      },
      onPanStart: (details) {
        Offset offset = this.getTransformedOffset(details.globalPosition);
        if(offset==null)
          return;
        setState(() {
          RenderBox renderBox = context.findRenderObject();
          print(renderBox.globalToLocal(offset));
//          print(offset);
          points.add(renderBox.globalToLocal(offset));
        });
      },
      onPanEnd: (details) {
//        points.forEach((element) {if(element !=null)print("${element.points}");});
        setState(() {
//          points.add(null);
        });
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: DrawingPainter(
          pointsList: points,
          pointsMap: pointsMap,
          weightMap: weightMap
        ),
      ),
    ),
    );
  }
}



class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList, this.pointsMap, this.weightMap});
  List<Offset> pointsList;
  var pointsMap;
  var weightMap;
  List<Offset> offsetPoints = List();
  double opacity = 1.0;
  double iconSizeDiff = 6.0;
  StrokeCap strokeCap = StrokeCap.square;
  var modeToColorMap = {
    DrawingMode.Obstacles:Colors.black87,
    DrawingMode.EndPoint:Colors.green,
    DrawingMode.StartPoint:Colors.blue,
    DrawingMode.Searching:Colors.amber,
    DrawingMode.PathFound:Colors.red,
    DrawingMode.EraseMode:Colors.grey,
    DrawingMode.Searched:Colors.amber,
    DrawingMode.Weighted:Colors.transparent,
  };

  @override
  void paint(Canvas canvas, Size size) {
//    print("painting");
    for (int i = 0; i < pointsList.length; i++) {
//      print(i);
      if(pointsMap[pointsList[i]]==DrawingMode.EraseMode) {
//        pointsMap.remove(pointsList[i]);
        pointsList.removeAt(i);
        i--;
        continue;
      }
//      if (pointsList[i] != null && pointsList[i + 1] != null) {
//        canvas.drawLine(pointsList[i], pointsList[i + 1],
//            this.getPaint(pointsList[i]));
//      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
      if(pointsList[i]==null)
        continue;
//        offsetPoints.clear();
//        offsetPoints.add(pointsList[i]);
//        offsetPoints.add(Offset(
//            pointsList[i].dx + 0.1, pointsList[i].dy + 0.1));
        canvas.drawLine(pointsList[i],pointsList[i], this.getPaint(pointsList[i]));
        if(weightMap[pointsList[i]]!=null)
          paintIcon(canvas,pointsList[i]);
//      }
    }
  }
  void paintIcon(Canvas canvas, Offset offset){
    final icon = Icons.line_weight;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint),
        style: TextStyle(fontSize: strokeWidth-iconSizeDiff,fontFamily: icon.fontFamily, color: Colors.brown));
    textPainter.layout();
    textPainter.paint(canvas, new Offset(offset.dx-(strokeWidth/2-iconSizeDiff/2), offset.dy-(strokeWidth/2-iconSizeDiff/2)));
  }

  Paint getPaint(Offset point) {
    Paint paintBrush = Paint()
      ..strokeCap = pointsMap[point]==DrawingMode.Searching ? StrokeCap.round: StrokeCap.square
      ..isAntiAlias = false
      ..color = pointsMap[point]==null ? Colors.transparent :modeToColorMap[pointsMap[point]]
      ..strokeWidth = strokeWidth-2;
    return paintBrush;
  }

  List<Offset> getMissingOffsets(Offset offset1, Offset offset2){
    List<Offset> offsets = [];
    double x1 = offset1.dx, x2 = offset2.dx, y1 = offset1.dy, y2 = offset2.dy;
    double xFactor = (x1-x2).abs();
    double yFactor = (y1-y2).abs();

    if(xFactor>yFactor){

    }

  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

enum DrawingMode { Obstacles, EndPoint, StartPoint, Searching, Searched, PathFound, EraseMode, Weighted }

