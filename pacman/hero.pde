class Hero extends Pawn
{
  private int _lives;
  private int _score;

  Hero(Board board)
  {
    super(board);

    putOnStartingCell();

    _lives = 2;
    _score = 0;
  }

  public void putOnStartingCell()
  {
    _cell          = _board.getPacmanCell();
    _screenPos     = new PVector(_cell.getPos("center").x, _cell.getPos("center").y);
    _boardPos      = new PVector(_cell.getPos("board").x, _cell.getPos("board").y); 
    _direction     = LEFT;

    _nextCellAssociation(_direction);
  }

  public void addScore(int value)
  {
    _score += value;
  }

  public int getScore()
  {
    return _score;
  }

  public float getZone()
  {
    return _board.getCellSize() * _board.getNbCol() / 3;
  }

  public int getLives()
  {
    return _lives;
  }

  public void losesOneLife()
  {
    _lives --;
  }

  public void drawing()
  {
    noStroke();
    fill(YELLOW);
    circle(_screenPos.x, _screenPos.y, CELL_SIZE);
  }
}
