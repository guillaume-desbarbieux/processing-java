// Ci dessous les paramètres du jeu pour modification rapides : //<>// //<>//
int nb_players = 4;
int taille_case = 50;
final float VITESSE = 200;

// Joueur dont c'est le tour de jouer
int active_player=0;

//Fin du jeu
boolean endgame=false;

// Choix du Dé via le clavier
int D1 = 0;
int D2 = 0;

// Le plateau et les informations qui y seront stockées
int[][] plateau = new int [64][4];
final int CASE_X = 0;
final int CASE_Y = 1;
final int CASE_TYPE = 2;
final int PLAYER_IN_PLACE = 3;

// Les différents types de cases du plateau
final int DEPART=0;
final int VIDE=1;
final int PUITS=3;
final int OIES=9;
final int HOTEL=19;
final int LABYRINTHE=42;
final int TETEDEMORT=58;
final int PRISON=52;
final int ARRIVEE=63;

// Le tableau des joueurs et les informations qui y seront stockées
int[][] players = new int [nb_players][3];
final int POSITION = 0;
final int PREVIOUS_POSITION = 1;
final int ATTENTE=2;

float zz=0;

float[][] pion = new float [nb_players][2];
final int COORD_X = 0;
final int COORD_Y = 1;

final int NOBODY = -1;

int players_colors= int(360/(nb_players+1));

final color BG = color (240, 224, 211);


void settings() {
  size (taille_case*10, taille_case*11);
}

void setup() {
  colorMode(HSB, 360, 100, 100);
  textSize(taille_case/3);
  rectMode(CENTER);
  background(BG);
  init_plateau();
  init_players();
  println("Joueur ", active_player, " sur case ", players[active_player][POSITION], " lancez un dé");
}

void init_plateau() {

  disposition_cases();

  for (int i=0; i<64; i++) {

    plateau[i][CASE_TYPE] = VIDE;
    plateau[i][PLAYER_IN_PLACE] = -1;
    switch(i) {
    case DEPART:
      plateau[i][CASE_TYPE] = DEPART;
      break;
    case PUITS:
      plateau[i][CASE_TYPE] = PUITS;
      break;
    case OIES:
    case 18:
    case 27:
    case 36:
    case 45:
    case 54 :
      plateau[i][CASE_TYPE] = OIES;
      break;
    case HOTEL:
      plateau[i][CASE_TYPE] = HOTEL;
      break;
    case LABYRINTHE:
      plateau[i][CASE_TYPE] = LABYRINTHE;
      break;
    case PRISON:
      plateau[i][CASE_TYPE] = PRISON;
      break;
    case TETEDEMORT:
      plateau[i][CASE_TYPE] = TETEDEMORT;
      break;
    case ARRIVEE:
      plateau[i][CASE_TYPE] = ARRIVEE;
      break;
    }
  }
}

void init_players() {
  for (int i=0; i<players.length; i++) {
    players[i][POSITION]=DEPART;
    players[i][ATTENTE]=0;
    pion[i][COORD_X]=plateau[0][CASE_X];
    pion[i][COORD_Y]=plateau[0][CASE_Y];
  }
}

void display() {
  for (int i = 0; i < 64; i++) {
    display_case(i);
  }
  for (int i = nb_players-1 ; i >= 0 ; i--) {
    display_pion (i);
  }
}

