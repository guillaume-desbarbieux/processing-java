char lettre_a_deviner = 'k';
boolean success = false;

void setup() {

  while (!success) {
    char lettre_utilisateur = javax.swing.JOptionPane.showInputDialog(null,
      "Tapez une lettre ?").charAt(0);
      
    println("Vous proposez la lettre ", lettre_utilisateur);
    
    if (lettre_utilisateur == lettre_a_deviner) {
      success = true;
      println("Bravo, vous avez gagné");
    } else {
      
      println("Ce n'est pas la bonne réponse");
    }
  }
}
