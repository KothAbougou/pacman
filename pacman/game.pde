enum StateGame
{
  PLAY, MENU;
}

enum MoodGame
{
  DEFAULT(0), SCARED(0);

  private int _nbGhostKilled;
  public final float SCARED_PERIOD;

  MoodGame(int nb)
  {
    _nbGhostKilled = nb;
    SCARED_PERIOD = 15; // 15 secondes
  }

  public void otherGhostKilled()
  {
    _nbGhostKilled ++;
  }

  public int getNbGhostKilled()
  {
    return _nbGhostKilled;
  }
}
class Game 
{
  private Levels    _levels;
  private Level     _level;
  private StateGame _state;
  private Menu      _menu;
  private String[]  _users;
  private String    _user; 
  private String    _notif;     
  private Scores    _scores;  

  private MoodGame _mood;
  private Board    _board;
  private Hero     _hero;
  private ArrayList<Ghost> _ghosts;
  private ArrayList<Dot>   _dots;
  
  
  Game(String levelName) {
    _user = "";
    _notif = "";
    _scores = new Scores();
    _levels = new Levels();
    _level  = _levels.getLevel(levelName);
    _board  = new Board(_level, CELL_SIZE);
    _menu   = new Menu(this);

    println("pacmanByKoth >> Ouverture du jeu.");

    _startGame();

  }

  public void run()
  {
    _updates();
    _views();
  }
  
  private void _updates() 
  {
    switch(_state)
    {
      case PLAY:
        _updateGame();
        _updateBoard();
        _updateDots();
        _updateHero();
        _updateGhosts();
        break;
    }
  }
  private void _views() 
  {
    switch(_state)
    { 
      case PLAY:
        _sidebarsView();
        _boardView();
        _dotsView();
        _heroView();
        _ghostsView();
        break;

      case MENU:
        _menuView();
        break;
    }
  }

  ////////////////////////////
  //         GAME           //
  ////////////////////////////
  
  private void _updateGame()
  {
    _updateGameWin();
    _updateGameMood();
  }

  private void _updateGameWin()
  {
    int nbDotActive = 0;

    for(Dot _dot : _dots)
      if(_dot.isActive())
        nbDotActive ++;

    if(nbDotActive == 0)
    {
      _notif ="Victoire avec" + _hero.getScore() + " points!";
      _menu.changePage(PageMenu.HOME);
      changeStateGameTo(StateGame.MENU);

      if(_user.equals("")) println("pacmanByKoth >>", _notif);
      else println("pacmanByKoth >>", _notif, "de", _user);

      if(!_user.equals(""))
       _scores.addScore(";"+_user+"|V|"+_hero.getScore());

    }
  }
  public boolean stateGameIs(StateGame state)
  {
    return _state == state;
  }
  public void changeStateGameTo(StateGame state)
  {
    _state = state;
  }

  private void _updateGameMood()
  {
    if(_mood == MoodGame.SCARED && timer.getTime() <= _mood.SCARED_PERIOD)
    {
      timer.countUp();

      if(timer.getTime() >= _mood.SCARED_PERIOD - 2)
        _board.endScaredModeAlert(timer);
    }else{
      _mood = MoodGame.DEFAULT;
      _board.setAlert(false);
      timer.setTime(0);
    }
  }

  private void _startGame()
  {
    changeStateGameTo(StateGame.PLAY);
    _mood   = MoodGame.DEFAULT;
    _hero   = new Hero(_board);
    _ghosts = _initGhosts();
    _dots   = _initDots();

    if(_user.equals(""))
      println("pacmanByKoth >> Lancement du level --", _level.getName(),"--");
    else 
      println("pacmanByKoth >> Lancement du level --", _level.getName(), "-- avec", _user);
  }

  public void changeLevelGame(String levelName)
  {
    _level = _levels.getLevel(levelName);
    _board  = new Board(_level, CELL_SIZE);
  }

  private void _resetGame()
  {
    _mood = MoodGame.DEFAULT;
    _resetHero();
    _resetGhosts();
  }

  private void _endGame()
  {
    _notif = "Défaite avec " + _hero.getScore() + " points.";
    _menu.changePage(PageMenu.HOME);
    changeStateGameTo(StateGame.MENU);

    if(_user.equals("")) println("pacmanByKoth >>", _notif);
    else println("pacmanByKoth >>", _notif, "de", _user);

    if(!_user.equals(""))
      _scores.addScore(";"+_user+"|D|"+_hero.getScore());

  }

