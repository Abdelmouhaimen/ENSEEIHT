package allumettes;
import java.util.Random;

public class StratTricheur implements Strategie {
	private String StratName = "tricheur";


	@Override
	public int getPrise(Jeu jeu, String nom) {
		return 1;
	}

	@Override
	public String getStratName() {
		return StratName;
	}

}
