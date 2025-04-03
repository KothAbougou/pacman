class KElement
{
	protected KElement _ke_parent;
	protected ArrayList<KElement> _ke_children = new ArrayList<KElement>();

	protected PVector 	_ke_screenPos 		= new PVector(0,0);
	protected PVector 	_ke_centerPos			= new PVector(0,0);
	protected PVector 	_ke_offset        = new PVector(0,0);
	protected float 		_ke_width 				= 0;
	protected float 		_ke_height				= 0;

	protected int 			_ke_strokeWeight  = 0;
	protected color  		_ke_strokeColor   = #000000;
	protected color 		_ke_bgColor       = #ffffff;
	protected int 			_ke_textAlignX		= CENTER;
	protected int  			_ke_textAlignY 		= CENTER;

	//protected boolean 	_ke_border				= true;
	//protected int 			_ke_borderWeight  = 2;
	//protected color    	_ke_borderColor		= #000000;
	//protected float     _ke_borderOffset  = -5;

	protected String 		_ke_text          = "";
	protected int 			_ke_textSize      = 16;
	protected color   	_ke_textColor     = #000000;


	KElement()
	{
		_updateKeCenterPos();
	}

	public void drawing()
	{
		float x = _ke_screenPos.x,
					y = _ke_screenPos.y;

		stroke(_ke_strokeColor);
		strokeWeight(_ke_strokeWeight);

		fill(_ke_bgColor);
		rect(x, y, _ke_width, _ke_height);

		if(!_ke_text.equals(""))
		{
			fill(_ke_textColor);
			textSize(_ke_textSize);
			textAlign(_ke_textAlignX, _ke_textAlignY);
			text(_ke_text, _ke_centerPos.x, _ke_centerPos.y);
		}

		if(_ke_children.size() > 0)
			for(KElement kec : _ke_children)
				kec.drawing();

	}

	protected void _updateKeCenterPos()
  {
    float centerPosX = _ke_screenPos.x + _ke_width/2,
          centerPosY = _ke_screenPos.y + _ke_height/2;

    _ke_centerPos = new PVector(centerPosX, centerPosY);
  }

  public int getKeStrokeWeight()
  {
  	return _ke_strokeWeight;
  }
  public void setKeStrokeWeight(int keStrokeWeight)
  {
  	_ke_strokeWeight = keStrokeWeight;
  }

  public color getKeStrokeColor()
  {
  	return _ke_strokeColor;
  }
  public void setKeStrokeColor(color keStrokeColor)
  {
  	_ke_strokeColor = keStrokeColor;
  }

  public color getKeBackgroundColor()
  {
  	return _ke_bgColor;
  }
  public void setKeBackgroundColor(color keBgColor)
  {
  	_ke_bgColor = keBgColor;
  }

  public String getKeText()
  {
  	return _ke_text;
  }
  public void setKeText(String keText)
  {
  	_ke_text = keText;
  }

  public int getKeTextSize()
  {
  	return _ke_textSize;
  }
  public void setKeTextSize(int keTextSize)
  {
  	_ke_textSize = keTextSize;
  }

  public color getKeTextColor()
  {
  	return _ke_textColor;
  }
  public void setKeTextColor(color keTextColor)
  {
  	_ke_textColor = keTextColor;
  }

  public void setKeTextAlign(int keTextAlignX, int keTextAlignY)
  {
  	_ke_textAlignX = keTextAlignX;
  	_ke_textAlignY = keTextAlignY;
  }

  public float getKeWidth()
  {
  	return _ke_width;
  }
  public void setKeWidth(float keWidth)
  {
  	_ke_width = keWidth;
  	_updateKeCenterPos();
  }

  public float getKeHeight()
  {
  	return _ke_height;
  }
  public void setKeHeight(float keHeight)
  {
  	_ke_height = keHeight;
  	_updateKeCenterPos();
  }

  public PVector getKePosition(String from)
  {
    PVector pos;
    switch(from)
    {
      case "screen": pos = _ke_screenPos; break;
      case "center": pos = _ke_centerPos; break;
      default: pos = _ke_screenPos; break;
    }

    return pos;
  }
  public void setKePosition(String about, float x, float y)
  {
  	switch(about)
  	{
  		case "screen": 
  			_ke_screenPos.x = x; 
  			_ke_screenPos.y = y; 
  		break;
  		case "offset":
  			_ke_screenPos.x += x; _ke_offset.x += x;
  			_ke_screenPos.y += y; _ke_offset.y += y;
  		break;
  		default: setKePosition("screen", x, y); break;
  	}

  	_updateKeCenterPos();
  }

	public KElement getParent()
	{
		return _ke_parent;
	}

	public void removeParent(KElement keParent)
	{
		_ke_parent = null;
		keParent.removeChild(this);
	}

	private void _putParent(KElement keParent)
	{
		_ke_parent = keParent;
		keParent.getChildren().add(this);
	}

	public ArrayList<KElement> getChildren()
	{
		return _ke_children;
	}

	public void addChild(KElement keChild, String option)
	{
		if(keChild.getParent() == null)
		{ 
			keChild._putParent(this);

			switch(option)
			{
				default:
					keChild.setKePosition("screen", _ke_screenPos.x, _ke_screenPos.y);
					keChild.setKeWidth(_ke_width);
					keChild.setKeHeight(_ke_height);
					keChild.setKeStrokeWeight(_ke_strokeWeight);
					keChild.setKeStrokeColor(_ke_strokeColor);
					keChild.setKeTextSize(_ke_textSize);
					keChild.setKeTextColor(_ke_textColor);
					keChild.setKeTextAlign(_ke_textAlignX, _ke_textAlignY);
					break;

				case "noStyleInherit": break;
			}
		}
	}

	public void addChild(KElement keChild)
	{
		addChild(keChild, "");
	}

	public void removeChild(KElement keChild)
	{
		ArrayList<KElement> keChildren = new ArrayList<KElement>();

		for(KElement kec : _ke_children)
			if(kec != keChild)
				keChildren.add(kec);

		_ke_children = keChildren;
	}
	public void removeChild(int iKeChild)
	{
		ArrayList<KElement> keChildren = new ArrayList<KElement>();

		int i=0;
		for(KElement kec : _ke_children)
		{
			if(i != iKeChild)
				keChildren.add(kec);
			i++;
		}

		_ke_children = keChildren;

	}

	public void removeAllChildren()
	{
		for(KElement kec : _ke_children)
			if(_ke_children.size() > 0)
				kec.removeParent(this);
	}
}