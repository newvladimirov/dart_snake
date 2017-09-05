import 'dart:math';
import 'dart:html';

import 'snake.dart';
import 'renderer.dart';


class Game {
    // smaller numbers make the game run faster
    static const num GAME_SPEED = 50;

    final AbstractRenderer _renderer;

    num _lastTimeStamp = 0;

    // a few convenience variables to simplify calculations
    int _rightEdgeX;
    int _bottomEdgeY;

    Snake _snake;
    Point _food;

    Game(this._renderer)  {

        _rightEdgeX = _renderer.width ~/ CELL_SIZE;
        _bottomEdgeY = _renderer.height ~/ CELL_SIZE;

        init();
    }

    void init() {
        _snake = new Snake(_renderer);
        _food = _randomPoint();
    }

    Point _randomPoint() {
        Random random = new Random();
        return new Point(random.nextInt(_rightEdgeX), random.nextInt(_bottomEdgeY));
    }

    void _checkForCollisions() {
        // check for collision with food
        if (_snake.head == _food) {
            _snake.grow();
            _food = _randomPoint();
        }

        // check death conditions
        if (_snake.head.x <= -1 || _snake.head.x >= _rightEdgeX ||
            _snake.head.y <= -1 || _snake.head.y >= _bottomEdgeY ||
            _snake.checkForBodyCollision()) {
            init();
        }
    }

    void run() {
        window.animationFrame.then(update);
    }

    void update(num delta) {
        final num diff = delta - _lastTimeStamp;

        if (diff > GAME_SPEED) {
            _lastTimeStamp = delta;
            _renderer.clear();
            _renderer.drawCell(_food, "blue");
            _snake.update();
            _checkForCollisions();
        }

        // keep looping
        run();
    }
}