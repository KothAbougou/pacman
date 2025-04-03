enum PageMenu
{
  HOME, BEST_SCORES, SAVES_LEVELS, CHANGE_USERS;
}

class Menu
{
  private Game                _game;
  private PageMenu            _page;
  private KBoard              _template;
  private ArrayList<KElement> _elements;
  private Levels              _levels;
  private Scores              _scores;

  Menu(Game game)
  {
    _game     = game;
    _scores   = _game.getScores();
    _levels   = new Levels();
    _page     = PageMenu.HOME;
    _template = new KBoard(2,2,287);
    _template.setOffset(0, 50);

    _loadElementsIntoPage();
  }

  private void _loadElementsIntoPage()
  {
    ArrayList<KElement> containers = _template.getCellsList();
    ArrayList<KElement> elements = new ArrayList<KElement>();
    KElement ke = new KElement();

    switch(_page)
    {
      case HOME:
        ke = new Button(BtnEvent.RESTART);      elements.add(ke);
        ke = new Button(BtnEvent.SAVE);         elements.add(ke);
        ke = new Button(BtnEvent.SAVES_LEVELS); elements.add(ke);
        ke = new Button(BtnEvent.HIGHT_SCORE);  elements.add(ke);
        ke = new Button(BtnEvent.EXIT_GAME);    elements.add(ke);
        ke = new Button(BtnEvent.USERS);        elements.add(ke);
        ke = new KElement();                    elements.add(ke);

        _elements = elements;

        int i=0;
        for(KElement container : containers)
        {
          Button button = (Button) _elements.get(i);
          container.addChild(button);
          button.setKeTextColor(PURPLE);
          button.setKeBackgroundColor(YELLOW);
          button.setKeTextSize(28);

          if(container == containers.get(0))
          {
            PVector cPos = container.getKePosition("screen");

            KElement notifBar = _elements.get(6);
            container.addChild(notifBar);
            notifBar.setKeTextColor(WHITE);
            notifBar.setKeBackgroundColor(BLACK);
            notifBar.setKeHeight(50);
            notifBar.setKeWidth(2 * container.getKeWidth());
            notifBar.setKePosition("screen", cPos.x, cPos.y - 2.5 * notifBar.getKeHeight());
            notifBar.setKeTextSize(28);
            if(!_game.getNotif().equals("")) notifBar.setKeText(_game.getNotif());

            Button buttonUsers = (Button) _elements.get(5);
            container.addChild(buttonUsers);
            buttonUsers.setKeTextColor(WHITE);
            buttonUsers.setKeBackgroundColor(BLUE);
            buttonUsers.setKeTextSize(28);
            buttonUsers.setKeHeight(50);
            buttonUsers.setKePosition("screen", cPos.x, cPos.y - buttonUsers.getKeHeight());
            if(!_game.getUser().equals("")) buttonUsers.setKeText(_game.getUser());
          }

          if(container == containers.get(2))
          {
            PVector cPos = container.getKePosition("screen");

            Button buttonExit = (Button) _elements.get(4);
            container.addChild(buttonExit);
            buttonExit.setKeTextColor(WHITE);
            buttonExit.setKeBackgroundColor(RED);
            buttonExit.setKeTextSize(28);
            buttonExit.setKeHeight(50);
            buttonExit.setKePosition("screen", cPos.x, cPos.y - buttonExit.getKeHeight());
          }

          i++;
        }

        break;

      case SAVES_LEVELS:
        ke = new Button(BtnEvent.HOME); elements.add(ke);
        ke = new KElement();            elements.add(ke);

        _elements = elements;

        for(KElement container : containers)
        {
          if(container == containers.get(0))
          {
            Button buttonMenu = (Button) _elements.get(0);
            container.addChild(buttonMenu);
            buttonMenu.setKeTextColor(PURPLE);
            buttonMenu.setKeBackgroundColor(YELLOW);
            buttonMenu.setKeTextSize(28);
          }

          if(container == containers.get(3))
          {
            PVector container2Pos = containers.get(2).getKePosition("screen");

            KElement levelsBar = _elements.get(1);
            container.addChild(levelsBar);
            levelsBar.setKePosition("screen", container2Pos.x, container2Pos.y);
            levelsBar.setKeTextColor(PURPLE);
            levelsBar.setKeBackgroundColor(YELLOW);
            levelsBar.setKeHeight(2 * container.getKeHeight());


            ArrayList<KElement> levelButtons = new ArrayList<KElement>();

            for(Level level : _levels.getAllLevels()){
              ke = new Button(BtnEvent.LEVEL, level.getName()); 
              levelButtons.add(ke); 
              elements.add(ke);
            }
            
            int j = 0;
            for(KElement lvButton : levelButtons)
            {
              Button b = (Button) lvButton;
              levelsBar.addChild(b);
              b.setKeBackgroundColor(PURPLE);
              b.setKeTextColor(WHITE);
              b.setKeTextSize(28);
              b.setKeHeight(35);
              b.setKePosition("screen", levelsBar.getKePosition("screen").x , levelsBar.getKePosition("screen").y+j*b.getKeHeight());
              j++;
            }

          }
        }

        break;

        case CHANGE_USERS:
        ke = new Button(BtnEvent.HOME); elements.add(ke);
        ke = new KElement();            elements.add(ke);

        _elements = elements;

        for(KElement container : containers)
        {
          if(container == containers.get(0))
          {
            Button buttonMenu = (Button) _elements.get(0);
            container.addChild(buttonMenu);
            buttonMenu.setKeTextColor(PURPLE);
            buttonMenu.setKeBackgroundColor(YELLOW);
            buttonMenu.setKeTextSize(28);
          }

          if(container == containers.get(3))
          {
            PVector container2Pos = containers.get(2).getKePosition("screen");

            KElement levelsBar = _elements.get(1);
            container.addChild(levelsBar);
            levelsBar.setKePosition("screen", container2Pos.x, container2Pos.y);
            levelsBar.setKeTextColor(PURPLE);
            levelsBar.setKeBackgroundColor(YELLOW);
            levelsBar.setKeHeight(2 * container.getKeHeight());


            ArrayList<KElement> usersButtons = new ArrayList<KElement>();

            for(String username : _game.getUsers()){
              ke = new Button(BtnEvent.USER, username); 
              usersButtons.add(ke); 
              elements.add(ke);
            }
            
            int j = 0;
            for(KElement userButton : usersButtons)
            {
              Button b = (Button) userButton;
              levelsBar.addChild(b);
              b.setKeBackgroundColor(PURPLE);
              b.setKeTextColor(WHITE);
              b.setKeTextSize(28);
              b.setKeHeight(35);
              b.setKePosition("screen", levelsBar.getKePosition("screen").x , levelsBar.getKePosition("screen").y+j*b.getKeHeight());
              j++;
            }

          }
        }

        break;

      case BEST_SCORES:
        ke = new Button(BtnEvent.HOME); elements.add(ke);
        ke = new KElement();            elements.add(ke);

        _elements = elements;

        for(KElement container : containers)
        {
          if(container == containers.get(0))
          {
            Button buttonMenu = (Button) _elements.get(0);
            container.addChild(buttonMenu);
            buttonMenu.setKeTextColor(PURPLE);
            buttonMenu.setKeBackgroundColor(YELLOW);
            buttonMenu.setKeTextSize(28);
          }

          if(container == containers.get(3))
          {
            PVector container2Pos = containers.get(2).getKePosition("screen");

            KElement scoresBar = _elements.get(1);
            container.addChild(scoresBar);
            scoresBar.setKePosition("screen", container2Pos.x, container2Pos.y);
            scoresBar.setKeTextColor(PURPLE);
            scoresBar.setKeBackgroundColor(YELLOW);
            scoresBar.setKeHeight(2 * container.getKeHeight());

            int j=0;
            for(Score score : _scores.getScores()){
              String su = score.getUsername();
              String spt = " "+str(score.getPoints())+" pts ";
              String st;
              if(score.getType().equals("V")) st = "(Victoire)"; else st = "(Défaite)";

              ke = new KElement(); 
              scoresBar.addChild(ke); 
              ke.setKeBackgroundColor(PURPLE);
              ke.setKeTextColor(WHITE);
              ke.setKeTextSize(18);
              ke.setKeHeight(25);
              ke.setKeText(su+spt+st);
              ke.setKePosition("screen", scoresBar.getKePosition("screen").x , scoresBar.getKePosition("screen").y+j*ke.getKeHeight());
              j++;
            }
          }
        }
        break;

    }
  }

  private void _clearPagesElements()
  {
    for(KElement container : _template.getCellsList())
      container.removeAllChildren();
  }

  public void changePage(PageMenu page)
  { 
    _clearPagesElements();
    _page = page;
    _loadElementsIntoPage();
  }

  public BtnEvent getBtnEventOnClick()
  {
    for(KElement _button : _elements)
      if(_button instanceof Button)
      {
        Button button = (Button) _button;

        if(button.isClicked() && button.getBtnEvent() == BtnEvent.LEVEL)
          _game.changeLevelGame(button.getValue());

        if(button.isClicked() && button.getBtnEvent() == BtnEvent.USER)
          _game.selectUser(button.getValue());

        if(button.isClicked())
          return button.getBtnEvent();
        
      }
    
    return BtnEvent.DEFAULT;
  }
  
  public void drawing()
  {
    KElement[][] containers = _template.getCells();

    for(int x = 0; x < _template.getNbCol(); x++)
      for(int y = 0; y < _template.getNbRow(); y++)
      {
        KElement container = containers[x][y];
        container.drawing();
      }
  }
}
