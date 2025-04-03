enum BtnEvent
{
	DEFAULT("noValue"), 
	HOME("Retourner au\nmenu principal."),
	USERS("Username?"),
	USER("user button"),
	RESTART("Recommencer\nla partie."), 
	SAVE("Sauvegarder\ncette partie."), 
	SAVES_LEVELS("Liste des parties\nsauvegardées."), 
	HIGHT_SCORE("Meilleurs scores"), 
	LEVEL("level button"),
	EXIT_GAME("Quitter le jeu.");


	private String _value;

	BtnEvent(String value)
	{
		_value = value;
	}

	public String getValue()
	{
		return _value;
	}

}

class Button extends KElement
{
	private BtnEvent _buttonEvent;

	Button(BtnEvent buttonEvent)
	{
		this(buttonEvent, "");
	}

	Button(BtnEvent buttonEvent, String value)
	{
		_buttonEvent = buttonEvent;

		if(!value.equals("")) setKeText(value);
		else setKeText(_buttonEvent.getValue());

		setKeWidth(150);
		setKeHeight(50);
		setKeTextColor(WHITE);
		setKeBackgroundColor(BLACK);
	}

	Button(BtnEvent buttonEvent, String message, PVector pos, float w, float h)
	{
		this(buttonEvent, message);
		setKePosition("screen", pos.x, pos.y);
		setKeWidth(w);
		setKeHeight(h);
		setKeTextSize(int(h));
		setKeTextColor(WHITE);
		setKeBackgroundColor(BLACK);
	}

	Button(BtnEvent buttonEvent, String message, PVector pos, float w, float h, int textSize)
	{
		this(buttonEvent, message, pos, w, h);
		setKeTextSize(textSize);
	}

	Button(){ _buttonEvent = BtnEvent.DEFAULT; }

	public void setPosition(PVector pos)
	{
		setKePosition("screen", pos.x, pos.y);
	}

	public boolean isClicked()
	{
		return mouseX >= _ke_screenPos.x && mouseX <= _ke_screenPos.x + _ke_width
			&& mouseY >= _ke_screenPos.y && mouseY <= _ke_screenPos.y + _ke_height;
	}

	public BtnEvent getBtnEvent()
	{
		return _buttonEvent;
	}

	public String getValue()
	{
		return _ke_text;
	}



}