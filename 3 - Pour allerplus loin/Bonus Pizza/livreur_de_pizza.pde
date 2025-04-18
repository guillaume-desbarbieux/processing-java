int[] stock_pizza = { 13, 11, 8, 7, 5, 3, 0};
int recettes = 0;

void setup() {

println("Vous partez avec ",stock_pizza[0]," pizzas ");

int pizza_vendues = 0 ;

for (int i = 1 ; i< stock_pizza.length ; i++) {

pizza_vendues = stock_pizza[i-1] - stock_pizza[i];
print("Vous avez déposé ",pizza_vendues," pizzas ");

int prix = get_prix (pizza_vendues);
println("pour un prix de ",prix,"euros");

recettes += prix;
}

println("Cette tournée vous a rapporté ",recettes,"euros");
}

int get_prix (int quantité) {
int total = 10 * quantité;
if (quantité < 3) {
total += 3;
}
return total;

}
