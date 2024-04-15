# K-Means

## Aperçu

Cette application effectue un clustering K-Means sur une image d'entrée en utilisant à la fois l'implémentation intégrée d'OpenCV et une implémentation personnalisée. Elle évalue les résultats du clustering à l'aide des métriques de Précision (P), Sensibilité (S), et Coefficient de Similarité de Dice (DSC).

## Utilisation

- Compilez le code en utilisant la commande suivante dans le dossier Build:

./bin/kmeans ../data/images/texture<Numero_d'image>.png <K_num_of_clusters> ../data/images/texture<Numero_d'image>_VT.png

- Remplacez `<Numero_d'image>` par le numero image d'entrée, `<K_num_of_clusters>` par le nombre de clusters souhaité pour K-Means.



## Sortie

L'application affiche les sorties suivantes :

- Le résultat de clustering en utilisant l'implémentation d'OpenCV (`kmeans_opencv` fenêtre).
- Le résultat de clustering en utilisant l'implémentation personnalisée (`kmeans` fenêtre).
- Si une image de segmentation de vérité terrain est fournie, elle affichera également :
  - La segmentation de vérité terrain (`sol` fenêtre).
  - Veuillez Chosir si vouz voulez inverser la classification de kmeans_perso ("o" pour inverser la classification)
  - Veuillez Chosir si vouz voulez inverser la classification de kmeans OpenCV ("o" pour inverser la classification)
- Les résultats d'évaluation pour les implémentations personnalisées et d'OpenCV, y compris la Précision (P), la Sensibilité (S), et le Coefficient de Similarité de Dice (DSC).


