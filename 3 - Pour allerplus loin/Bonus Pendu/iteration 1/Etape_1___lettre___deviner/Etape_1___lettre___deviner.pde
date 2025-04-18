char lettre_a_deviner = 'k';
boolean play = false;
boolean success = false;

void setup() {
  println("Tapez une lettre");
}

void draw() {
  if (!success) {
    if (play) {
      play = false;
      int touche = key;
      println("");
      println("Vous proposez la lettre ",(char)touche);
      verifie_touche(touche);
    }
  } else {
    println("La partie est terminée !");
    noLoop();
  }
}

void keyPressed() {
  play = true;
}

void verifie_touche (int touche) {
  if (touche==lettre_a_deviner) {
    success = true;
    println("Bravo !");
  } else {
    println("Ce n'est pas la bonne réponse, esayez encore !");
  }  
}
