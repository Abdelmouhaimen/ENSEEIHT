package allumettes;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Jouer {
	
	static final int nb_alumettes_initial = 13;

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		try {
			verifierNombreArguments(args);
			 // Initialiser le jeu
            Jeu jeu = new Sujet_jeu(nb_alumettes_initial);

            // Initialiser les joueurs
            Joueur[] joueurs = new Joueur[2];
            int j = 0;
            if (args.length == 3) {
            	if (args[0].toLowerCase().equals("-confiant")) {
            		j = 1;
            	} else {
            		throw new ConfigurationException("Arguments invalides");
            	}
            }
            for (int i = 0; i < 2; i++) {
                String[] joueurArgs = args[i+j].split("@");
                String nom = joueurArgs[0];
                String strategie = joueurArgs[1];
                joueurs[i] = new Joueur(nom, strategie.toLowerCase());
            }

            // Initialiser l'arbitre
            Arbitre arbitre = new Arbitre(joueurs[0], joueurs[1]);
            if (args.length == 3) {
            	if (args[0].toLowerCase().equals("-confiant")) {
            		arbitre.setConfiant(true);
            	} else {
            		throw new ConfigurationException("Arguments invalides");
            	}
            }

            // Lancer le jeu
            while (!jeu.EstFini()) {
                System.out.println(jeu);
                arbitre.arbitrer(jeu);
                if (!jeu.EstFini()) {
                	System.out.println();
                }
            }

			

		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}
		
	}



	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}
	
	

}
