class KBoard
{
	private KElement[][] _containers;
  protected PVector  _position;
  protected int      _nbCol;
  protected int      _nbRow;
  protected int      _cellSize;

	KBoard(int nbCol, int nbRow, int cellSize)
	{
		_nbCol    = nbCol;
    _nbRow    = nbRow;
    _cellSize = cellSize;

    _initPosition();

    if(getClass().getSimpleName().equals("KBoard"))
   		_initContainers();
	}

	private void _initContainers()
	{
		_containers = new KElement[_nbCol][_nbCol];

		for(int x = 0; x < _nbCol; x++)
			for(int y = 0; y < _nbRow; y++)
			{
				KCell container = new KCell(new PVector(x, y), _cellSize);
				container.setKeBackgroundColor(BLACK);
				container.setKePosition("offset", _position.x, _position.y);
				_containers[x][y] = container;
			}
	}

	private void _initPosition()
  {
    float boardW = _nbCol * _cellSize,
          boardH = _nbRow * _cellSize,
          boardMgX = (width - boardW)/2,
          boardMgY = (height - boardH)/2;

    _position = new PVector(boardMgX, boardMgY);
  }

  public void setOffset(float x, float y)
  {
  	_position.x += x;
  	_position.y += y;

  	if(getClass().getSimpleName().equals("KBoard"))
   		_initContainers();
  }

  public int getNbRow()
  {
    return _nbRow;
  }

  public int getNbCol()
  {
    return _nbCol;
  }

  public int getCellSize()
  {
    return _cellSize;
  }

  public KElement[][] getCells()
  {
    return _containers;
  }

  public ArrayList<KElement> getCellsList()
  {
  	ArrayList<KElement> cellsList = new ArrayList<KElement>();

  	for(int x = 0; x < _nbCol; x++)
  		for(int y = 0; y < _nbRow; y++)
  		{
  			cellsList.add(_containers[x][y]);
  		}

  	return cellsList;
  }
}