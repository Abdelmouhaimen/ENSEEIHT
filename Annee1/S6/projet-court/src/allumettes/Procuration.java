package allumettes;

public class Procuration implements Jeu {
	
	private Jeu jeuReel;
	
	public Procuration(Jeu jeuReel2) {
		this.jeuReel = jeuReel2;
	}

	@Override
	public int getNombreAllumettes() {
		return this.jeuReel.getNombreAllumettes();
	}

	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		throw new OperationInterditeException("Triche !");

	}

	public boolean EstFini() {
		return ((JeuReel)this.jeuReel).EstFini();
	}

	public void setFini() {
		((JeuReel)this.jeuReel).setFini();

	}

}

