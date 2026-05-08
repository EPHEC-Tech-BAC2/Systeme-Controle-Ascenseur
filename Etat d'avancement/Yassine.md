## État d’avancement

| Séance | Date | Travail réalisé | Détail |
|--------|------|-----------------|--------|
| 1 | 14/04/2026 | Rédaction du cahier des charges | Définition du projet, des fonctionnalités attendues et des objectifs. |
| 2 | 15/04/2026 | MikroC et de la carte EasyPIC v7 | Démarrage du développement sur PIC18F45K22 et mise en place de la structure de base du programme. |
| 3 | 15/04/2026 | Développement des premières fonctionnalités | Configuration des ports, lecture des entrées analogiques, gestion des boutons d’étage et affichage LCD dynamique. |
| 4 | 21/04/2026 | Implémentation du fonctionnement de l’ascenseur | Développement du code MikroC pour la gestion du mouvement, des 4 étages et de l’affichage sur LCD. |
| 5 | 22/04/2026 | Début du développement sous LabVIEW | Création des événements de l’interface et début de la programmation de la communication pour l’envoi et la réception des données. |
| 6 | 22/04/2026 | Câblage et intégration des fonctions de communication | Mise en place d’une partie du câblage et début de l’intégration des commandes d’envoi et de réception. |


## Avancement hors séances
- Implémentation complète des événements LabVIEW (25 events)
- Mise en place des shift registers : VISA session, Urgence active, Mode Auto/Manu, Table Historique, Compteur trajets, DIR précédente, Étage départ, Temps départ, Trame TX et Trame RX
- Traitement dans le timeout : parsing de la trame DATA, mise à jour des graphiques et de l’historique des trajets, détection départ/arrivée, calcul de la durée et construction d’un tableau à 5 colonnes
- Création de quatre sous-VIs :
  - `VISA_Communication.vi`
  - `Affichage_Graphiques.vi`
  - `Sauvegarde.vi`
  - `Gestion_Alarmes.vi`
- Sauvegarde de l’historique des trajets dans un fichier texte formaté