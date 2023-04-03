package allumettes;
import org.junit.*;
import static org.junit.Assert.*;


public class StratRapideTest {
	private Strategie stratRapide;
	private Jeu jeu1;
	private Jeu jeu2;
	
	@Before public void setUp() {
		stratRapide = new StratRapide();
		jeu1 = new JeuReel(1);
		jeu2 = new JeuReel(2);
	}
	
	@Test public void testernbAlumettes_PriseEgale1() {
		assert(stratRapide.getPrise(jeu1, null) == 1);
	}
	
	@Test public void testernbAlumettes_PriseEgale2() {
		assert(stratRapide.getPrise(jeu2, null) == 2);
	}
	
	@Test public void testernbAlumettes_PriseEgale3() {
		for (int i = 3; i <= 13; i++) {
			Jeu jeu = new JeuReel(i);
			assert(stratRapide.getPrise(jeu, null) == 3);
		}
	}
}
