String mot_a_deviner = "oiseau";
int nb_lettres_trouvees = 0;
int nb_tentatives = 0;
int nb_dans_le_mot = 0;

void setup() {
  char[] tableau_reponse = mot_a_deviner.toCharArray();
  char[] tableau_cache = cache_reponse (tableau_reponse);

  while ((nb_lettres_trouvees < tableau_reponse.length) && (nb_tentatives<10)) {

    display(tableau_cache);
    println("Il vous reste ", 10-nb_tentatives, " tentatives");
    println("");

    char lettre_utilisateur = javax.swing.JOptionPane.showInputDialog(null,
      "Tapez une lettre ?").charAt(0);

    println("Vous proposez la lettre ", lettre_utilisateur);

    nb_dans_le_mot = 0;

    tableau_cache = verifie_reponse(lettre_utilisateur, tableau_cache, tableau_reponse);

    if (nb_dans_le_mot > 0 ) {
      println("Bravo, cette lettre est présente ", nb_dans_le_mot, " fois dans le mot.");
      nb_lettres_trouvees += nb_dans_le_mot;
      
    } else if (nb_dans_le_mot == 0) {
      println("Cette lettre n'est pas présente dans le mot.");
      nb_tentatives++;
    } else {
      println("Vous avez déjà proposé cette lettre.");
    }
  }

  if (nb_tentatives == 10) {
    println("Dommage, vous avez atteint le nombre limite de propositions");
  } else {
    println("Félicitations, vous avez trouvé le mot ", mot_a_deviner, " avec ", nb_tentatives, " tentatives ratées.");
  }
}


char[] cache_reponse (char[] tableau) {

  char[] tableau_cache = new char[tableau.length];
  for (int i = 0; i < tableau.length; i++) {
    tableau_cache[i] = '_';
  }
  return tableau_cache;
}

void display (char[] tableau) {
  println("");
  println("Vous cherchez le mot :");
  for (int i = 0; i < tableau.length; i++) {
    print(tableau[i]);
  }
  println("");
  println("");
}

char[] verifie_reponse (char lettre, char[] tableau_cache, char[] tableau_reponse) {
  for (int i = 0; i < tableau_reponse.length; i++) {
    if (tableau_cache[i] == lettre) {
      nb_dans_le_mot = -1;
      i=tableau_reponse.length;
    } else if (tableau_reponse[i] == lettre){
      tableau_cache[i] = lettre;
      nb_dans_le_mot ++;
    }
  }
  return tableau_cache;
}
