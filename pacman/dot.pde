
class Dot
{
	protected PVector _pos;
	protected int 		_size;
	protected int 		_value;
	protected color 	_color;
	protected boolean _active;

	Dot(PVector pos)
	{	
		_pos 		= pos;
		_size 	= 4;
		_value 	= SCORE_DOT;
		_color 	= YELLOW;
		_active = true;
	}

	public void drawing()
	{
		noStroke();
		fill(_color);
		circle(_pos.x, _pos.y, _size);
	}

	public int getValue()
	{
		return _value;
	}

	public boolean isActive()
	{
		return _active;
	}

	public void setActive(boolean b)
	{
		_active = b;
	}

	public boolean isEatenBy(Hero hero)
	{
		PVector heroPos = hero.getScreenPos();

		boolean isEaten = false;
		switch(hero.getDirection("current"))
		{
			case UP:    isEaten = _pos.x == heroPos.x && dist(0, _pos.y, 0, heroPos.y) < CELL_SIZE/2.5; break;
			case DOWN:  isEaten = _pos.x == heroPos.x && dist(0, _pos.y, 0, heroPos.y) < CELL_SIZE/2.5; break;
			case LEFT:  isEaten = _pos.y == heroPos.y && dist(_pos.x, 0, heroPos.x, 0) < CELL_SIZE/2.5; break;
			case RIGHT: isEaten = _pos.y == heroPos.y && dist(_pos.x, 0, heroPos.x, 0) < CELL_SIZE/2.5; break;
		}

		return isEaten;
	}
}

class SuperDot extends Dot
{
	SuperDot(PVector pos)
	{
		super(pos);
		_size  = _size * 3;
		_value = SCORE_SUPER_DOT;
	}

}