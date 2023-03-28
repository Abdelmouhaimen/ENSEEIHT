package allumettes;


public class StratRapide implements Strategie {

	
	@Override
	public int getPrise(Jeu jeu, String nom) {
		return Math.min(Jeu.PRISE_MAX, jeu.getNombreAllumettes());
	}


}
