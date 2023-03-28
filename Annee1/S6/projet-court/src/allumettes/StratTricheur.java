package allumettes;

public class StratTricheur implements Strategie {



	@Override
	public int getPrise(Jeu jeu, String nom) {
		tricherTricheur(jeu);
		return 1;
	}

	
	
	private void tricherTricheur(Jeu jeu) {
		final int nbRestant = 2;
		try {
			System.out.println("[Je triche...]");
			while (jeu.getNombreAllumettes() > 2) {
				jeu.retirer(Math.min(3, jeu.getNombreAllumettes()-nbRestant));
			}
		}
		catch (CoupInvalideException e) {
			System.out.println("Impossible !");
		}
		
		
		System.out.println("[Allumettes restantes : " + jeu.getNombreAllumettes() + "]");
		
		
	}
}
