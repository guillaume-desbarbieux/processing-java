// Réglages taille et couleur //<>//
final int TAILLE_CASE = 70;
final color COLOR_WHITE = color (234, 218, 248);
final color COLOR_BLACK = color (151, 118, 179);
final color COLOR_SELECTED = color (59, 255, 93);
final color BACKGROUND = color (232, 232, 232);


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
int active_player = BLANC;


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
int option_X = 0;
int option_Y = 0;

final int WAITING = 0;
final int SELECTED = 1;
final int PLACED = 2;
int clic_step = WAITING;

// Gestion de la case sélectionnée
int selected_i = 0;
int selected_j = 0;
IntList current_list_of_possible_moves = new IntList();

// Gestion du statut de la partie
final int PLAYING = 1;
final int MAT = 2;
final int PAT = 3;
final int NULL = 4;
final int TIME_OUT = 5;
final int PROMOTING = 6;
int status = WAITING;

// Gestion temps et coups
int time_last_display = millis();
float timer_blanc = 600;
float timer_noir = 600;
IntList history_of_moves = new IntList();

void init_plateau () {
  active_player = BLANC;
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
}

void print_plateau(int[][][] temp_plateau) {
  //for (int j = 1; j<=8; j++) {
  //  println("");
  //  for (int i = 1; i<=8; i++) {

  //    print(temp_plateau[i][j][PIECE], ",", temp_plateau[i][j][COLOR], " - ");
  //  }
  //}
  //println("");
  //println("");
}



int count_possible_moves (int player, int[][][] temp_board) {
  int number_of_possible_moves = 0;
  for (int i = A; i <= H; i++) {
    for (int j = 1; j <= 8; j++) {
      if (temp_board[i][j][COLOR] == player) {
        IntList list = make_list_possible_moves (temp_board, i, j);
        list = verifie_list_possible_moves(temp_board, i, j, list);
        number_of_possible_moves += list.size();
      }
    }
  }
  return number_of_possible_moves;
}



IntList list_moves_PION (int[][][] temp_board, int i, int j) {

  IntList list = new IntList();

  switch (temp_board[i][j][COLOR]) {

  case BLANC :
    if (j<8) {
      if (temp_board[i][j+1][PIECE] == VIDE) {
        list.append(i);
        list.append(j+1);
      }

      if (i>A) {
        if (temp_board[i-1][j+1][COLOR] == NOIR) {
          list.append(i-1);
          list.append(j+1);
        }
      }
      if (i<H) {
        if (temp_board[i+1][j+1][COLOR] == NOIR) {
          list.append(i+1);
          list.append(j+1);
        }
      }
    }
    if (j == 2) {
      if (temp_board[i][j+2][PIECE] == VIDE) {
        list.append(i);
        list.append(j+2);
      }
    }
    break;

  case NOIR :
    if (j>1) {
      if (temp_board[i][j-1][PIECE] == VIDE) {
        list.append(i);
        list.append(j-1);
      }
      if (i>A) {
        if (temp_board[i-1][j-1][COLOR] == BLANC) {
          list.append(i-1);
          list.append(j-1);
        }
      }
      if (i<H) {
        if (temp_board[i+1][j-1][COLOR] == BLANC) {
          list.append(i+1);
          list.append(j-1);
        }
      }
    }
    if (j == 7) {
      if (temp_board[i][j-2][PIECE] == VIDE) {
        list.append(i);
        list.append(j-2);
      }
    }
    break;
  }
  println("list_move_pion", i, ",", j, " : ", list);
  print_plateau(temp_board);
  return list;
}



