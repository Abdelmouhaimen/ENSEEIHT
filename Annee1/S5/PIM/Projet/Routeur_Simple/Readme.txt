Voici comment lancer le programme avec cet exemple:



Compilez votre application en utilisant un compilateur Ada. Vous pouvez utiliser la commande suivante pour compiler ce programme avec gnat:


gnatmake routeur_simple.adb
Cela va créer un fichier exécutable nommé "routeur_simple" dans le répertoire courant.

Exécutez le programme compilée en utilisant un interpréteur Ada. Vous pouvez utiliser la commande suivante pour exécuter l'application avec gnat:

./routeur_simple
Voici un exemple de ce à quoi pourrait ressembler l'exécution du programme avec des arguments de ligne de commande:


./routeur_simple -c 15 -P LFU -S -t tableau.txt -p paquets.txt -r resultats.txt
Dans cet exemple, l'application est exécutée avec les options suivantes:

La taille du cache est définie sur 15 (A venir)
La politique de cache est définie sur LFU (A venir)
Les statistiques seront affichées (A venir)
Le nom du fichier de table de routage est défini sur "tableau.txt"
Le nom du fichier de paquets est défini sur "paquets.txt"
Le nom du fichier de résultats est défini sur "resultats.txt"
