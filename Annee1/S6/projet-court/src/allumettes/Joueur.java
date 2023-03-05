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
	
	public String getStrategieString() {
		return strategie.getStratName();
	}
	
	public Joueur(String nom, String strategie) {
		this.nom = nom;
        switch (strategie) {
            case "naif":
                this.strategie = new StratNaif();
                break;
            case "rapide":
            	this.strategie = new StratRapide();
                break;
            // case "expert":
            	// this.strategie = StratExpert;
                // break;
            case "humain":
            	this.strategie = new StratHumain();
            	break;
            // case "tricheur":
            	// this.strategie = StratTricheur;
            default:
                throw new ConfigurationException("Stratégie inconnue : " + strategie);
	        
	    }
	}
	
}
