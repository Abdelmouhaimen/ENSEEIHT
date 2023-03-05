package allumettes;

public interface Strategie {

	public int getPrise(Jeu jeu, String nom);
	
	public String getStratName();
}