  private void _exitGame()
  {
    println("pacmanByKoth >> Vous avez quitté le jeu.");
    exit();
  }

  public void users(String users)
  {
    _users = split(users, ";");
  }

  public void selectUser(String user)
  {
    _user = user;
  }

  public String getUser()
  {
    return _user;
  }

  public String[] getUsers()
  {
    return _users;
  }

  public String getNotif()
  {
    return _notif;
  }

  public Scores getScores()
  {
    return _scores;
  }

  ////////////////////////////
  //         Menu           //
  ////////////////////////////
  
  private void _menuView()
  {
    _menu.drawing();
  }

  public void onMenuButtonClickEvent()
  {
    switch(_menu.getBtnEventOnClick())
    {
      case EXIT_GAME:     _exitGame();                              break;
      case RESTART:       _startGame(); frameRate(200);             break;
      case LEVEL:         _startGame(); frameRate(200);             break;
      case HOME:          _menu.changePage(PageMenu.HOME);          break;
      case USERS:         _menu.changePage(PageMenu.CHANGE_USERS);  break;
      case USER:          _menu.changePage(PageMenu.HOME);          break;
      case SAVES_LEVELS:  _menu.changePage(PageMenu.SAVES_LEVELS);  break;
      case HIGHT_SCORE:   _menu.changePage(PageMenu.BEST_SCORES);   break;
    }
  }

  ////////////////////////////
  //         SIDEBAR        //
  ////////////////////////////
  
  private void _sidebarsView()
  {
    _topbarView();
    _bottombarView();
  }

  private void _topbarView()
  {
    fill(WHITE);
    textSize(28);
    text("HIGHT SCORE: "+ _hero.getScore(), width/4, 50);
  }

  private void _bottombarView()
  {
    fill(WHITE);
    textSize(28);
    text("VIES: "+ _hero.getLives(), width/4, height - 50);
  }

  ////////////////////////////
  //         BOARD          //
  ////////////////////////////
  private void _boardView()
  {
    _board.drawing();
  }

  private void _updateBoard()
  {
    _updateBoardByGameMood();
  }

  private void _updateBoardByGameMood()
  {
    switch(_mood)
    {
      case SCARED: 
        if(!_board.isAlerting()) _board.setColor(PURPLE); 
        break;

      default: _board.setColor(BLUE);  break;
    }
  }

  ////////////////////////////
  //         DOTS           //
  ////////////////////////////
  
  private ArrayList<Dot> _initDots()
  {
    ArrayList<Dot> dots = new ArrayList<Dot>();
    Cell[][] cells = _board.getCells();

    for(int x = 0; x < _board.getNbCol(); x++)
      for(int y = 0; y < _board.getNbRow(); y++)
      {
        Cell c = cells[x][y];

        if(c.getType() == TypeCell.DOT || c.getType() == TypeCell.SUPER_DOT)
        {
          Dot dot = new Dot(new PVector(0,0));
          switch(c.getType())
          {
            case DOT: dot = new Dot(c.getPos("center")); break;
            case SUPER_DOT: dot = new SuperDot(c.getPos("center")); break;
          }

          dots.add(dot);
        }

      }
      
    return dots;
  }
  
  private void _dotsView()
  {
    for(Dot _dot : _dots)
      if(_dot.isActive())
        _dot.drawing();
  }

  private void _updateDots()
  {
    _updateDotsWhenEatenByHero();
  }

  private void _updateDotsWhenEatenByHero()
  {
    for(Dot _dot : _dots)
      if(_dot.isActive() && _dot.isEatenBy(_hero))
      {
        if(_dot instanceof SuperDot)
          _mood = MoodGame.SCARED;

        _hero.addScore(_dot.getValue());
        _dot.setActive(false);
      }
  }

  ////////////////////////////
  //         HERO           //
  ////////////////////////////
  
  private void _heroView()
  {
    _hero.drawing();
  }

  public void prepareHeroNextDirection(int direction) 
  {
    _hero.setDirection("next", direction);
  }

  private void _updateHero()
  {
    _updateHeroMovement();
  }

