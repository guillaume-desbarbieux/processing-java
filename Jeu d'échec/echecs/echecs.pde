// Réglages taille et couleur
final int TAILLE_CASE = 70;
final color COLOR_WHITE = color (234, 218, 248);
final color COLOR_BLACK = color (151, 118, 179);
final color COLOR_SELECTED = color (59, 255, 93);


// Tableau contenant toutes les infos
final int[][][] plateau = new int[9][9][2];

// Coordonnées sur le plateau
final int A = 1;
final int B = 2;
final int C = 3;
final int D = 4;
final int E = 5;
final int F = 6;
final int G = 7;
final int H = 8;

// Liste des pièces
final int PION = 9;
final int TOUR = 10 ;
final int CAVALIER = 11;
final int FOU = 12;
final int ROI = 13;
final int REINE = 14;

// Liste des couleurs
final int BLANC = 15;
final int NOIR = 16;
final int VIDE = 0;

// Informations contenues dans plateau
final int PIECE = 0;
final int COLOR = 1;

// Joueur actif
int active_player = NOIR;
IntList selected_list_of_possible_moves = new IntList();

// Images des pièces
PImage roi_b;
PImage roi_n;
PImage reine_b;
PImage reine_n;
PImage fou_b;
PImage fou_n;
PImage cavalier_b;
PImage cavalier_n;
PImage tour_b;
PImage tour_n;
PImage pion_b;
PImage pion_n;

// Gestion de la souris
int clic_X = 0;
int clic_Y = 0;

final int WAITING = 0;
final int SELECTED = 1;
final int PLACED = 2;
int clic_step = WAITING;

int SELECTED_SQUARE_X = 0;
int SELECTED_SQUARE_Y = 0;




void init_plateau () {
  active_player = NOIR;
  for (int i = A; i <= H; i++) {
    for (int j = 1; j <= 8; j++) {
      plateau[i][j][PIECE] = VIDE;
      plateau[i][2][PIECE] = PION;
      plateau[i][7][PIECE] = PION;

      switch (j) {
      case 1 :
      case 2 :
        plateau[i][j][COLOR] = BLANC;
        break;
      case 7 :
      case 8 :
        plateau[i][j][COLOR] = NOIR;
        break;
      default :
        plateau[i][j][COLOR] = VIDE;
        break;
      }
    }
  }
  for (int j = 1; j<=8; j=j+7) {
    plateau[A][j][PIECE] = TOUR;
    plateau[B][j][PIECE] = CAVALIER;
    plateau[C][j][PIECE] = FOU;
    plateau[D][j][PIECE] = REINE;
    plateau[E][j][PIECE] = ROI;
    plateau[F][j][PIECE] = FOU;
    plateau[G][j][PIECE] = CAVALIER;
    plateau[H][j][PIECE] = TOUR;
  }
  println("after init_plateau");
  print_plateau(plateau);
}

void print_plateau(int[][][] temp_plateau) {
  for (int j = 1; j<=8; j++) {
    println("");
    for (int i = 1; i<=8; i++) {

      print(temp_plateau[i][j][PIECE], ",", temp_plateau[i][j][COLOR], " - ");
    }
  }
  println("");
  println("");
}



int count_possible_moves (int active_player, int[][][] temp_board) {
  int number_of_possible_moves = 0;
  for (int i = A; i <= H; i++) {
    for (int j = 1; j <= 8; j++) {
      if (temp_board[i][j][COLOR] == active_player) {
        switch (temp_board[i][j][PIECE]) {
          case (PION) :
          number_of_possible_moves += list_moves_PION (temp_board, i, j).size();
          break;
          case (TOUR) :
          number_of_possible_moves += list_moves_TOUR (temp_board, i, j).size();
          break;
          case (FOU) :
          number_of_possible_moves += list_moves_FOU (temp_board, i, j).size();
          break;
          case (CAVALIER) :
          number_of_possible_moves += list_moves_CAVALIER (temp_board, i, j).size();
          break;
          case (REINE) :
          number_of_possible_moves += list_moves_REINE (temp_board, i, j).size();
          break;
          case (ROI) :
          number_of_possible_moves += list_moves_ROI (temp_board, i, j).size();
          break;
        }
      }
    }
  }
  return number_of_possible_moves;
}



