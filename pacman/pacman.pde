import java.io.*;
import java.util.*;

Game game;
KRandom rand;
KTimer timer;
float avant = 0;

File folder;
String[] filenames;

void setup() {
  size(800, 800, P2D);
  frameRate(200);

  rand = new KRandom();
  timer = new KTimer(0);

  game = new Game("level2.txt");
  game.users("Richard;Romain;Tom;Maxime;Romane;Ileana;Alice");
}

void draw() {
  background(BLACK);

  try
  {
    game.run();
  }
  catch(Exception e){ 
    e.printStackTrace(); 
  }
}

void keyPressed() {
  switch(keyCode)
  {
    default:    key = 0;                              break;
    case UP:    game.prepareHeroNextDirection(UP);    break;
    case DOWN:  game.prepareHeroNextDirection(DOWN);  break;
    case LEFT:  game.prepareHeroNextDirection(LEFT);  break;
    case RIGHT: game.prepareHeroNextDirection(RIGHT); break;
    case ESC:
      key = 0;
      if(!game.stateGameIs(StateGame.MENU)){ 
        game.changeStateGameTo(StateGame.MENU);
        frameRate(24); 
      }
    break;
  }
}

void mousePressed() {
  if(game.stateGameIs(StateGame.MENU))
    game.onMenuButtonClickEvent();
}
