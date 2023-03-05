package allumettes;

import java.util.Scanner;

public class StratHumain implements Strategie {
	private String StratName = "humain";
	
	@Override
	public int getPrise(Jeu jeu, String nom) {

		while (true) {
			try {
				Scanner entree = new Scanner(System.in);  // Create a Scanner object
				System.out.print(nom + ", combien d'allumettes ? ");
			    String input = entree.nextLine();  // Read user input
			    
			    if (input.equals("triche")) {
			    	if (jeu.getNombreAllumettes() < 2) {
			    		System.out.println("[Triche impossible.]");
			    	} else {
			    		this.tricherHumain(jeu);
			    	}
			    }
			    else {
				    int prise = Integer.valueOf(input);
				    if (prise < 0) {
				    	System.out.println("Vous devez donner un entier.");
				    }
				    else {
				    	return prise;
				    }
			    }
			}
			catch (java.lang.NumberFormatException e) {
				System.out.println("Vous devez donner un entier.");
			}
		}
	}

	@Override
	public String getStratName() {
		return StratName;
	}
	
	private void tricherHumain(Jeu jeu) {
		final int nbTriche = 1;
		try { 
			jeu.retirer(nbTriche);
		}
		catch (CoupInvalideException e) {
			System.out.println("Impossible !");
		}
		
		System.out.println("[Une allumette en moins, plus que "+ jeu.getNombreAllumettes() +". Chut !]");
		
	}

}