IntList list_moves_PION (int[][][] temp_board, int i, int j) {
  IntList list_of_possible_moves = new IntList();
  switch (temp_board[i][j][COLOR]) {
  case BLANC :
    if (j<8) {
      if (temp_board[i][j+1][PIECE] == VIDE) {
        if (!verifie_echec_mouvement(temp_board, active_player, i, j, i, j+1)) {
          list_of_possible_moves.append(i);
          list_of_possible_moves.append(j+1);
        }
      }
      if (i>A) {
        if (temp_board[i-1][j+1][COLOR] == NOIR) {
          if (!verifie_echec_mouvement(temp_board, active_player, i, j, i-1, j+1)) {
            list_of_possible_moves.append(i-1);
            list_of_possible_moves.append(j+1);
          }
        }
      }
      if (i<H) {
        if (temp_board[i+1][j+1][COLOR] == NOIR) {
          if (!verifie_echec_mouvement(temp_board, active_player, i, j, i+1, j+1)) {
            list_of_possible_moves.append(i+1);
            list_of_possible_moves.append(j+1);
          }
        }
      }
    }
    if (j == 2) {
      if (temp_board[i][j+2][PIECE] == VIDE) {
        if (!verifie_echec_mouvement(temp_board, active_player, i, j, i, j+2)) {
          list_of_possible_moves.append(i);
          list_of_possible_moves.append(j+2);
        }
      }
    }
    break;

  case NOIR :
    if (j>1) {
      if (temp_board[i][j-1][PIECE] == VIDE) {
        if (!verifie_echec_mouvement(temp_board, active_player, i, j, i, j-1)) {
          list_of_possible_moves.append(i);
          list_of_possible_moves.append(j-1);
        }
      }
      if (i>A) {
        if (temp_board[i-1][j-1][COLOR] == NOIR) {
          if (!verifie_echec_mouvement(temp_board, active_player, i, j, i-1, j-1)) {
            list_of_possible_moves.append(i-1);
            list_of_possible_moves.append(j-1);
          }
        }
      }
      if (i<H) {
        if (temp_board[i+1][j-1][COLOR] == NOIR) {
          if (!verifie_echec_mouvement(temp_board, active_player, i, j, i+1, j-1)) {
            list_of_possible_moves.append(i+1);
            list_of_possible_moves.append(j-1);
          }
        }
      }
    }
    if (j == 7) {
      if (temp_board[i][j-2][PIECE] == VIDE) {
        if (!verifie_echec_mouvement(temp_board, active_player, i, j, i, j-2)) {
          list_of_possible_moves.append(i);
          list_of_possible_moves.append(j-2);
        }
      }
    }
    break;
  }
  return  list_of_possible_moves;
}



