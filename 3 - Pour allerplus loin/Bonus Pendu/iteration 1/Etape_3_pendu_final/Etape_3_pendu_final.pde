String[] DICTIONNAIRE;
String mot_a_deviner;



final String abc = "abcdefghijklmnopqrstuvwxyz";
final char[] alphabet = abc.toCharArray();

final String ABC = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
final char[] ALPHABET = ABC.toCharArray();

char[] lettres_restantes;
char[] tableau_reponse;
char[] tableau_cache;
int nb_lettres_trouvees;
int nb_tentatives_restantes;
int nb_lettres_dans_le_mot;
char lettre_utilisateur;

PImage img1;
PImage img2;
PImage img3;
PImage img4;
PImage img5;
PImage img6;
PImage img7;
PImage img8;
PImage img9;
PImage img10;
PImage img11;
PImage img12;
PImage img13;
PImage img14;
PImage img15;
PImage img16;
PImage fin;


void setup() {
  size(500, 500);
  img1 = loadImage("1.png");
  img2 = loadImage("2.png");
  img3 = loadImage("3.png");
  img4 = loadImage("4.png");
  img5 = loadImage("5.png");
  img6 = loadImage("6.png");
  img7 = loadImage("7.png");
  img8 = loadImage("8.png");
  img9 = loadImage("9.png");
  img10 = loadImage("10.png");
  img11 = loadImage("11.png");
  img12 = loadImage("12.png");
  img13 = loadImage("13.png");
  img14 = loadImage("14.png");
  img15 = loadImage("15.png");
  img16 = loadImage("16.png");
  fin = loadImage("fin.png");

  init_game();
}




void init_game() {

  DICTIONNAIRE = loadStrings("mots.txt");
  mot_a_deviner = DICTIONNAIRE[int(random(DICTIONNAIRE.length))];
  lettres_restantes = ALPHABET;
  tableau_reponse = mot_a_deviner.toCharArray();
  init_tableau_cache ();
  nb_tentatives_restantes = tableau_reponse.length + 3;
  nb_lettres_trouvees = 0;
  nb_lettres_dans_le_mot = 0;
  display_pendu();
}

void init_tableau_cache () {
  tableau_cache = new char[tableau_reponse.length];

  for (int i = 0; i < tableau_reponse.length; i++) {
    tableau_cache[i] = '_';
  }
}

void draw() {

  if ((nb_lettres_trouvees < tableau_reponse.length) && (nb_tentatives_restantes > 0)) {

    display();

    lettre_utilisateur = javax.swing.JOptionPane.showInputDialog(null,
      "Tapez une lettre ?").charAt(0);

    int index_lettre_utilisateur = index(lettre_utilisateur);

    if (index_lettre_utilisateur < 0 ) {
      display_erreur(lettre_utilisateur);
    } else {
      traite_reponse (index_lettre_utilisateur);
    }
  }

  if (nb_tentatives_restantes < 0) {
    println("Dommage, vous avez atteint le nombre limite de propositions");
    println("Il fallait trouver le mot ", mot_a_deviner);
    noLoop();
  }
  if (nb_lettres_trouvees == tableau_reponse.length) {
    println("Félicitations, vous avez trouvé le mot ", mot_a_deviner);
    noLoop();
  }
}


void display () {

  println("");
  println("Vous cherchez le mot :");
  for (int i = 0; i < tableau_cache.length; i++) {
    print(tableau_cache[i]);
  }
  println("");
  for (int i = 0; i < lettres_restantes.length; i++) {
    print(lettres_restantes[i], " ");
  }
  println("");
  println("Il vous reste ", nb_tentatives_restantes, " tentatives");
  println("");
  println("");
  println("");
  println("");
  println("");
  println("");
  println("");
  println("");
}

void display_erreur (char lettre) {
  println("Désolé, '", lettre, "' n'est pas une réponse acceptée.");
  println("Utilisez uniquement des caractères sans accents.");
}


int index(char lettre) {
  int answer = -1;
  for (int i = 0; i < 26; i++) {
    if ((alphabet[i]) == lettre || (ALPHABET[i] == lettre)) {
      answer = i;
      lettre_utilisateur = ALPHABET[i];
    }
  }
  return answer;
}





void traite_reponse (int index) {

  nb_lettres_dans_le_mot = 0;

  if (lettres_restantes[index] == ' ') {
    println("Vous avez déjà proposé cette lettre");
  } else {
    lettres_restantes[index] = ' ';


    for (int i = 0; i < tableau_reponse.length; i++) {
      if (tableau_reponse[i] == lettre_utilisateur) {
        tableau_cache[i] = lettre_utilisateur;
        nb_lettres_dans_le_mot ++;
      }
    }

    if (nb_lettres_dans_le_mot > 0 ) {
      println("La lettre ", lettre_utilisateur, " est présente ", nb_lettres_dans_le_mot, " fois.");
      nb_lettres_trouvees += nb_lettres_dans_le_mot;
    } else if (nb_lettres_dans_le_mot == 0) {
      println("La lettre ", lettre_utilisateur, " n'est pas présente.");
      nb_tentatives_restantes--;
      display_pendu();
    }
  }
}

void display_pendu() {
  switch (nb_tentatives_restantes) {
  case 0 :
    image(fin, 0, 0, 500, 500);
    break;
  case 1 :
    image(img16, 0, 0, 500, 500);
    break;
  case 2 :
    image(img15, 0, 0, 500, 500);
    break;
  case 3 :
    image(img14, 0, 0, 500, 500);
    break;
  case 4 :
    image(img13, 0, 0, 500, 500);
    break;
  case 5 :
    image(img12, 0, 0, 500, 500);
    break;
  case 6 :
    image(img11, 0, 0, 500, 500);
    break;
  case 7 :
    image(img10, 0, 0, 500, 500);
    break;
  case 8 :
    image(img9, 0, 0, 500, 500);
    break;
  case 9 :
    image(img8, 0, 0, 500, 500);
    break;
  case 10 :
    image(img7, 0, 0, 500, 500);
    break;
  case 11 :
    image(img6, 0, 0, 500, 500);
    break;
  case 12 :
    image(img5, 0, 0, 500, 500);
    break;
  case 13 :
    image(img4, 0, 0, 500, 500);
    break;
  case 14 :
    image(img3, 0, 0, 500, 500);
    break;
  case 15 :
    image(img2, 0, 0, 500, 500);
    break;
  case 16 :
    image(img1, 0, 0, 500, 500);
    break;
  }
}
