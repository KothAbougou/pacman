class KCell extends KElement
{
	protected PVector  _boardPos, _margin, _screenPos, _centerPos;
  protected color    _color;
  protected int      _cellSize;

  KCell(PVector boardPos, int cellSize)
  {
    _boardPos  = boardPos;
    _margin    = PVECTOR_00;
    _screenPos = _ke_screenPos;
    _centerPos = _ke_centerPos;
    _cellSize  = cellSize;

    setKeWidth(_cellSize);
    setKeHeight(_cellSize);
    setKeStrokeColor(BLACK);
    setKeStrokeWeight(3);

    _updateScreenPos();
    _updateCellCenterPos();
  }

  KCell(){}

  protected void _updateScreenPos()
  {
    float screenPosX = _boardPos.x * _cellSize + _margin.x,
          screenPosY = _boardPos.y * _cellSize + _margin.y;

    _screenPos.x = screenPosX;
    _screenPos.y = screenPosY;
  }

  protected void _updateCellCenterPos()
  {
    float centerPosX = _screenPos.x + _cellSize/2,
          centerPosY = _screenPos.y + _cellSize/2;

    _centerPos.x = centerPosX;
    _centerPos.y = centerPosY;
  }

  public PVector getPos(String from)
  {
    PVector pos;
    switch(from)
    {
      case "board":  pos = _boardPos;  break;
      case "center": pos = _centerPos; break;
      case "screen": pos = _screenPos; break;
      default:       pos = _boardPos;  break;
    }

    return pos;
  }

  public void setColor(color c)
  {
    _color = c;
    setKeBackgroundColor(_color);
  }

  public color getColor()
  {
    return _color;
  }

  public void setMargin(PVector margin)
  {
    _margin = margin;

    _updateScreenPos();
    _updateCellCenterPos();
    //setKePosition("offset", margin.x, margin.y);
  }

  //public void drawing()
  //{
  //  fill(_color);
  //  rect(_screenPos.x, _screenPos.y, _cellSize, _cellSize);
  //}
}