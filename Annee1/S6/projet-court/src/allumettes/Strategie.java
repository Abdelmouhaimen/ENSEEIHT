package allumettes;

public interface Strategie {

	/**
	 * Renvoie la prise choisie par la stratégie pour un jeu donné et un joueur donné.
	 * 
	 * @param jeu le jeu pour lequel la prise doit être choisie
	 * @param nom le nom du joueur qui doit choisir sa prise
	 * @return la prise choisie par la stratégie
	 */
	public int getPrise(Jeu jeu, String nom);

}
