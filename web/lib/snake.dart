import 'dart:math';
import 'dart:html';

import 'renderer.dart';


class Snake {

    final AbstractRenderer _renderer;
    final int _startLength;
    final String _snakeBodyColor;


    /// current travel direction
    SnakeDirection _currentDirection = SnakeDirection.right;

    /// coordinates of the body segments
    List<Point> _body;

    /// Head coordinates
    Point get head => _body.first;

    /// Snake constructor
    Snake(this._renderer, { int startLength: 10, String snakeBodyColor: 'green' })
        : _startLength = startLength, _snakeBodyColor = snakeBodyColor {

        int i = _startLength - 1;
        _body = new List<Point>.generate(_startLength, (int index) => new Point(i--, 0));
    }


    /// Set direction
    bool setDirection(SnakeDirection direction) {

        if(_currentDirection == direction ||
            (_currentDirection == SnakeDirection.left && direction == SnakeDirection.right) ||
            (_currentDirection == SnakeDirection.right && direction == SnakeDirection.left) ||
            (_currentDirection == SnakeDirection.up && direction == SnakeDirection.down) ||
            (_currentDirection == SnakeDirection.down && direction == SnakeDirection.up)
        ) return false;

        _currentDirection = direction;
        return true;
    }


    void grow() {
        // add new head based on current direction
        _body.insert(0, head + _SnakeDirections.get(_currentDirection));
    }

    void _move() {
        // add a new head segment
        grow();

        // remove the tail segment
        _body.removeLast();
    }

    void _draw() {
        // starting with the head, draw each body segment
        for (Point p in _body) {
            _renderer.drawCell(p, _snakeBodyColor);
        }
    }

    bool checkForBodyCollision() {
        for (Point p in _body.skip(1)) {
            if (p == head) {
                return true;
            }
        }

        return false;
    }

    void update() {
        _move();
        _draw();
    }
}


enum SnakeDirection {
    left,
    right,
    up,
    down
}

abstract class _SnakeDirections  {

    static final Map<SnakeDirection, Point<int>> _directions = {
        SnakeDirection.left : const Point(-1, 0),
        SnakeDirection.right : const Point(1, 0),
        SnakeDirection.up : const Point(0, -1),
        SnakeDirection.down : const Point(0, 1)
    };

    static Point<int> get(SnakeDirection direction)
    => _directions[direction];
}