IntList list_moves_TOUR (int[][][] temp_board, int i, int j) {
  IntList list = new IntList();
  int player = temp_board[i][j][COLOR];

  // Vérification mouvement ves la droite
  for (int d = 1; i+d <= H; d++) {
    if (temp_board[i+d][j][COLOR] != player) {
      list.append(i+d);
      list.append(j);
    }
    if (temp_board[i+d][j][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement ves la gauche
  for (int d = 1; i-d >= A; d++) {
    if (temp_board[i-d][j][COLOR] != player) {
      list.append(i-d);
      list.append(j);
    }
    if (temp_board[i-d][j][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement ves le bas
  for (int d = 1; j-d >= 1; d++) {
    if (temp_board[i][j-d][COLOR] != player) {
      list.append(i);
      list.append(j-d);
    }
    if (temp_board[i][j-d][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement ves le haut
  for (int d = 1; j+d <= 8; d++) {
    if (temp_board[i][j+d][COLOR] != player) {
      list.append(i);
      list.append(j+d);
    }
    if (temp_board[i][j+d][COLOR] != VIDE) {
      d=8;
    }
  }
  println("list_move_tour", i, ",", j, " : ", list);
  return list;
}



IntList list_moves_FOU (int[][][] temp_board, int i, int j) {
  IntList list = new IntList();
  int player = temp_board[i][j][COLOR];

  // Vérification mouvement vers diagonale haut droite
  for (int d = 1; (i+d <= H) && (j+d <= 8); d++) {
    if (temp_board[i+d][j+d][COLOR] != player) {
      list.append(i+d);
      list.append(j+d);
    }
    if (temp_board[i+d][j+d][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement vers diagonale bas droite
  for (int d = 1; (i+d <= H) && (j-d >= 1); d++) {
    if (temp_board[i+d][j-d][COLOR] != player) {
      list.append(i+d);
      list.append(j-d);
    }
    if (temp_board[i+d][j-d][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement vers diagonale bas gauche
  for (int d = 1; (i-d >= A) && (j-d >= 1); d++) {
    if (temp_board[i-d][j-d][COLOR] != player) {
      list.append(i-d);
      list.append(j-d);
    }
    if (temp_board[i-d][j-d][COLOR] != VIDE) {
      d=8;
    }
  }

  // Vérification mouvement vers diagonale haut gauche
  for (int d = 1; (i-d >= A) && (j+d <= 8); d++) {
    if (temp_board[i-d][j+d][COLOR] != player) {
      list.append(i-d);
      list.append(j+d);
    }
    if (temp_board[i-d][j+d][COLOR] != VIDE) {
      d=8;
    }
  }
  println("list_move_fou", i, ",", j, " : ", list);
  return  list;
}



IntList list_moves_REINE (int[][][] temp_board, int i, int j) {
  IntList list = new IntList();
  list.append(list_moves_TOUR (temp_board, i, j));
  list.append(list_moves_FOU (temp_board, i, j));
  return list;
}



IntList list_moves_ROI (int[][][] temp_board, int i, int j) {
  int player = temp_board[i][j][COLOR];
  IntList list = new IntList();
  for (int x = i-1; x <= i+1; x++) {
    for (int y = j-1; y <= j+1; y++) {
      if ((x>=A) && (x<=H) && (y>=1) && (y<=8)) {
        if (temp_board[x][y][COLOR] != player) {
          list.append(x);
          list.append(y);
        }
      }
    }
  }
  println("list_moves_roi", i, ",", j, " : ", list);
  return list;
}



IntList list_moves_CAVALIER (int[][][] temp_board, int i, int j) {
  IntList list = new IntList();
  int player = temp_board[i][j][COLOR];
  if ((i<=G) && (j<=6)) {
    if (temp_board[i+1][j+2][COLOR] != player) {
      list.append(i+1);
      list.append(j+2);
    }
  }
  if ((i<=F) && (j<=7)) {
    if (temp_board[i+2][j+1][COLOR] != player) {
      list.append(i+2);
      list.append(j+1);
    }
  }
  if ((i<=F) && (j>=2)) {
    if (temp_board[i+2][j-1][COLOR] != player) {
      list.append(i+2);
      list.append(j-1);
    }
  }
  if ((i<=G) && (j>=3)) {
    if (temp_board[i+1][j-2][COLOR] != player) {
      list.append(i+1);
      list.append(j-2);
    }
  }
  if ((i>=B) && (j>=3)) {
    if (temp_board[i-1][j-2][COLOR] != player) {
      list.append(i-1);
      list.append(j-2);
    }
  }
  if ((i>=C) && (j>=2)) {
    if (temp_board[i-2][j-1][COLOR] != player) {
      list.append(i-2);
      list.append(j-1);
    }
  }
  if ((i>=C) && (j<=7)) {
    if (temp_board[i-2][j+1][COLOR] != player) {
      list.append(i-2);
      list.append(j+1);
    }
  }
  if ((i>=B) && (j<=6)) {
    if (temp_board[i-1][j+2][COLOR] != player) {
      list.append(i-1);
      list.append(j+2);
    }
  }
  println("list_moves_cavalier", i, ",", j, " : ", list);
  return list;
}

IntList verifie_list_possible_moves (int[][][] board, int i, int j, IntList list) {

  println("début fonction vérifie liste pour déplacer ", i, ",", j, " vers ", list, " sur plateau.");
  println("sachant que cette case contient ", board[i][j][PIECE], ",", board[i][j][COLOR]);

  for (int k = 0; k < list.size(); k = k +2) {
    println("On vérifie le déplacement n° ", 1+k/2, " pour liste ", list);
    println("sachant que cette case contient ", board[i][j][PIECE], ",", board[i][j][COLOR]);
    int[][][] test_board = copy_board(board);
    println("déclaration test_board / sachant que cette case contient ", board[i][j][PIECE], ",", board[i][j][COLOR]);
    println("déclaration test_board / sachant que cette case contient en simulé ", test_board[i][j][PIECE], ",", test_board[i][j][COLOR]);
    test_board[i][j][PIECE] = VIDE;
    test_board[i][j][COLOR] = VIDE;
    println("on vide test_board sachant que cette case contient en réalité ", board[i][j][PIECE], ",", board[i][j][COLOR]);
    println("on vide test board sachant que cette case contient en simulé ", test_board[i][j][PIECE], ",", test_board[i][j][COLOR]);
    test_board[list.get(k)][list.get(k+1)][PIECE] = board[i][j][PIECE];
    test_board[list.get(k)][list.get(k+1)][COLOR] = board[i][j][COLOR];
    println("Vérifie validité du coup ", i, ",", j, " vers ", list.get(k), ",", list.get(k+1));
    println("sachant que cette case contient en réalité ", board[i][j][PIECE], ",", board[i][j][COLOR]);
    println("sachant que cette case contient en simulé ", test_board[i][j][PIECE], ",", test_board[i][j][COLOR]);
    if (verifie_echec (test_board, board[i][j][COLOR])) {
      list.remove(k);
      list.remove(k);
      k = k-2;
    }
  }
  println("fin verifie_list_possible. cette case contient ", board[i][j][PIECE], ",", board[i][j][COLOR]);
  return list;
}

boolean verifie_echec (int[][][] board, int player) {
  boolean answer = false;
  int adversaire = BLANC;

  if (player == BLANC) {
    adversaire = NOIR;
  }

  IntList list = make_list_of_all_possible_moves (board, adversaire);

  for (int k = 0; k < list.size(); k=k+2) {

    int i = list.get(k);
    int j = list.get(k+1);

    if ((board[i][j][PIECE] == ROI) && (board[i][j][COLOR] == player)) {
      answer = true;
    }
  }
  println("fonction vérifie échec pour ", player, " dans liste ", list, " répond ", answer);
  return answer;
}

IntList make_list_of_all_possible_moves (int[][][] board, int player) {

  IntList list = new IntList ();

  for (int i = A; i <= H; i++) {
    for (int j = 1; j <= 8; j++) {
      if (board[i][j][COLOR] == player) {
        list.append(make_list_possible_moves(board, i, j));
      }
    }
  }

  return list;
}


void display_plateau() {
  for (int i = A; i <= H; i++) {
    for (int j = 1; j <= 8; j++) {

      display_case(i, j);
      display_piece(i, j);
    }
  }
  display_possible_moves(current_list_of_possible_moves);
}

void display_msg() {
  fill(255, 0, 0);
  textSize(TAILLE_CASE);
  switch (status) {
  case MAT :
    text("Echec et Mat", 4*TAILLE_CASE, 4*TAILLE_CASE);
    println("mat");
    break;
  case PAT :
    text("PAT", 4*TAILLE_CASE, 4*TAILLE_CASE);
    println("pat");
    break;
  case NULL :
    text("NULLE", 4*TAILLE_CASE, 4*TAILLE_CASE);
    println("Null");
    break;
  case TIME_OUT :
    text("Time Out", 4*TAILLE_CASE, 4*TAILLE_CASE);
    println("time out");
    break;
  case WAITING :
    text("Clic to start", 4*TAILLE_CASE, 4*TAILLE_CASE);
    break;
  }
}

void display_case ( int i, int j) {
  int k = 9-j;
  if ((i==selected_i) && (j==selected_j)) {
    fill(COLOR_SELECTED);
  } else if ((i+j)%2 == 0) {
    fill(COLOR_BLACK);
  } else {
    fill (COLOR_WHITE);
  }
  rect (TAILLE_CASE*i, TAILLE_CASE*k, TAILLE_CASE, TAILLE_CASE);
}

void display_piece (int i, int j) {
  int k = 9-j;
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


IntList make_list_possible_moves (int[][][] temp_board, int i, int j) {

  IntList list_of_possible_moves = new IntList ();


  switch (temp_board[i][j][PIECE]) {
    case (PION) :
    list_of_possible_moves = list_moves_PION (temp_board, i, j);
    break;
    case (TOUR) :
    list_of_possible_moves = list_moves_TOUR (temp_board, i, j);
    break;
    case (FOU) :
    list_of_possible_moves = list_moves_FOU (temp_board, i, j);
    break;
    case (CAVALIER) :
    list_of_possible_moves = list_moves_CAVALIER (temp_board, i, j);
    break;
    case (REINE) :
    list_of_possible_moves = list_moves_REINE (temp_board, i, j);
    break;
    case (ROI) :
    list_of_possible_moves = list_moves_ROI (temp_board, i, j);
    break;
  default :
    list_of_possible_moves.clear();
    break;
  }

  return list_of_possible_moves;
}

void display_possible_moves (IntList list) {

  for (int i = 0; i < list.size(); i = i+2) {
    fill (206, 206, 206);
    ellipse(list.get(i)*TAILLE_CASE, (9-list.get(i+1))*TAILLE_CASE, TAILLE_CASE/3, TAILLE_CASE/3);
  }
}



void settings() {
  size(TAILLE_CASE*9, TAILLE_CASE*9);
}

void setup () {

  imageMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  textSize(TAILLE_CASE);
  background(BACKGROUND);

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

  // selected_list_of_possible_moves.clear();
  selected_i = 0;
  selected_j = 0;
  current_list_of_possible_moves.clear();

  init_plateau();
  display_plateau();
  display_button();
}

void display_button() {
  fill (255,0,0);
  rect(8*TAILLE_CASE, 8.75*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE/2);
  rect(8*TAILLE_CASE, 0.25*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE/2);
  fill(255);
  textSize(TAILLE_CASE/2);
  text("Set", 8*TAILLE_CASE, 8.75*TAILLE_CASE);
  text("Quit", 8*TAILLE_CASE, 0.25*TAILLE_CASE);
}

void draw () {
  display_timer();
  if (status != PLAYING) {
    display_msg();
  }
}

void display_timer() {
  if (status == PLAYING || status == PROMOTING) {
    switch (active_player) {
    case BLANC :
      timer_blanc -= float(millis()-time_last_display)/1000;
      break;
    case NOIR :
      timer_noir -= float(millis()-time_last_display)/1000;
      break;
    }
    time_last_display = millis();

    fill (255);
    rect(TAILLE_CASE, 8.75*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE/2);
    rect(TAILLE_CASE, 0.25*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE/2);

    if (status == PLAYING || status == PROMOTING) {
      fill (COLOR_SELECTED);
      float k = 0.25;
      if (active_player == BLANC) {
        k = 8.75;
      }
      rect(TAILLE_CASE, k*TAILLE_CASE, TAILLE_CASE, TAILLE_CASE/2);
    }

    fill(0);
    textSize(TAILLE_CASE/2);
    text(int(timer_blanc), TAILLE_CASE, 8.75*TAILLE_CASE);
    text(int(timer_noir), TAILLE_CASE, 0.25*TAILLE_CASE);

    if (int(timer_blanc) <= 0 || int(timer_noir) <= 0) {
      status = TIME_OUT;
    }
  }
}

void mousePressed() {
  println("event mousepressed");
  clic_X = mouseX;
  clic_Y = mouseY;

  if (clic_in_board()) {

    if (status == PLAYING) {
      switch (clic_step) {
      case WAITING :
        make_selecting();
        break;
      case SELECTED :
        make_targeting();
        break;
      }
    }
  } else {
    option_X = convert_clic_to_board(clic_X);
    option_Y = convert_clic_to_board(clic_Y);

    if (status == PROMOTING) {
      make_promotion();
    }
  }
  if (status == WAITING) {
    status = PLAYING;
    time_last_display = millis();
  }
  println("fin MousePressed");
  print_plateau(plateau);
  display_plateau();
}


void make_selecting() {
  println("make_selecting");
  print_plateau(plateau);

  selected_i = convert_clic_to_board(clic_X);
  selected_j = 9-convert_clic_to_board(clic_Y);

  if (plateau[selected_i][selected_j][COLOR] == active_player) {
    current_list_of_possible_moves = make_list_possible_moves (plateau, selected_i, selected_j);
    println("liste coups possible créées : ", current_list_of_possible_moves);
    println("case selectionnée contient ", plateau[selected_i][selected_j][PIECE], ",", plateau[selected_i][selected_j][COLOR]);
    current_list_of_possible_moves = verifie_list_possible_moves(plateau, selected_i, selected_j, current_list_of_possible_moves);
    println("liste coups possibles nettoyée : ", current_list_of_possible_moves);
    println("case selectionnée contient ", plateau[selected_i][selected_j][PIECE], ",", plateau[selected_i][selected_j][COLOR]);

    clic_step = SELECTED;
  } else {
    selected_i = 0;
    selected_j = 0;
  }
}

void make_targeting() {

  println("make_targeting");

  int k = convert_clic_to_board(clic_X);
  int l = 9-convert_clic_to_board(clic_Y);

  if (is_move_in_list (current_list_of_possible_moves, k, l)) {
    make_move (selected_i, selected_j, k, l);
  }
  clic_step = WAITING;
  current_list_of_possible_moves.clear();
  selected_i = 0;
  selected_j = 0;
}



boolean is_move_in_list (IntList list, int i, int j) {
  boolean answer = false;
  for (int k = 0; k < list.size(); k = k+2) {
    if ((list.get(k) == i) && (list.get(k+1) == j)) {
      answer = true;
    }
  }
  return answer;
}


void make_move (int i, int j, int k, int l) {
  println("make_move pour ", i, ",", j, " to ", k, ",", l);
  history_of_moves.append(i);
  history_of_moves.append(j);
  history_of_moves.append(k);
  history_of_moves.append(l);
  plateau[k][l][PIECE] = plateau[i][j][PIECE];
  plateau[k][l][COLOR] = plateau[i][j][COLOR];
  plateau[i][j][PIECE] = VIDE;
  plateau[i][j][COLOR] = VIDE;

  if ((plateau[k][l][PIECE] == PION) && (l==8 || l==1)) {
    display_promotion();
    status = PROMOTING;
  } else {
    change_active_player();
  }

  // test echec et nombre de coups

  if (count_possible_moves (active_player, plateau) == 0) {
    if (verifie_echec(plateau, active_player)) {
      status = MAT;
    } else {
      status = PAT;
    }
  }
}

void change_active_player() {
  if (active_player == BLANC) {
    active_player = NOIR;
  } else {
    active_player = BLANC;
  }
}

void display_promotion() {
  switch (active_player) {
  case NOIR:
    fill(255);
    rect(4.5*TAILLE_CASE, 8.75*TAILLE_CASE, 4*TAILLE_CASE, TAILLE_CASE/2);
    image(reine_n, 3*TAILLE_CASE, 8.75*TAILLE_CASE, TAILLE_CASE/2, TAILLE_CASE/2);
    image(tour_n, 4*TAILLE_CASE, 8.75*TAILLE_CASE, TAILLE_CASE/2, TAILLE_CASE/2);
    image(fou_n, 5*TAILLE_CASE, 8.75*TAILLE_CASE, TAILLE_CASE/2, TAILLE_CASE/2);
    image(cavalier_n, 6*TAILLE_CASE, 8.75*TAILLE_CASE, TAILLE_CASE/2, TAILLE_CASE/2);
    break;
  case BLANC :
    fill(0);
    rect(4.5*TAILLE_CASE, 0.25*TAILLE_CASE, 4*TAILLE_CASE, TAILLE_CASE/2);
    image(reine_b, 3*TAILLE_CASE, 0.25*TAILLE_CASE, TAILLE_CASE/2, TAILLE_CASE/2);
    image(tour_b, 4*TAILLE_CASE, 0.25*TAILLE_CASE, TAILLE_CASE/2, TAILLE_CASE/2);
    image(fou_b, 5*TAILLE_CASE, 0.25*TAILLE_CASE, TAILLE_CASE/2, TAILLE_CASE/2);
    image(cavalier_b, 6*TAILLE_CASE, 0.25*TAILLE_CASE, TAILLE_CASE/2, TAILLE_CASE/2);
    break;

    // ajouter le choix de la pièce à promouvoir par clic
    // remplacer pion concerné par pièce choisie
    // trouver un moyen de l'intégrer à l'historique
    // effacer sur l'écran la zone de choix pour la promotion
  }
}

void make_promotion() {

  int i = history_of_moves.get(history_of_moves.size()-2);
  int j = history_of_moves.get(history_of_moves.size()-1);
  int choice = VIDE;

  if ((active_player == BLANC && option_Y == 1) || (active_player == NOIR && option_Y == 9)) {
    switch (option_X) {
    case 3 :
      choice = REINE;
      break;
    case 4 :
      choice = TOUR;
      break;
    case 5 :
      choice = FOU;
      break;
    case 6 :
      choice = CAVALIER;
      break;
    }
    if (choice != VIDE) {
      plateau[i][j][PIECE] = choice;
      history_of_moves.append(choice);
      history_of_moves.append(active_player);
      history_of_moves.append(i);
      history_of_moves.append(j);
      status = PLAYING;
      change_active_player();
      fill(BACKGROUND);
      rect(4.5*TAILLE_CASE, 0.25*TAILLE_CASE, 4*TAILLE_CASE, TAILLE_CASE/2);
      rect(4.5*TAILLE_CASE, 8.75*TAILLE_CASE, 4*TAILLE_CASE, TAILLE_CASE/2);
    }
  }
}

boolean clic_in_board() {
  return ((mouseX > TAILLE_CASE/2) && (mouseX < TAILLE_CASE*8.5) && (mouseY > TAILLE_CASE/2) && (mouseY < TAILLE_CASE*8.5));
}

int convert_clic_to_board (int clic_position) {
  return (1+(clic_position - TAILLE_CASE/2)/TAILLE_CASE);
}

int[][][] copy_board (int[][][] board) {
  int a = board.length;
  int b = board[0].length;
  int c = board[0][0].length;

  int[][][] copy = new int[a][b][c];

  for (int i = 0; i < a; i++) {
    for (int j = 0; j < b; j++) {
      for (int k = 0; k < c; k++) {
        copy[i][j][k] = board[i][j][k];
      }
    }
  }
  return copy;
}
