package allumettes;

/**

Classe qui représente un arbitre de jeu d'allumettes.
Elle permet de gérer une partie entre deux joueurs,
en s'assurant que les coups sont valides et que les joueurs jouent à tour de rôle.
*/
public class Arbitre {
	
	private boolean confiant;
	Joueur[] joueurs = new Joueur[2];
	private Joueur joueurCourant;

	/**
	 * Arbitre un seul coup de la partie, en vérifiant que le coup est valide et que le joueur respecte les règles.
	 * Si le joueur triche, la partie se termine et le joueur qui n'a pas triché gagne.
	 * @param jeuReel le jeu d'allumettes sur lequel on arbitre le coup.
	 */
	public void arbitrerUnSeulCoup(JeuReel jeuReel) {
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
	        	System.out.println(joueurCourant.getNom() + " prend " + prise + (prise > 1 ? " allumettes.": " allumette."));
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

	/**
	 * Arbitre une partie complète de jeu d'allumettes entre deux joueurs.
	 * @param jeuReel le jeu d'allumettes sur lequel on arbitre la partie.
	 */
	public void arbitrer(Jeu jeuReel) {
		// Lancer le jeu
	    while (!((JeuReel) jeuReel).EstFini()) {
	        System.out.println(jeuReel);
	        this.arbitrerUnSeulCoup((JeuReel) jeuReel);
	        if (!((JeuReel) jeuReel).EstFini()) {
	        	System.out.println();
	        }
	    }
	}

	/**
	 * Change le joueur courant pour le joueur suivant dans la liste des joueurs.
	 */
	private void changerJoueur() {
		if (joueurCourant == joueurs[0]) {
				joueurCourant = joueurs[1];
		}
		else {
			joueurCourant = joueurs[0];
		}
		
	}



	/**
	 * Définit si l'arbitre est confiant ou non.
	 * Si l'arbitre est confiant, il permet au joueur courant de manipuler directement le jeu réel.
	 * Sinon, l'arbitre utilise un objet Procuration pour simuler le jeu.
	 * @param confiant true si l'arbitre est confiant, false sinon.
	 */
	public void setConfiant(boolean confiant) {
	    this.confiant = confiant;
	}
		
	/**
	 * Initialise une instance d'Arbitre avec deux joueurs et un jeu.
	 * Le premier joueur est désigné comme joueur courant.
	 * L'arbitre est initialisé comme non confiant.
	 * @param j1 le premier joueur
	 * @param j2 le deuxième joueur
	 */
	public Arbitre(Joueur j1, Joueur j2) {
	    confiant = false;
	    joueurs[0] = j1;
	    joueurs[1] = j2;
	    joueurCourant = j1;
	}



}
