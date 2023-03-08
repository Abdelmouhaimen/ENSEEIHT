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

	@Override
	public boolean EstFini() {
		return this.jeuReel.EstFini();
	}

	@Override
	public void setFini() {
		this.jeuReel.setFini();

	}

}

