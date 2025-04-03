enum TypeCell 
{
  EMPTY("V"), 
  WALL("x"), 
  DOT("o"), 
  SUPER_DOT("O"), 
  PACMAN("P"), 
  GHOST("G"), 
  TEST("T"),
  OUT_BOARD("|");

  private final String _sign;

  TypeCell(String sign)
  {
    _sign = sign;
  }

  public String getSign()
  {
    return _sign;
  }
}

class Cell extends KCell
{
  private TypeCell _type;
  private ArrayList<Integer> _access;


  Cell(TypeCell type, PVector boardPos, int cellSize)
  {
    super(boardPos, cellSize);

    _type      = type;
    _access    = new ArrayList<Integer>();

    _initColor();
    setKeStrokeColor(BLACK);
    setKeStrokeWeight(1);
  }
  Cell()
  { 
    super();
    _type = TypeCell.WALL; 
  }

  private void _initColor()
  {
    switch(_type)
    {
      case WALL: setKeBackgroundColor(BLUE);  break;
      case TEST: setKeBackgroundColor(RED);   break;
        default: setKeBackgroundColor(BLACK); break;
    }
  }

  public void initAccess(Board board)
  {
    Cell[][] cells = board.getCells();
    Cell uCell = new Cell(), 
         lCell = new Cell(), 
         rCell = new Cell(), 
         dCell = new Cell();

    int _x = int(_boardPos.x),
        _y = int(_boardPos.y);

    if(_type != TypeCell.WALL && _x-1 >= 0 && _x+1 < board.getNbCol() && _y-1 >=0 && _y+1 < board.getNbRow())
    {
      uCell = cells[_x][_y-1];
      lCell = cells[_x-1][_y];
      rCell = cells[_x+1][_y];
      dCell = cells[_x][_y+1];

    }else if(_type != TypeCell.WALL && _x-1 <= -1)
    {
      lCell.setType(TypeCell.OUT_BOARD);
    }else if(_type != TypeCell.WALL && _x+1 >= board.getNbCol())
    {
      rCell.setType(TypeCell.OUT_BOARD);
    }

    if(uCell.getType() != TypeCell.WALL) _access.add(UP);   
    if(rCell.getType() != TypeCell.WALL) _access.add(RIGHT);
    if(dCell.getType() != TypeCell.WALL) _access.add(DOWN); 
    if(lCell.getType() != TypeCell.WALL) _access.add(LEFT); 

    //if(isPivotCell()) _color = PURPLE;
  }

  public boolean isPivotCell()
  {
    return _access.size() > 2;
  }

  public boolean isPivotCell(int threshold)
  {
    return _access.size() >= threshold;
  }

  public ArrayList<Integer> getAccess()
  {
    return _access;
  }

  public void setAccess(int[] directions)
  {
    for(int i = 0; i < _access.size(); i++)
      _access.remove(i);

    for(int i = 0; i < directions.length; i++)
      _access.add(directions[i]);
  }

  public int provideAccess(int denyAccess)
  {
    ArrayList<Integer> allowedAccess = new ArrayList<Integer>();
    for(Integer _a : _access)
      if(_a != denyAccess)
        allowedAccess.add(_a);

    if(allowedAccess.size() > 0){
      return rand.krandom(allowedAccess);
    }else{
      return 0;
    }
  }

  public int provideShortestAccessTo(Hero hero, Board board, int denyAccess)
  {
    ArrayList<Cell> cellsAround = board.getCellsAround(this, denyAccess);
    float[] distCellsHero = new float[cellsAround.size()];

    int i = 0;
    for(Cell cellA : cellsAround)
    {
      PVector cellAPos = cellA.getPos("center");
      float distCH = dist(cellAPos.x, cellAPos.y, hero.getScreenPos().x, hero.getScreenPos().y);

      distCellsHero[i] = distCH;
      i++;
    }

    ArrayList<Integer> allowedAccess = new ArrayList<Integer>();
    for(Integer _a : _access)
      if(_a != denyAccess)
        allowedAccess.add(_a);

    if(distCellsHero.length > 0){
      float minDistCH = min(distCellsHero);
  
      for(int j = 0; j < distCellsHero.length; j++) {
        if(distCellsHero[j] == minDistCH)
          return allowedAccess.get(j);
      }
    }
    return 0;
  }

  public int provideLongestAccessTo(Hero hero, Board board, int denyAccess)
  {
    ArrayList<Cell> cellsAround = board.getCellsAround(this, denyAccess);
    float[] distCellsHero = new float[cellsAround.size()];

    int i = 0;
    for(Cell cellA : cellsAround)
    {
      PVector cellAPos = cellA.getPos("center");
      float distCH = dist(cellAPos.x, cellAPos.y, hero.getScreenPos().x, hero.getScreenPos().y);

      distCellsHero[i] = distCH;
      i++;
    }

    ArrayList<Integer> allowedAccess = new ArrayList<Integer>();
    for(Integer _a : _access)
      if(_a != denyAccess)
        allowedAccess.add(_a);

    if(distCellsHero.length > 0){
      float maxDistCH = max(distCellsHero);
  
      for(int j = 0; j < distCellsHero.length; j++) {
        if(distCellsHero[j] == maxDistCH)
          return allowedAccess.get(j);
      }
    }
    return 0;
  }

  public TypeCell getType()
  {
    return _type;
  }
  public void setType(TypeCell type)
  {
    _type = type;
  }

  public boolean isPointInside(PVector pt)
  {
    boolean isXInside = pt.x >= _screenPos.x && pt.x <= _screenPos.x + _cellSize;
    boolean isYInside = pt.y >= _screenPos.y && pt.y <= _screenPos.y + _cellSize;
    return isXInside && isYInside;
  }

  public boolean isGhostCell(Board board)
  {
    for(Cell ghostCell : board.getGhostsCells())
      if(ghostCell == this)
        return true;
    return false;
  }
}
