package allumettes;

public class Arbitre {
	
	private Jeu jeu;
	private boolean confiant;
	Joueur[] joueurs = new Joueur[2];
	private Joueur joueurCourant;
	
	public void arbitrer(JeuReel jeuReel) {
		Jeu procuration = new Procuration(jeuReel);
		int prise = 0;
		boolean Abondon = false;
		try {
			if (confiant) {
				prise = joueurCourant.getPrise(jeuReel);
			} else {
				prise = joueurCourant.getPrise(procuration);
			}
		} catch (OperationInterditeException e) {
			Abondon = true;
		}
		if (Abondon) {
			jeuReel.setFini();
			System.out.print("Abandon de la partie car " + joueurCourant.getNom() + " triche !");
		}
		else {
	        try {
	        	System.out.println(joueurCourant.getNom() + " prend " + prise + " allumette(s).");
	        	jeuReel.retirer(prise);
	        } catch (CoupInvalideException e) {
	            System.out.println("Impossible ! Nombre invalide : " + e.getCoup() + " " + e.getProbleme());
	            this.changerJoueur();
	        }
	        
	        if (jeuReel.getNombreAllumettes() == 0) {
	        	System.out.println();
	        	System.out.println(joueurCourant.getNom() + " perd !");
	        	this.changerJoueur();
	        	System.out.println(joueurCourant.getNom() + " gagne !");
	        	jeuReel.setFini();
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


}
