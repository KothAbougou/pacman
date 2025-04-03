
class Pawn
{   
  protected Board   _board;
  protected Cell    _cell, _nextCell;
  protected PVector _screenPos, 
                    _lastScreenPos,
                    _lastBoardPos,
                    _boardPos;
  protected int     _direction,
                    _nextDirection;
  protected float   _speed;

  Pawn(Board board)  
  {   
    _board = board;
    _lastScreenPos = new PVector(0,0);
    _lastBoardPos = new PVector(0,0);
    _direction     = LEFT;
    _nextDirection = LEFT;
    _speed = 1;
  }

  public boolean isMoveableTo(String direction)
  {
    int to;
    switch(direction)
    {
      case "currentDirection": to = _direction;     break;
      case "nextDirection":    to = _nextDirection; break;
      default: to = _direction; break;
    }

    PVector _cellPosC = _cell.getPos("center");
    int _cellPosX = int(_cell.getPos("board").x),
        _cellPosY = int(_cell.getPos("board").y);

    Cell nextCell = new Cell();
    boolean checkPositions1 = false;
    boolean checkPositions2 = false;

    switch(to)
    {
      case UP:    
        nextCell = _board.getCells()[_cellPosX][_cellPosY-1]; 
        checkPositions1 = _screenPos.x == nextCell.getPos("center").x;
        checkPositions2 = _screenPos.y == _cellPosC.y;
        break;
      case DOWN:  
        nextCell = _board.getCells()[_cellPosX][_cellPosY+1]; 
        checkPositions1 = _screenPos.x == nextCell.getPos("center").x;
        checkPositions2 = _screenPos.y == _cellPosC.y;
        break;
      case LEFT:  
        if(_cellPosX-1 == -1){ _cellPosX = _board.getNbCol(); }
        nextCell = _board.getCells()[_cellPosX-1][_cellPosY]; 
        checkPositions1 = _screenPos.y == nextCell.getPos("center").y;
        checkPositions2 = _screenPos.x == _cellPosC.x;
        break;
      case RIGHT:
        if(_cellPosX+1 == _board.getNbCol()){ _cellPosX = 0; } 
        nextCell = _board.getCells()[_cellPosX+1][_cellPosY]; 
        checkPositions1 = _screenPos.y == nextCell.getPos("center").y;
        checkPositions2 = _screenPos.x == _cellPosC.x;
        break;
      case 0: return false;
    }

    boolean isntWALL = nextCell.getType() != TypeCell.WALL && checkPositions1;
    boolean isWALL   = nextCell.getType() == TypeCell.WALL && checkPositions1 && !checkPositions2;

    return (isntWALL) || (isWALL);
  }

  public void move(int direction)
  {
    _lastScreenPos = new PVector(_screenPos.x, _screenPos.y);

    switch(direction)
    {
      case UP:    _screenPos.x = _cell.getPos("center").x ; _screenPos.y -= _speed; break;
      case DOWN:  _screenPos.x = _cell.getPos("center").x ; _screenPos.y += _speed; break;
      case LEFT:  _screenPos.y = _cell.getPos("center").y ; _screenPos.x -= _speed; break;
      case RIGHT: _screenPos.y = _cell.getPos("center").y ; _screenPos.x += _speed; break;
      case 0: break;
    }

    if(isMoving("onCellCenter") && (
      (_cell.getPos("board").x == 0 && _direction == LEFT) ||
      (_cell.getPos("board").x == _board.getNbCol()-1 && _direction == RIGHT) ) )
      _screenPos.x = _nextCell.getPos("center").x;

    _cellAssociation();
  }

  public boolean isMoving(String from)
  {
    boolean isMoving;
    switch(from)
    {
      case  "onScreen": isMoving = !(_screenPos.x == _lastScreenPos.x && _screenPos.y == _lastScreenPos.y); break;
      case "overCells": isMoving = !(_boardPos.x == _lastBoardPos.x && _boardPos.y == _lastBoardPos.y); break;
      case "onCellCenter": isMoving = !(_screenPos.x == _cell.getPos("center").x && _boardPos.y == _cell.getPos("center").y); break;
               default: isMoving = false;
    }

    return isMoving;
  }

  protected void _cellAssociation()
  {
    Cell c;
    for(int col=0; col < _board.getNbCol(); col++){
      for(int row=0; row < _board.getNbRow(); row++){
        c = _board.getCells()[col][row];
        if(c.isPointInside(_screenPos) && _cell != c)
        {
          _lastBoardPos = _cell.getPos("board");
          _cell = c;
          _nextCellAssociation(_direction);
          _boardPos = _cell.getPos("board");
          return;
        }
      }
    }
  }

  protected void _nextCellAssociation(int direction)
  {
    int ncX = int(_cell.getPos("board").x),
        ncY = int(_cell.getPos("board").y);

    Cell nextCell = new Cell();
    switch(direction)
    {
      case UP:    nextCell = _board.getCells()[ncX][ncY-1]; break;
      case DOWN:  nextCell = _board.getCells()[ncX][ncY+1]; break;
      case LEFT:  
        if(ncX-1 == -1){ ncX = _board.getNbCol(); } 
        nextCell = _board.getCells()[ncX-1][ncY]; 
        break;
      case RIGHT: 
        if(ncX+1 == _board.getNbCol()){ ncX = -1; }
        nextCell = _board.getCells()[ncX+1][ncY]; 
        break;
    }

    _nextCell = nextCell;
  }

  public void setDirection(String which, int to)
  {
    switch(which)
    {
      case "current": _direction = to;     break;
      case "next":    _nextDirection = to; break;
    }
  }

  public int getDirection(String which)
  {
    int direction = _direction;
    switch(which)
    {
      case "current": direction = _direction;     break;
      case "next":    direction = _nextDirection; break;
    }

    return direction;
  }

  public int reverseDirection()
  {
    int reverseDirection;
    switch(_direction) {
      case UP:    reverseDirection = DOWN;  break;
      case DOWN:  reverseDirection = UP;    break;
      case LEFT:  reverseDirection = RIGHT; break;
      case RIGHT: reverseDirection = LEFT;  break;
      default:    reverseDirection = 0;     break;
    }
    return reverseDirection;
  }

  public Cell getCell()
  {
    return _cell;
  }

  public void setScreenPos(float x, float y)
  {
    _screenPos.x = x;
    _screenPos.y = y;
    _cellAssociation();
  }
  public PVector getScreenPos()
  {
    return _screenPos;
  }

}