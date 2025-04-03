enum TypeGhost
{
	RED(#ff0000), 
	PINK(#ffc0cb), 
	ORANGE(#ff7f00), 
	GREEN(#00ff00), 
	PURPLE(#7f00ff);

	private final color _color;

	TypeGhost(color c)
	{
		_color = c;
	}

	public color getColor()
	{
		return _color;
	}

	public static TypeGhost generate(int id)
	{
		TypeGhost type;
		switch(id)
		{
			case 1: type = TypeGhost.RED; 		break;
			case 2: type = TypeGhost.PINK; 		break;
			case 3: type = TypeGhost.ORANGE; 	break;
			case 4: type = TypeGhost.GREEN; 	break;
			case 5: type = TypeGhost.PURPLE; 	break;
			default: type = TypeGhost.RED; 		break;
		}

		return type;
	}
}
enum GhostMoveMode
{
	HUNTING(1), DISPERSAL(1), SCARED(0.5);

	private final float _speed;

	GhostMoveMode(float speed)
	{
		_speed = speed;
	}

	public float getSpeed()
	{
		return _speed;
	}
}
class Ghost extends Pawn
{
	private TypeGhost 		_type;
	private GhostMoveMode _moveMode;
	private float 				_speed;
	private color 				_color;
	private boolean       _alive;

	Ghost(TypeGhost type, Board board)
	{
		super(board);
		_type  		     = type;
		_moveMode      = GhostMoveMode.DISPERSAL;
		_speed 		     = _moveMode.getSpeed();
		_color 				 = _type.getColor();
		_alive				 = false;
	}

	public void putOnCell(Cell cell)
	{
		_cell = cell;
		_screenPos = new PVector(_cell.getPos("center").x, _cell.getPos("center").y);
	  _boardPos  = new PVector(_cell.getPos("board").x, _cell.getPos("board").y);

	  _nextCellAssociation(_direction);
	}

	public void generateNextDirection(Hero hero)
	{
		int nextDirection = 0;

		switch(_moveMode)
		{
			case HUNTING: nextDirection = _cell.provideShortestAccessTo(hero, _board, reverseDirection()); break;
			case  SCARED: nextDirection = _cell.provideLongestAccessTo(hero, _board, 0); break;

			default:
				PVector _nextCellPos = _nextCell.getPos("center");
				float distGhostNextCell = dist(_screenPos.x, _screenPos.y, _nextCellPos.x, _nextCellPos.y);

				if(distGhostNextCell < _board.getCellSize())
					nextDirection = _nextCell.provideAccess(reverseDirection());
				break;
		}

		switch(nextDirection)
		{
			case 0: _nextDirection = _nextDirection; break;
			default: _nextDirection = nextDirection; break;
		}
	}

  public PVector getLastBoardPos()
  {
  	return _lastBoardPos;
  }

  public boolean isInCollisionWith(Hero hero)
  {
  	return _cell == hero.getCell();
  }

  public boolean isInsideHeroZone(Hero hero)
  {
  	PVector hPos = hero.getScreenPos();
		float distGhostHero = dist(_screenPos.x, _screenPos.y, hPos.x, hPos.y);

    return distGhostHero < hero.getZone()
    			 && _cell.isPivotCell()
           && _cell.getType() != TypeCell.EMPTY
           && _cell.getType() != TypeCell.GHOST;
  }

  public void setMoveMode(GhostMoveMode moveMode)
  {
  	_moveMode = moveMode;
  	_speed = _moveMode.getSpeed();
  	//println("speed:",_speed);

  	switch(_moveMode)
  	{
  		case SCARED: _color = BLUE;  						break;
  		    default: _color = _type.getColor(); break;
  	}
  }

  public void setColor(color c)
  {
  	_color = c;
  }

  public color getColor()
  {
  	return _color;
  }

  public TypeGhost getType()
  {
  	return _type;
  }

  public void move(int direction)
  {
  	super.move(direction);

  	if(isMoving("onScreen") && _cell.isGhostCell(_board))
  		_alive = false;
  	else
  		_alive = true;

  }

  public boolean isAlive()
  {
  	return _alive;
  }

  public void setAlive(boolean b)
  {
  	_alive = b;
  }

  public void drawing()
  {
  	noStroke();
  	fill(_color);
  	circle(_screenPos.x, _screenPos.y, _board.getCellSize()+10);
  }
}