  private void _updateHeroMovement()
  {
    int currentDirection = _hero.getDirection("current"),
        nextDirection    = _hero.getDirection("next");
    
    if(_hero.isMoveableTo("nextDirection") && nextDirection != currentDirection)
      _hero.setDirection("current", nextDirection);

    else if(_hero.isMoveableTo("currentDirection"))
      _hero.move(currentDirection);
  }

  private void _resetHero()
  {
    _hero.putOnStartingCell();
  }

  ////////////////////////////
  //         GHOSTS         //
  ////////////////////////////
  
  private ArrayList<Ghost> _initGhosts()
  {
    ArrayList<Ghost> ghosts = new ArrayList<Ghost>();
    ArrayList<Cell> ghostsCells = _board.getGhostsCells();

    for(int i=0; i < ghostsCells.size(); i++)
    {
      Ghost g = new Ghost(TypeGhost.generate(int(random(1,5))), _board);
      g.putOnCell(ghostsCells.get(i));
      ghosts.add(g);
    }

    return ghosts;
  }

  private void _ghostsView()
  {
    for(Ghost _g : _ghosts)
      _g.drawing();
  }

  private void _updateGhosts()
  {
    _updateGhostsDirections();
    _updateGhostsMoveModes();
    _updateGhostsMovements();
    _updateGhostsCollisions();
  }

  private void _updateGhostsCollisions()
  {
    for(Ghost _g : _ghosts)
      if(_g.isInCollisionWith(_hero))
      {
        switch(_mood)
        {
          case SCARED:
            Cell boardGhostCell = _board.getGhostsCells().get(0);
            PVector bgCellPos = boardGhostCell.getPos("center");

            _g.setScreenPos(bgCellPos.x, bgCellPos.y);
            _g.setDirection("next", RIGHT);

            _mood.otherGhostKilled();
            int value = int(200 * pow(2, _mood.getNbGhostKilled() -1));
            _hero.addScore(value);

            break;
          default:
            _hero.losesOneLife();
            if(_hero.getLives() > 0)
              _resetGame();
            else
              _endGame();
            break;
        }
      }
  }
  private void _updateGhostsDirections()
  {
    Cell firstSACell = _board.getSingleAccessCells().get(0),
         lastSACell  = _board.getSingleAccessCells().get(1);

    for(Ghost _g : _ghosts)
    {
      Cell ghostCell = _g.getCell();
      int currentDirection = _g.getDirection("current");

      if(ghostCell == firstSACell && currentDirection == LEFT && _g.isMoving("onCellCenter"))
        _g.setDirection("next", RIGHT);
      else if(ghostCell == lastSACell && currentDirection == RIGHT &&  _g.isMoving("onCellCenter"))
        _g.setDirection("next", LEFT);
      else
        _g.generateNextDirection(_hero);
    }
  }
  private void _updateGhostsMoveModes()
  {
    for(Ghost _g : _ghosts)
    {
      switch(_mood)
      {
        default:
          if(_g.isInsideHeroZone(_hero))
            _g.setMoveMode(GhostMoveMode.HUNTING);
          else
            _g.setMoveMode(GhostMoveMode.DISPERSAL);

          if(_ghosts.get(_ghosts.size()-1).getColor() == BLUE)
            _g.setColor(_g.getType().getColor());
          break;

        case SCARED:
          if(_g.isInsideHeroZone(_hero))
            _g.setMoveMode(GhostMoveMode.SCARED);
          else
            _g.setMoveMode(GhostMoveMode.DISPERSAL);

          //if(_ghosts.get(_ghosts.size()-1).getColor() != BLUE)
            _g.setColor(BLUE);
          break;
      }
    }
  }
  private void _updateGhostsMovements()
  {
    for(Ghost _g : _ghosts)
    {
      int currentDirection = _g.getDirection("current"),
          nextDirection    = _g.getDirection("next");

      if(_g.isMoveableTo("nextDirection") && nextDirection != currentDirection)
        _g.setDirection("current", nextDirection);

      else if(_g.isMoveableTo("currentDirection"))
        _g.move(currentDirection);
    }
  }

  private void _resetGhosts()
  {
    ArrayList<Cell> ghostsCells = _board.getGhostsCells();

    int i = 0;
    for(Ghost _g : _ghosts)
    {
      _g.putOnCell(ghostsCells.get(i));
      i++;
    }
  }

}
