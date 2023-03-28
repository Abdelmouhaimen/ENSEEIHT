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
            Jeu jeuReel = new JeuReel(nb_alumettes_initial);
            
            // verifier que l'argument -confiant existe s'il y a 3 arguments
            if ((args.length == 3) && (!args[0].toLowerCase().equals("-confiant"))) {
            	throw new ConfigurationException("Arguments invalides");
            }
            
            // Initialiser les joueurs
            Joueur[] joueurs = new Joueur[2];
            int j = args.length == 3 ? 1 : 0;
            for (int i = 0; i < 2; i++) {
            	String[] joueurArgs = args[i+j].split("@");
            	if (joueurArgs.length != 2) {
            		throw new ConfigurationException("Arguments invalides");
            	}
                String nom = joueurArgs[0];
                String strategie = joueurArgs[1];
                Strategie strat;
                switch (strategie.toLowerCase()) {
                case "naif":
                	strat = new StratNaif();
                    break;
                case "rapide":
                	strat = new StratRapide();
                    break;
                case "expert":
                	strat = new StratExpert();
                    break;
                case "humain":
                	strat = new StratHumain();
                	break;
                case "tricheur":
                	strat = new StratTricheur();
                	break;
                default:
                    throw new ConfigurationException("Stratégie inconnue : " + strategie);
    	    }
                joueurs[i] = new Joueur(nom, strat);
            }


            // Initialiser l'arbitre
            Arbitre arbitre = new Arbitre(joueurs[0], joueurs[1]);
            if (args.length == 3) {
            		arbitre.setConfiant(true);
            }

            // Lancer le jeu
            arbitre.arbitrer(jeuReel);


			

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
