
class Board extends KBoard
{
  private Cell[][] _cells;
  private Level    _level;
  private boolean  _alert;
  
  Board(Level level, int cellSize)
  {
    super(level.nbCol, level.nbRow, cellSize);

    _level    = level;
    _alert    = false;

    _initCells();
  }
  
  private void _initCells()
  {
    _cells = new Cell[_nbCol][_nbRow];

    // création des cellules
    for(int col = 0; col < _nbCol; ++col) {
      for(int row = 1; row < _nbRow+1; ++row) {

        TypeCell cell_type = TypeCell.EMPTY;

        switch(_level.getFile()[row].charAt(col))
        {
          case 'x': cell_type = TypeCell.WALL;      break;
          case 'V': cell_type = TypeCell.EMPTY;     break;
          case 'o': cell_type = TypeCell.DOT;       break;
          case 'O': cell_type = TypeCell.SUPER_DOT; break;
          case 'P': cell_type = TypeCell.PACMAN;    break;
          case 'G': cell_type = TypeCell.GHOST;     break;
          case 'T': cell_type = TypeCell.TEST;      break;
        }

        Cell c = new Cell(cell_type, new PVector(col, row-1), _cellSize);
        c.setMargin(_position);

        _cells[col][row-1] = c;
      }
    }

    // vérification des cellules de croisements
    for(int x = 0; x < _nbCol; ++x){
      for(int y = 0; y < _nbRow; ++y){
        Cell c = _cells[x][y];
        c.initAccess(this);
      }
    }
  }

  public Cell getPacmanCell()
  { 
    Cell c = new Cell();
    for(int x = 0; x < _nbCol; ++x)
      for(int y = 0; y < _nbRow; ++y){

        c = _cells[x][y];

        if(c.getType() == TypeCell.PACMAN)
          return c;
      }
    return c;
  }

  public ArrayList<Cell> getGhostsCells()
  {
    ArrayList<Cell> ghostCells = new ArrayList<Cell>();
    Cell c = new Cell();
    for(int x = 0; x < _nbCol; x++){
      for(int y = 0; y < _nbRow; y++){

        c = _cells[x][y];

        if(c.getType() == TypeCell.GHOST)
          ghostCells.add(c);
      }
    }

    return ghostCells;
  }

  public ArrayList<Cell> getSingleAccessCells()
  {
    ArrayList<Cell> singleAccessCells = new ArrayList<Cell>();
    Cell c = new Cell();
    for(int x = 0; x < _nbCol; x++){
      for(int y = 0; y < _nbRow; y++){

        c = _cells[x][y];

        if(c.getType() == TypeCell.GHOST && c.getAccess().size() == 1)
          singleAccessCells.add(c);
      }
    }

    return singleAccessCells;
  }


  public ArrayList<Cell> getCellsAround(Cell cell, int denyAccess)
  {
    ArrayList<Cell> cellsAround = new ArrayList<Cell>();
    ArrayList<Integer> cellAccess = cell.getAccess();
    ArrayList<Integer> allowedAccess = new ArrayList<Integer>();

    int cellX = int(cell.getPos("board").x),
        cellY = int(cell.getPos("board").y);

    for(Integer access : cellAccess)
      if(access != denyAccess)
        allowedAccess.add(access);

    for(Integer access : allowedAccess)
    {
      Cell c = new Cell();
      switch(access)
      {
        case UP:    c = _cells[cellX][cellY-1]; break;
        case DOWN:  c = _cells[cellX][cellY+1]; break;
        case LEFT:
          if(cellX-1 == -1){ cellX = _nbCol; }  
          c = _cells[cellX-1][cellY]; 
          break;
        case RIGHT: 
          if(cellX+1 == _nbCol-1){ cellY = 0; }  
          c = _cells[cellX+1][cellY]; 
          break;
      }
      cellsAround.add(c);
    }

    return cellsAround;
  }



  public PVector boardPosConversion(PVector screenPos)
  {
    float boardPosX = (screenPos.x - _position.x) / _cellSize;
    float boardPosY = (screenPos.y - _position.y) / _cellSize;

    return new PVector(boardPosX, boardPosY);
  }

  public void setColor(color c)
  {
    if(getColor() != c)
    {
      for(int x = 0; x < _nbCol; ++x)
        for(int y = 0; y < _nbRow; ++y)
        {
          Cell _cell = _cells[x][y];
          if(_cell.getType() == TypeCell.WALL)
            _cell.setColor(c);
        }
    }
  }

  public color getColor()
  {
    return _cells[0][0].getColor();
  }

  public void endScaredModeAlert(KTimer timer)
  {
    setAlert(true);
    float timerMillis = timer.getTime() * 1000;
    float elapsedTime = abs(avant - timerMillis);

    if(elapsedTime >= 200)
    {
      //println(elapsedTime);
      switch(getColor())
      {
        case BLUE: setColor(PURPLE); break;
        case PURPLE: setColor(BLUE); break;
      }

      avant = timerMillis;
    }
  }

  public boolean isAlerting()
  {
    return _alert;
  }

  public void setAlert(boolean b)
  {
    _alert = b;
  }

  public Cell[][] getCells()
  {
    return _cells;
  }
  
  public void drawing(){
    stroke(BLACK);
    strokeWeight(1);
    for(int x = 0; x < _nbCol; ++x)
      for(int y = 0; y < _nbRow; ++y)
        _cells[x][y].drawing();
  }
}
