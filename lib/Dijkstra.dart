import 'dart:io';
import 'dart:ui';

import 'package:flutterpathfinder/main.dart';

class Dijkstra {
  Future<void> visualise(Function updateUI, var pointMap, List<Offset> points,
      int factor, Offset start, Offset end, double height, double width, var weightMap) async {
    print("This $updateUI $pointMap $points");
    int startIndex = points.length;
    var checked = {};
    var weight = {};
    var parent = {};
    checked[start] = true;
    weight[start] = 0;
    Offset current = start;
//    int ch =1;
    print("size ${weightMap.length}");
    while (true) {
//      print(weight);
//      print(checked);
      addAllNextPoints(
          current, checked, pointMap, weight, points, factor, height, width, parent, weightMap);
      Offset next =
          getNextPoint(points, checked, pointMap, current, startIndex, weight, weightMap);
      current = next;
      if (end == next) {
        print("$next $end");
        pointMap[end] = DrawingMode.EndPoint;
        break;
      }
      await Future.delayed(Duration(milliseconds: 5));
      updateUI();
    }

    updatePath(parent, pointMap, start, end, updateUI);

    print("size ${weightMap.length}");
    print("done");
  }

  Future<void> updatePath(var parent, var pointMap, Offset start, Offset end, Function updateUI) async {
    List<Offset> path = [];
    Offset offset = parent[end];
    path.add(offset);
    while(offset!=start){
      path.add(offset);
      offset = parent[offset];
    }
    for(int i=path.length-1;i>=0;i--){
      pointMap[path[i]] = DrawingMode.PathFound;
      await Future.delayed(Duration(milliseconds: 10));
      updateUI();
    }
  }

  Offset getNextPoint(List<Offset> points, var checked, var pointMap,
      Offset current, int startIndex, var weight, var weightMap) {
    int indexWeight = 1000;
    int index = 0;
    for (int i = startIndex; i < points.length; i++) {
      Offset offset = points[i];
      if (checked[offset] == null &&
          pointMap[offset] != DrawingMode.Obstacles &&
          pointMap[offset] != DrawingMode.StartPoint) {
        if (weight[offset] < indexWeight) {
          indexWeight = weight[offset];
          index = i;
        }
      }
    }

    checked[points[index]] = true;

//    if(weightMap[points[index]]==null)
      pointMap[points[index]] = DrawingMode.Searched;
    return points[index];
  }

  void doForOffset(
      Offset offset,
      Offset nextOffset,
      var checked,
      var pointMap,
      var weight,
      List<Offset> points,
      int factor,
      double height,
      double width,
      var parent, var weightMap) {
    if (nextOffset.dy < 0 ||
        nextOffset.dx < 0 ||
        nextOffset.dy > height ||
        nextOffset.dx > width) return;
    if (pointMap[nextOffset] == DrawingMode.Obstacles ||
        pointMap[nextOffset] == DrawingMode.StartPoint) return;

    if (checked[nextOffset] == null) {
      points.add(nextOffset);
//      if(weightMap[nextOffset]==null)
        pointMap[nextOffset] = DrawingMode.Searching;
    }
    if (weight[nextOffset] == null || weight[offset] < weight[nextOffset]) {
      weight[nextOffset] = weight[offset] + (weightMap[nextOffset]!=null?weightMap[nextOffset]:1);
      parent[nextOffset] = offset;
    }
  }

  void addAllNextPoints(Offset offset, var checked, var pointMap, var weight,
      List<Offset> points, int factor, double height, double width, var parent, var weightMap) {
    Offset nextOffset;

//    nextOffset = new Offset(offset.dx + factor, offset.dy + factor);
//    doForOffset(offset, nextOffset, checked, pointMap, weight, points, factor);

//    nextOffset = new Offset(offset.dx - factor, offset.dy - factor);
//    doForOffset(offset, nextOffset, checked, pointMap, weight, points, factor);

    nextOffset = new Offset(offset.dx + factor, offset.dy);
    doForOffset(offset, nextOffset, checked, pointMap, weight, points, factor,
        height, width, parent, weightMap);

    nextOffset = new Offset(offset.dx, offset.dy + factor);
    doForOffset(offset, nextOffset, checked, pointMap, weight, points, factor,
        height, width, parent, weightMap);

    nextOffset = new Offset(offset.dx, offset.dy - factor);
    doForOffset(offset, nextOffset, checked, pointMap, weight, points, factor,
        height, width, parent, weightMap);

    nextOffset = new Offset(offset.dx - factor, offset.dy);
    doForOffset(offset, nextOffset, checked, pointMap, weight, points, factor,
        height, width, parent, weightMap);

//    nextOffset = new Offset(offset.dx - factor, offset.dy + factor);
//    doForOffset(offset, nextOffset, checked, pointMap, weight, points, factor);
//
//    nextOffset = new Offset(offset.dx + factor, offset.dy - factor);
//    doForOffset(offset, nextOffset, checked, pointMap, weight, points, factor);
  }
}
