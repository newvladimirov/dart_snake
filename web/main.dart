import 'dart:html';


import 'lib/renderer.dart';
import 'lib/game.dart';


void main() {

  CanvasRenderer renderer = new CanvasRenderer(querySelector('#canvas'));

  new Game(renderer)..run();
}




