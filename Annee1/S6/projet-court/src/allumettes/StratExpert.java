package allumettes;

import java.util.Random;


public class StratExpert implements Strategie {
	
	@Override
	public int getPrise(Jeu jeu, String nom) {
		int prise;
		final int nbAllumettes = jeu.getNombreAllumettes();
		if (nbAllumettes == 1) {
			prise = 1;
		} else if ((nbAllumettes-1) % 4 == 1) {
			prise = 1;
		} else if ((nbAllumettes-1) % 4 == 2) {
			prise = 2;
		} else if ((nbAllumettes-1) % 4 == 3) {
			prise = 3;
		} else {
			Random rand = new Random(); 
			int upperbound = Jeu.PRISE_MAX-1;
			prise = rand.nextInt(upperbound) + 1;
		}
		return prise;
	}


}
