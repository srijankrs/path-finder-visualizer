import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var functionDetails = {};
class CustomWidget extends StatefulWidget {

  int x,y;
  String content;

  CustomWidget(this.x, this.y, this.content);
  @override
  _CustomWidgetState createState() => _CustomWidgetState(x,y, content);
}

class _CustomWidgetState extends State<CustomWidget> {

  int x,y;
  String content;

  _CustomWidgetState(this.x, this.y, this.content);

  Widget _buildGridItem(String content) {

    switch (content) {
      case '':
        return Text('');
        break;
      case 'O':
        return Container(
          color: Colors.blue,
        );
        break;
      case 'P2':
        return Container(
          color: Colors.yellow,
        );
        break;
      case 'T':
        return Icon(
          Icons.terrain,
          size: 40.0,
          color: Colors.red,
        );
        break;
      case 'B':
        return Icon(Icons.remove_red_eye, size: 40.0);
        break;
      default:
        return Text('def');
    }
  }

  void setS(String val){
    this.setState(() {
      content=val;
    });
  }

  void _gridItemTapped(int x, int y){
//    for(int i=0;i<50;i++){
//      functionDetails["$x,$i"]('O');
//      functionDetails["${x+1},$i"]('O');
//      print("$x, $y");
//    }
    setState(() {
      this.content='O';
    });
  }

  void _onPanUpdate(DragUpdateDetails details){
    setState(() {
      this.content='O';
    });
  }
  void _onPanDown(DragDownDetails details){
    setState(() {
      this.content='O';
    });
  }
  void _gridItemTapped2(_){
    setState(() {
      this.content='O';
    });
  }

  @override
  Widget build(BuildContext context) {
    functionDetails["$x,$y"] = setS;
    print("rebuild2");
    return GestureDetector(
      onTap: () => _gridItemTapped(x, y),
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _gridItemTapped2,
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)
          ),
          child: Center(
            child: _buildGridItem(content),
          ),
        ),
      ),
    );
  }

}