package allumettes;

public class Joueur {
	/**
	 * Nom du joueur
	 */
	private String nom;

	/**
	 * Stratégie du joueur pour jouer
	 */
	private Strategie strategie;

	/**
	 * Obtient le nom du joueur.
	 * @return le nom du joueur
	 */
	public String getNom() {
		return nom;
	}

	/**
	 * Obtient le nombre d'allumettes que le joueur veut prendre selon sa stratégie.
	 * @param jeu le jeu dans lequel le joueur doit jouer
	 * @return le nombre d'allumettes que le joueur veut prendre
	 */
	public int getPrise(Jeu jeu) {
		return strategie.getPrise(jeu, nom);
	}

	/**
	 * Initialise un joueur avec un nom et une stratégie.
	 * @param nom le nom du joueur
	 * @param strategie la stratégie du joueur
	 */
	public Joueur(String nom, Strategie strategie) {
		this.nom = nom;
	   	this.strategie = strategie;
	}
}
