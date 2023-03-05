package allumettes;

import java.util.Scanner;

public class StratRapide implements Strategie {
	private String StratName = "rapide";
	
	@Override
	public int getPrise(Jeu jeu, String nom) {
		return Math.min(Jeu.PRISE_MAX, jeu.getNombreAllumettes());
	}

	@Override
	public String getStratName() {
		return StratName;
	}

}
