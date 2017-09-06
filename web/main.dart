import 'dart:html';


import 'lib/renderer.dart';
import 'lib/game.dart';


void main() {

  CanvasRenderer renderer = new CanvasRenderer(querySelector('#canvas'));
  Element failsCounter = querySelector('#fails-counter');
  Element pointsCounter = querySelector('#points-counter');
  Element bestCounter = querySelector('#best-counter');

  new Game(renderer)
    ..run()
  ..onFail.listen((x) => failsCounter.text = x.toString())
  ..onPoint.listen((x) => pointsCounter.text = x.toString())
  ..onBest.listen((x) => bestCounter.text = x.toString());
}




