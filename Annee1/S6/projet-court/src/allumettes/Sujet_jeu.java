package allumettes;

public class Sujet_jeu implements Jeu {
	private int nb_alumettes;
	
	@Override
	public int getNombreAllumettes() {
		return nb_alumettes;
	}

	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		nb_alumettes -= nbPrises;
	}

}
