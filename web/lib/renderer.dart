import 'dart:html';

const int CELL_SIZE = 10;


abstract class AbstractRenderer {

    Element _rootElement;

    Element get container => _rootElement;

    int get width => _rootElement.offsetWidth;
    int get height => _rootElement.offsetHeight;

    AbstractRenderer(Element renderTo) {
        _rootElement = renderTo;
        renderTo.focus();
    }

    void drawCell(Point coords, String color);

    void clear();
}

class CanvasRenderer extends AbstractRenderer {

    CanvasRenderingContext2D _ctx;

    CanvasRenderer(CanvasElement canvas)
        : super(canvas) {
        _ctx = canvas.getContext('2d');
    }


    @override
    void drawCell(Point coords, String color) {
        _ctx..fillStyle = color
            ..strokeStyle = "white";

        final int x = coords.x * CELL_SIZE;
        final int y = coords.y * CELL_SIZE;

        _ctx..fillRect(x, y, CELL_SIZE, CELL_SIZE)
            ..strokeRect(x, y, CELL_SIZE, CELL_SIZE);
    }

    @override
    void clear() {
        _ctx..fillStyle = "white"
            ..fillRect(0, 0, width, height);
    }

}

