package allumettes;
import java.util.Random;

public class StratNaif implements Strategie {
	private String StratName = "naif";


	@Override
	public int getPrise(Jeu jeu, String nom) {
		Random rand = new Random(); 
		int upperbound = Jeu.PRISE_MAX-1;
		return rand.nextInt(upperbound) + 1;
	}

	@Override
	public String getStratName() {
		return StratName;
	}

}
