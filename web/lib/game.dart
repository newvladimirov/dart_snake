import 'dart:math';
import 'dart:html';
import 'dart:async';

import 'snake.dart';
import 'renderer.dart';


class Game {
    // smaller numbers make the game run faster
    static const num GAME_SPEED = 111;

    final AbstractRenderer _renderer;
    final StreamController _onFailController = new StreamController.broadcast();
    final StreamController _onPointController = new StreamController.broadcast();
    final StreamController _onBestController = new StreamController.broadcast();

    Stream get onFail => _onFailController.stream;
    Stream get onPoint => _onPointController.stream;
    Stream get onBest => _onBestController.stream;

    num _lastTimeStamp = 0;

    // a few convenience variables to simplify calculations
    int _rightEdgeX;
    int _bottomEdgeY;

    int _points = 0;
    int _fails = 0;
    int _bestPoints = 0;

    Snake _snake;
    Point _food;

    Game(this._renderer)  {

        _rightEdgeX = _renderer.width ~/ CELL_SIZE;
        _bottomEdgeY = _renderer.height ~/ CELL_SIZE;

        initGame();

        window.onKeyDown.listen(_onKeyDown);
    }

    void initGame() {

        _snake = new Snake(_renderer, snakeBodyColor: 'red');
        _food = _randomPoint();
        _points = 0;

    }

    void _onKeyDown(KeyboardEvent event) {

        SnakeDirection direction = null;

        switch(event.keyCode) {
            case KeyCode.LEFT:
                direction = SnakeDirection.left;
                break;
            case KeyCode.RIGHT:
                direction = SnakeDirection.right;
                break;
            case KeyCode.UP:
                direction = SnakeDirection.up;
                break;
            case KeyCode.DOWN:
                direction = SnakeDirection.down;
                break;
        }

        if(direction != null)
            _snake.setDirection(direction);
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
            _onPointController.add(++_points);
            _bestPoints = _points > _bestPoints ? _points : _bestPoints;
            _onBestController.add(_bestPoints);
        }

        // check death conditions
        if (_snake.head.x <= -1 || _snake.head.x >= _rightEdgeX ||
            _snake.head.y <= -1 || _snake.head.y >= _bottomEdgeY ||
            _snake.checkForBodyCollision()) {


            initGame();
            _onFailController.add(++_fails);
            _onPointController.add(_points);

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