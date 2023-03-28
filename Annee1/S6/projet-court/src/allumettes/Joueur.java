package allumettes;

public class Joueur {
	private String nom;
	private Strategie strategie;
	
	public String getNom() {
		return nom;
	}

	public int getPrise(Jeu jeu) {
		return strategie.getPrise(jeu, nom);
	}
	
	public Joueur(String nom, Strategie strategie) {
		this.nom = nom;
       	this.strategie = strategie;

	}
	
}
