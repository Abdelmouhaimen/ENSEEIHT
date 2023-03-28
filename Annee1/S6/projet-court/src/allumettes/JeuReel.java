package allumettes;

public class JeuReel implements Jeu {
	private int nb_alumettes;
	private boolean fini;
	
	public JeuReel(int nbAlumettesInitial) {
		nb_alumettes = nbAlumettesInitial;
	}

	@Override
	public int getNombreAllumettes() {
		return nb_alumettes;
	}

	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		if (nbPrises > nb_alumettes) {
			throw new CoupInvalideException(nbPrises, "(> " + nb_alumettes + ")");
		} else if (nbPrises > PRISE_MAX) {
			throw new CoupInvalideException(nbPrises, "(> " + PRISE_MAX + ")");
		} else if (nbPrises <= 0) {
			throw new CoupInvalideException(nbPrises, "(< 1)");
		}  else {
			nb_alumettes -= nbPrises;
		}
	}

	public boolean EstFini() {
		return fini;
	}

	public String toString() {
		return "Allumettes restantes : " + nb_alumettes;
	}

	public void setFini() {
		fini = true;
		
	}
}