void display_case(int i) {
  switch(plateau[i][CASE_TYPE]) {
  case VIDE :
    fill (#EDEDE8);
    break;
  case PUITS :
    fill(#61ADFC);
    break;
  case PRISON :
    fill(#F07816);
    break;
  case HOTEL :
    fill(#E71CE8);
    break;
  case LABYRINTHE :
    fill(#865E08);
    break;
  case TETEDEMORT :
    fill(#5A5753);
    break;
  case OIES :
    fill(#F5EE11);
    break;
  case DEPART :
    fill(#2DFF00);
    break;
  case ARRIVEE :
    fill(#21860B);
    break;
  }
  rect (plateau[i][CASE_X], plateau[i][CASE_Y], taille_case, taille_case);
  textAlign(CENTER, CENTER);
  fill(0);
  text(i, plateau[i][CASE_X], plateau[i][CASE_Y]);
}


void draw() {
  display();
  if (!endgame) {
    if (D1 != 0 && D2 != 0) {
      play();
      if (players[active_player][POSITION]==ARRIVEE) {
        endgame=true;
      }
      active_player = (active_player + 1) % nb_players;
      println("Joueur ", active_player, " sur case ", players[active_player][POSITION], " lancez un dé");
    }
  }
}

//void mouseClicked() {
//  play();
//  if (players[active_player][POSITION]==ARRIVEE) {
//    endgame();
//  }
//  active_player = (active_player + 1) % nb_players;
//}


void play() {

  if (players[active_player][ATTENTE]==0) {

    int lancer_1 = LancerDes();
    int lancer_2 = LancerDes();

    if (D1>0) {
      lancer_1 = D1;
      lancer_2 = D2;
    }

    D1=0;
    D2=0;

    int position_active_player = players[active_player][POSITION];

    println("Joueur ", active_player, " sur case ", position_active_player, " fait ", lancer_1, "+", lancer_2);

    int future_case = resolve_playing (position_active_player, lancer_1, lancer_2);


    move_player (active_player, future_case);
  } else {

    println("Joueur ", active_player, " sur case ", players[active_player][POSITION], " passe son tour.");

    players[active_player][ATTENTE]--;
  }
}

int resolve_playing (int position, int lancer1, int lancer2) {

  int answer = position + lancer1 + lancer2;


  if (answer > 63) {
    int ecart = answer - 63;
    answer = answer - ecart * 2;
    println("Joueur ", active_player, " est allé trop loin. Il recule de ", ecart, " cases.");
  }

  if (position == DEPART && lancer1+lancer2 == 9) {
    if ((lancer1 == 6 && lancer2 == 3) || (lancer1 == 3 && lancer2 == 6)) {
      answer = 26;
    }
    if ((lancer1 == 5 && lancer2 == 4) || (lancer1 == 4 && lancer2 == 5)) {
      answer = 53;
    }
  }

  if (position == DEPART && lancer1+D2 == 6) {
    answer = 12;
  }

  if (answer == HOTEL) {
    players[active_player][ATTENTE]=2;
    println("Joueur ", active_player, " est à l'hôtel. Il passe les deux prochains tours");
  }

  if (plateau[answer][CASE_TYPE] == OIES)
  {
    println("Joueur ", active_player, " tombe sur une oie. Il avance à nouveau." );
    answer = resolve_playing (answer, lancer1, lancer2);
  }

  if (answer == LABYRINTHE) {
    answer = 30;
    println("Joueur ", active_player, " se perd dans le labyrinthe. Il retourne en case 30." );
  }

  if (answer == TETEDEMORT) {
    answer = 0;
    println("Joueur ", active_player, " est mort. Il recommence la partie." );
  }

  if (answer == PUITS) {
    players[active_player][ATTENTE]=-1;
    println("Joueur ", active_player, " tombe dans le puits. Il attend qu'on vienne le libérer" );
  }

  if (answer == PRISON) {
    if (plateau[PRISON][PLAYER_IN_PLACE] == -1) {
      players[active_player][ATTENTE]=-1;
      println("Joueur ", active_player, " est en prison. Il attend qu'on vienne le libérer" );
    }
  }

  println("Il arrive en case ", answer);
  return answer;
}


void move_player (int joueur, int future_case) {

  println("appel move_player pour joueur ", joueur, " vers case ", future_case);

  int previous_position = players[joueur][POSITION] ;

  players[joueur][PREVIOUS_POSITION] = previous_position ;
  players[joueur][POSITION] = future_case;

  plateau[previous_position][PLAYER_IN_PLACE] = NOBODY;

  int player_found = plateau[future_case][PLAYER_IN_PLACE];

  if (player_found >= 0) {
    move_player ( player_found, previous_position);
  }

  plateau[future_case][PLAYER_IN_PLACE] = joueur;
}

void display_pion (int joueur) {

  if (joueur == active_player) {
    fill(0);
    ellipse (pion[joueur][COORD_X], pion[joueur][COORD_Y], taille_case/1.5, taille_case/1.5);
  }
  fill (players_colors*(joueur+1), 99, 99);
  ellipse (pion[joueur][COORD_X], pion[joueur][COORD_Y], taille_case/2, taille_case/2);
  fill(0);
  text(joueur, pion[joueur][COORD_X], pion[joueur][COORD_Y]);

  if (players[joueur][PREVIOUS_POSITION] != players[joueur][POSITION]) {
    rapproche_pion (joueur);
    println ("rapproche ", joueur, " de ", players[joueur][PREVIOUS_POSITION], " vers ", players[joueur][POSITION]);
  }
}

void rapproche_pion (int joueur) {
  int direction = players[joueur][POSITION] - players[joueur][PREVIOUS_POSITION];
  int prochaine_case = players[joueur][PREVIOUS_POSITION] + abs(direction)/direction;

  float dx = plateau[prochaine_case][CASE_X] - pion[joueur][COORD_X];
  float dy = plateau[prochaine_case][CASE_Y] - pion[joueur][COORD_Y];



  if (abs(dx) < VITESSE && abs(dy) < VITESSE) {
    pion[joueur][COORD_X] = plateau[prochaine_case][CASE_X];
    pion[joueur][COORD_Y] = plateau[prochaine_case][CASE_Y];
    players[joueur][PREVIOUS_POSITION] = prochaine_case ;
  } else {
    pion[joueur][COORD_X] += abs(dx)/dx * VITESSE;
    pion[joueur][COORD_Y] += abs(dy)/dy * VITESSE;
  }
}

int LancerDes() {
  return int(random(6)+1);
}

void keyReleased() {
  int answer = 0;
  switch (key) {
  case '1' :
    answer = 1;
    break;
  case '2' :
    answer = 2;
    break;
  case '3' :
    answer = 3;
    break;
  case '4' :
    answer = 4;
    break;
  case '5' :
    answer = 5;
    break;
  case '6' :
    answer = 6;
    break;
  case ' ' :
    D1 = -1;
    D2 = -1;
    break;
  }
  if (D1 == 0) {
    D1 = answer;
  } else if (D2 == 0) {
    D2 = answer;
  }
}

void endgame() {
  println("c'est gagné pour le joueur ", active_player);
  noLoop();
}

void disposition_cases () {
  plateau [0][CASE_X] = taille_case/2;
  plateau [0][CASE_Y] = taille_case/2;
  int dx = 1;
  int dy = 0;

  for (int i = 1; i<64; i++) {
    switch (i) {
    case 10 :
      dx = 0;
      dy = 1;
      break;
    case 20 :
      dx = -1;
      dy = 0;
      break;
    case 29 :
      dx = 0;
      dy = -1;
      break;
    case 37 :
      dx = 1;
      dy = 0;
      break;
    case 44 :
      dx = 0;
      dy = 1;
      break;
    case 50 :
      dx = -1;
      dy = 0;
      break;
    case 55 :
      dx = 0;
      dy = -1;
      break;
    case 59 :
      dx = 1;
      dy = 0;
      break;
    case 62 :
      dx = 0;
      dy = 1;
      break;
    }
    plateau[i][CASE_X] = plateau[i-1][CASE_X] + dx * taille_case;
    plateau[i][CASE_Y] = plateau[i-1][CASE_Y] + dy * taille_case;
  }
}
