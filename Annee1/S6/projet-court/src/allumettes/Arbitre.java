package allumettes;

public class Arbitre {
	
	private Jeu jeu;
	private boolean confiant;
	Joueur[] joueurs = new Joueur[2];
	private Joueur joueurCourant;
	
	public void arbitrer(Jeu jeu) {
		int prise = this.nombrePrise(jeu);
		boolean Abondon = prise == -1;
		if (Abondon) {
			jeu.setFini();
		}
		else {
	        try {
	        	System.out.println(joueurCourant.getNom() + " prend " + prise + " allumette(s).");
	            jeu.retirer(prise);
	        } catch (CoupInvalideException e) {
	            System.out.println("Impossible ! Nombre invalide : " + e.getCoup() + " " + e.getProbleme());
	            this.changerJoueur();
	        }
	        
	        if (jeu.getNombreAllumettes() == 0) {
	        	System.out.println();
	        	System.out.println(joueurCourant.getNom() + " perd !");
	        	this.changerJoueur();
	        	System.out.println(joueurCourant.getNom() + " gagne !");
	        	jeu.setFini();
	        }
	        this.changerJoueur();
		}
	}
	
	private void changerJoueur() {
		if (joueurCourant.getNom() == joueurs[0].getNom()) {
				joueurCourant = joueurs[1];
		}
		else {
			joueurCourant = joueurs[0];
		}
		
	}

	public void setConfiant(boolean confiant) {
		this.confiant = confiant;
	}
	
	public Arbitre(Joueur j1, Joueur j2) {
		confiant = false;
		joueurs[0] = j1;
		joueurs[1] = j2;
		joueurCourant = j1;
	}

	public int nombrePrise(Jeu jeu) {
		String strategie = joueurCourant.getStrategieString();
		int prise;
		switch (strategie) {
        case "humain":
        	prise = joueurCourant.getPrise(jeu);
        	if (prise  == -1) {
        		if (confiant) {
	        		this.tricher(jeu);
	        		prise = nombrePrise(jeu);
        		}
        		else {
        			System.out.print("Abandon de la partie car " + joueurCourant.getNom() + " triche !");
        			return -1;
        		}
        	}
        	break;
        // case "tricheur":
        	// this.strategie = StratTricheur;
        default:
        	prise = joueurCourant.getPrise(jeu);
		}		
		return prise;
	}

	private void tricher(Jeu jeu) {
		int nbTriche = 1;
		try { 
			jeu.retirer(nbTriche);
		}
		catch (CoupInvalideException e) {
			System.out.println("Impossible !");
		}
		
		System.out.println("[Une allumette en moins, plus que "+ jeu.getNombreAllumettes() +". Chut !]");
		
	}


}
