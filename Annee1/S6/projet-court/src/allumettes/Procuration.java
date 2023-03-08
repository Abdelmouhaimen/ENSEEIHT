package allumettes;

public class Procuration implements Jeu {
	
	private JeuReel jeuReel;
	
	public Procuration(JeuReel jeu) {
		this.jeuReel = jeu;
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

