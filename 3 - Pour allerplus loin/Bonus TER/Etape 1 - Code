final int AGE = 4;
final String[] LISTE_CARTES = {"Aucune", "Jeunes", "Liberté", "Autocars", "Solidaire", "Mobilité", "Sureté"};
final String CARTE = LISTE_CARTES[0];
final String JOUR = "Lundi";
final float PRIX_DE_BASE = 10;


void setup () {
  float temp_prix = 0;
  temp_prix = calcule_prix (PRIX_DE_BASE, AGE, JOUR, CARTE);
  println(temp_prix);
}

float calcule_prix (float temp_prix, int temp_age, String temp_jour, String temp_carte) {

  float reduction_totale = reduction_carte (temp_carte, temp_jour) * reduction_age (temp_age);

  return temp_prix * reduction_totale;
}



float reduction_carte (String temp_carte, String temp_jour) {
  float temp_reduction = 1;
  switch (temp_carte) {
  case "Sureté" :
    temp_reduction = 0;
    break;
  case "Mobilité" :
    temp_reduction = 0.1;
    break;
  case "Solidaire" :
    temp_reduction = 0.25;
    break;
  case "Autocars" :
    temp_reduction = 0.7;
    break;
  case "Jeunes" :
    temp_reduction = 0.5;
    break;
  case "Liberté" :
    temp_reduction = 0.25;
    if (is_WE (temp_jour)) {
      temp_reduction = 0.5;
    }
    break;
  }
  return temp_reduction;
}



float reduction_age (int temp_age) {
  float temp_reduction = 1;
  if (temp_age < 4) {
    temp_reduction = 0;
  } else if (temp_age < 12) {
    temp_reduction = 0.5;
  }
  return temp_reduction;
}



boolean is_WE (String temp_jour) {
  return (temp_jour == "Samedi" || temp_jour == "Dimanche");
}
