package allumettes;

public class Arbitre {
	
	private Jeu jeu;
	private boolean confiant;
	private Joueur current_player;
	
	public void arbitrer(Jeu jeu) {
		
		try {
		jeu.retirer(current_player.getPrise(jeu));
		}
		catch( CoupInvalideException e ) {
			;
		}
	}
	
	public void setConfiant(boolean confiant) {
		this.confiant = confiant;
	}
	
	public Arbitre(Joueur j1, Joueur j2) {
		
	}
}