IntList list_moves_TOUR (int[][][] temp_board, int i, int j) {
  IntList list_of_possible_moves = new IntList();

  // Vérification mouvement ves la droite
  for (int d = 1; i+d <= H; d++) {
    if (temp_board[i+d][j][COLOR] != active_player) {
      if (!verifie_echec_mouvement(temp_board, active_player, i, j, i+d, j)) {
        list_of_possible_moves.append(i+d);
        list_of_possible_moves.append(j);
      }
    }
    if (temp_board[i+d][j][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement ves la gauche
  for (int d = 1; i-d >= A; d++) {
    if (temp_board[i-d][j][COLOR] != active_player) {
      if (!verifie_echec_mouvement(temp_board, active_player, i, j, i-d, j)) {
        list_of_possible_moves.append(i-d);
        list_of_possible_moves.append(j);
      }
    }
    if (temp_board[i-d][j][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement ves le bas
  for (int d = 1; j-d >= 1; d++) {
    if (temp_board[i][j-d][COLOR] != active_player) {
      if (!verifie_echec_mouvement(temp_board, active_player, i, j, i, j-d)) {
        list_of_possible_moves.append(i);
        list_of_possible_moves.append(j-d);
      }
    }
    if (temp_board[i][j-d][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement ves le haut
  for (int d = 1; j+d <= 8; d++) {
    if (temp_board[i][j+d][COLOR] != active_player) {
      if (!verifie_echec_mouvement(temp_board, active_player, i, j, i, j+d)) {
        list_of_possible_moves.append(i);
        list_of_possible_moves.append(j+d);
      }
    }
    if (temp_board[i][j+d][COLOR] != VIDE) {
      d=8;
    }
  }
  return list_of_possible_moves;
}



IntList list_moves_FOU (int[][][] temp_board, int i, int j) {
  IntList list_of_possible_moves = new IntList();

  // Vérification mouvement vers diagonale haut droite
  for (int d = 1; (i+d <= H) && (j+d <= 8); d++) {
    if (temp_board[i+d][j+d][COLOR] != active_player) {
      if (!verifie_echec_mouvement(temp_board, active_player, i, j, i+d, j+d)) {
        list_of_possible_moves.append(i+d);
        list_of_possible_moves.append(j+d);
      }
    }
    if (temp_board[i+d][j+d][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement vers diagonale bas droite
  for (int d = 1; (i+d <= H) && (j-d >= 1); d++) {
    if (temp_board[i+d][j-d][COLOR] != active_player) {
      if (!verifie_echec_mouvement(temp_board, active_player, i, j, i+d, j-d)) {
        list_of_possible_moves.append(i+d);
        list_of_possible_moves.append(j-d);
      }
    }
    if (temp_board[i+d][j-d][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement vers diagonale bas gauche
  for (int d = 1; (i-d >= A) && (j-d >= 1); d++) {
    if (temp_board[i-d][j-d][COLOR] != active_player) {
      if (!verifie_echec_mouvement(temp_board, active_player, i, j, i-d, j-d)) {
        list_of_possible_moves.append(i-d);
        list_of_possible_moves.append(j-d);
      }
    }
    if (temp_board[i-d][j-d][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement vers diagonale haut gauche
  for (int d = 1; (i-d >= A) && (j+d <= 8); d++) {
    if (temp_board[i-d][j+d][COLOR] != active_player) {
      if (!verifie_echec_mouvement(temp_board, active_player, i, j, i-d, j+d)) {
        list_of_possible_moves.append(i-d);
        list_of_possible_moves.append(j+d);
      }
    }
    if (temp_board[i-d][j+d][COLOR] != VIDE) {
      d=8;
    }
  }
  return  list_of_possible_moves;
}



IntList list_moves_REINE (int[][][] temp_board, int i, int j) {
  IntList list_of_possible_moves = new IntList();
  list_of_possible_moves.append(list_moves_TOUR (temp_board, i, j));
  list_of_possible_moves.append(list_moves_FOU (temp_board, i, j));
  return list_of_possible_moves;
}



IntList list_moves_ROI (int[][][] temp_board, int i, int j) {
  IntList list_of_possible_moves = new IntList();
  for (int x = i-1; x <= i+1; x++) {
    for (int y = j-1; y <= j+1; y++) {
      if ((x>=A) && (x<=H) && (y>=1) && (y<=8)) {
        if ((temp_board[x][y][COLOR] != active_player) && (!verifie_echec_mouvement(temp_board, active_player, i, j, x, y))) {
          list_of_possible_moves.append(x);
          list_of_possible_moves.append(y);
        }
      }
    }
  }
  return list_of_possible_moves;
}



IntList list_moves_CAVALIER (int[][][] temp_board, int i, int j) {
  IntList list_of_possible_moves = new IntList();
  if ((i<=G) && (j<=6)) {
    if ((temp_board[i+1][j+2][COLOR] != active_player) && (!verifie_echec_mouvement(temp_board, active_player, i, j, i+1, j+2))) {
      list_of_possible_moves.append(i+1);
      list_of_possible_moves.append(j+2);
    }
  }
  if ((i<=F) && (j<=7)) {
    if ((temp_board[i+2][j+1][COLOR] != active_player) && (!verifie_echec_mouvement(temp_board, active_player, i, j, i+2, j+1))) {
      list_of_possible_moves.append(i+2);
      list_of_possible_moves.append(j+1);
    }
  }
  if ((i<=F) && (j>=2)) {
    if ((temp_board[i+2][j-1][COLOR] != active_player) && (!verifie_echec_mouvement(temp_board, active_player, i, j, i+2, j-1))) {
      list_of_possible_moves.append(i+2);
      list_of_possible_moves.append(j-1);
    }
  }
  if ((i<=G) && (j>=3)) {
    if ((temp_board[i+1][j-2][COLOR] != active_player) && (!verifie_echec_mouvement(temp_board, active_player, i, j, i+1, j-2))) {
      list_of_possible_moves.append(i+1);
      list_of_possible_moves.append(j-2);
    }
  }
  if ((i>=B) && (j>=3)) {
    if ((temp_board[i-1][j-2][COLOR] != active_player) && (!verifie_echec_mouvement(temp_board, active_player, i, j, i-1, j-2))) {
      list_of_possible_moves.append(i-1);
      list_of_possible_moves.append(j-2);
    }
  }
  if ((i>=C) && (j>=2)) {
    if ((temp_board[i-2][j-1][COLOR] != active_player) && (!verifie_echec_mouvement(temp_board, active_player, i, j, i-2, j-1))) {
      list_of_possible_moves.append(i-2);
      list_of_possible_moves.append(j-1);
    }
  }
  if ((i>=C) && (j<=7)) {
    if ((temp_board[i-2][j+1][COLOR] != active_player) && (!verifie_echec_mouvement(temp_board, active_player, i, j, i-2, j+1))) {
      list_of_possible_moves.append(i-2);
      list_of_possible_moves.append(j+1);
    }
  }
  if ((i>=B) && (j<=6)) {
    if ((temp_board[i-1][j+2][COLOR] != active_player) && (!verifie_echec_mouvement(temp_board, active_player, i, j, i-1, j+2))) {
      list_of_possible_moves.append(i-1);
      list_of_possible_moves.append(j+2);
    }
  }
  return list_of_possible_moves;
}


boolean verifie_echec_mouvement (int [][][] temp_board, int player, int i, int j, int x, int y) {
  println("verifie echec mouvement");
  print_plateau(plateau);
  int [][][] futur_plateau = temp_board;
  futur_plateau[i][j][PIECE] = VIDE;
  futur_plateau[i][j][COLOR] = VIDE;
  futur_plateau[x][y][PIECE] = temp_board[i][j][PIECE];
  futur_plateau[x][y][PIECE] = temp_board[i][j][COLOR];

  return verifie_echec_global (player, futur_plateau);
}


boolean verifie_echec_global (int player, int[][][] temp_board) {
  boolean answer = false;
  for (int i = A; i<= H; i++) {
    for (int j = 1; j <= 8; j++) {
      if ((temp_board[i][j][COLOR] != player) && (temp_board[i][j][COLOR] != VIDE)) {
        answer = answer || verifie_echec_local (temp_board, i, j);
      }
    }
  }
  return answer;
}


boolean verifie_echec_local (int[][][] temp_board, int i, int j) {
  boolean answer  = false;
  IntList list_of_possible_moves = new IntList();

  switch (temp_board[i][j][PIECE]) {
  case PION :
    list_of_possible_moves = list_moves_PION (temp_board, i, j);
    break;
  case TOUR :
    list_of_possible_moves = list_moves_TOUR (temp_board, i, j);
    break;
  case FOU :
    list_of_possible_moves = list_moves_FOU (temp_board, i, j);
    break;
  case CAVALIER :
    list_of_possible_moves = list_moves_CAVALIER (temp_board, i, j);
    break;
  case REINE :
    list_of_possible_moves = list_moves_REINE (temp_board, i, j);
    break;
  }
  for (int x = 0; x < list_of_possible_moves.size(); x=x+2) {
    if  (temp_board[list_of_possible_moves.get(x)][list_of_possible_moves.get(x+1)][PIECE] == ROI) {
      answer = true;
    }
  }
  return answer;
}

void display_plateau() {
  for (int i = A; i <= H; i++) {
    for (int j = 1; j <= 8; j++) {
      display_case(i, j);
      display_piece(i, j);
    }
  }
  println("avant display possible move");
  print_plateau(plateau);
  display_possible_moves();
}

void display_case ( int i, int j) {
  int k = j;
  if ((i==SELECTED_SQUARE_X) && (j==SELECTED_SQUARE_Y)) {
    fill(COLOR_SELECTED);
  } else if ((i+j)%2 == 0) {
    fill(COLOR_BLACK);
  } else {
    fill (COLOR_WHITE);
  }
  rect (TAILLE_CASE*i, TAILLE_CASE*k, TAILLE_CASE, TAILLE_CASE);
}

void display_piece (int i, int j) {
  int k = j;
  switch (plateau[i][j][PIECE]) {
  case PION :
    if (plateau[i][j][COLOR] == BLANC) {
      image(pion_b, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    } else {
      image(pion_n, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    }
    break;
  case TOUR :
    if (plateau[i][j][COLOR] == BLANC) {
      image(tour_b, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    } else {
      image(tour_n, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    }
    break;
  case FOU :
    if (plateau[i][j][COLOR] == BLANC) {
      image(fou_b, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    } else {
      image(fou_n, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    }
    break;
  case CAVALIER :
    if (plateau[i][j][COLOR] == BLANC) {
      image(cavalier_b, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    } else {
      image(cavalier_n, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    }
    break;
  case ROI :
    if (plateau[i][j][COLOR] == BLANC) {
      image(roi_b, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    } else {
      image(roi_n, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    }
    break;
  case REINE :
    if (plateau[i][j][COLOR] == BLANC) {
      image(reine_b, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    } else {
      image(reine_n, i*TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE);
    }
    break;
  }
}


void display_possible_moves () {

  switch (plateau[SELECTED_SQUARE_X][SELECTED_SQUARE_Y][PIECE]) {
    case (PION) :
    println("pion");
    selected_list_of_possible_moves = list_moves_PION (plateau, SELECTED_SQUARE_X, SELECTED_SQUARE_Y);
    break;
    case (TOUR) :
    println("tour");
    selected_list_of_possible_moves = list_moves_TOUR (plateau, SELECTED_SQUARE_X, SELECTED_SQUARE_Y);
    break;
    case (FOU) :
    println("fou");
    selected_list_of_possible_moves = list_moves_FOU (plateau, SELECTED_SQUARE_X, SELECTED_SQUARE_Y);
    break;
    case (CAVALIER) :
    println("cavalier");
    selected_list_of_possible_moves = list_moves_CAVALIER (plateau, SELECTED_SQUARE_X, SELECTED_SQUARE_Y);
    break;
    case (REINE) :
    println("reine");
    selected_list_of_possible_moves = list_moves_REINE (plateau, SELECTED_SQUARE_X, SELECTED_SQUARE_Y);
    break;
    case (ROI) :
    println("roi");
    selected_list_of_possible_moves = list_moves_ROI (plateau, SELECTED_SQUARE_X, SELECTED_SQUARE_Y);
    break;
  default :
    println("default");
    selected_list_of_possible_moves.clear();
    break;
  }

  for (int i = 0; i < selected_list_of_possible_moves.size(); i = i+2) {
    fill (206, 206, 206);
    ellipse(selected_list_of_possible_moves.get(i)*TAILLE_CASE, selected_list_of_possible_moves.get(i+1)*TAILLE_CASE, TAILLE_CASE/3, TAILLE_CASE/3);
  }
  println("after display possible_move");
  print_plateau(plateau);
}



void settings() {
  size(TAILLE_CASE*9, TAILLE_CASE*9);
}

void setup () {

  imageMode(CENTER);
  rectMode(CENTER);

  pion_n = loadImage("pion_n.png");
  roi_n = loadImage("roi_n.png");
  reine_n = loadImage("reine_n.png");
  fou_n = loadImage("fou_n.png");
  cavalier_n = loadImage("cavalier_n.png");
  tour_n = loadImage("tour_n.png");

  pion_b = loadImage("pion_b.png");
  roi_b = loadImage("roi_b.png");
  reine_b = loadImage("reine_b.png");
  fou_b = loadImage("fou_b.png");
  cavalier_b = loadImage("cavalier_b.png");
  tour_b = loadImage("tour_b.png");

  selected_list_of_possible_moves.clear();
  SELECTED_SQUARE_X = 0;
  SELECTED_SQUARE_Y = 0;

  init_plateau();
  display_plateau();
}

void draw () {
}

void mousePressed() {
  println("event mousepressed");
  if (clic_in_board()) {
    clic_X = mouseX;
    clic_Y = mouseY;
    // clic_step = (clic_step +1) %3;
    println("waiting = 0   -   selected = 1   -   targeted = 2   :", clic_step);
  }

  switch (clic_step) {
  case WAITING :
    println("clic after waiting");
    print_plateau(plateau);
    SELECTED_SQUARE_X = convert_clic_to_board(clic_X);
    SELECTED_SQUARE_Y = convert_clic_to_board(clic_Y);
    clic_step = SELECTED;
    if (plateau[SELECTED_SQUARE_X][SELECTED_SQUARE_Y][COLOR] != active_player) {
      SELECTED_SQUARE_X = 0;
      SELECTED_SQUARE_Y = 0;
      clic_step = WAITING;
    }
    break;
  case SELECTED :
    println("clic after selected");
    int TARGETED_SQUARE_X = convert_clic_to_board(clic_X);
    int TARGETED_SQUARE_Y = convert_clic_to_board(clic_Y);
    clic_step = WAITING;
    if (plateau[TARGETED_SQUARE_X][TARGETED_SQUARE_Y][COLOR] == active_player) {
      SELECTED_SQUARE_X = TARGETED_SQUARE_X;
      SELECTED_SQUARE_Y = TARGETED_SQUARE_Y;
      clic_step = SELECTED;
    } else {
      resolve_move(TARGETED_SQUARE_X, TARGETED_SQUARE_Y);
      SELECTED_SQUARE_X = 0;
      SELECTED_SQUARE_Y = 0;
    }
    break;
  }
  println("fin clic_step case");
  print_plateau(plateau);
  display_plateau();
}




boolean clic_in_board() {
  return ((mouseX > TAILLE_CASE/2) && (mouseX < TAILLE_CASE*8.5) && (mouseY > TAILLE_CASE/2) && (mouseY < TAILLE_CASE*8.5));
}

int convert_clic_to_board (int clic_position) {
  return (1+(clic_position - TAILLE_CASE/2)/TAILLE_CASE);
}

void resolve_move (int i, int j) {
  println("moving", plateau[i][j][PIECE], " ", plateau[i][j][COLOR], " ", SELECTED_SQUARE_X, ",", SELECTED_SQUARE_Y, " to ", i, ",", j);

  for (int x = 0; x < selected_list_of_possible_moves.size(); x = x+2) {
    println("list item ", selected_list_of_possible_moves.get(x), ",", selected_list_of_possible_moves.get(x+1));
    if ((selected_list_of_possible_moves.get(x) == i) && (selected_list_of_possible_moves.get(x+1) == j)) {
      plateau[i][j][PIECE] = plateau[SELECTED_SQUARE_X][SELECTED_SQUARE_Y][PIECE];
      plateau[i][j][COLOR] = plateau[SELECTED_SQUARE_X][SELECTED_SQUARE_Y][COLOR];
      plateau[SELECTED_SQUARE_X][SELECTED_SQUARE_Y][PIECE] = VIDE;
      plateau[SELECTED_SQUARE_X][SELECTED_SQUARE_Y][COLOR] = VIDE;
      SELECTED_SQUARE_X = 0;
      SELECTED_SQUARE_Y = 0;
      clic_step = WAITING;
      println("ok move n° ", x);
      if (active_player == BLANC) {
        active_player = NOIR;
      } else {
        active_player = BLANC;
      }
    } else {
      println("impossible move n° ", x);
    }
  }
  println("after resolve_move");
  print_plateau(plateau);
}
