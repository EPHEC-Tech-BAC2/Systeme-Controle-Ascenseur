## État d’avancement

| Séance | Date | Travail réalisé | Détail |
|--------|------|-----------------|--------|
| 1 | 14/04/2026 | Rédaction du cahier des charges | Définition du projet, des fonctionnalités attendues et des objectifs. |
| 2 | 15/04/2026 | MikroC et de la carte EasyPIC v7 | Démarrage du développement sur PIC18F45K22 et mise en place de la structure de base du programme. |
| 3 | 15/04/2026 | Développement des premières fonctionnalités | Configuration des ports, lecture des entrées analogiques, gestion des boutons d’étage et affichage LCD dynamique. 
| 4 | 15/04/2026 | Réalisation de interface LabVIEW complète de l'ascenseur. Nous avons configuré la communication série (VISA) avec un journal de bord pour le suivi des trames émises et reçues. L'interface intègre également toutes les commandes de pilotage (appels d'étages, modes Auto/Manu, sécurité) ainsi que les outils de visualisation dynamique, tels que l'historique des trajets et les graphiques de suivi en temps réel de la position et du poids.
| 5 | 21/04/2026 | Réalisation des tests et ajustements du code MikroC sur la carte PIC. Par mesure de précaution, une validation préalable sur Raspberry Pi Pico a été effectuée afin d'éviter tout dommage matériel. Cette étape a abouti à la mise en service fonctionnelle du moteur DC (5V) dédié au mécanisme de changement d'étage.
| 6 | 24/04/2026 | Développement du code sous MikroC pour la gestion du moteur DC, incluant l'implémentation de l'inversion du sens de rotation selon que l'ascenseur monte ou descende, ainsi que le réglage précis du signal PWM pour assurer des rampes de démarrage et de ralentissement progressives afin de garantir la fluidité du mouvement.
| 7 | 11/05/2026 | Modification du code sur mikroC ... Nous avons ajouté la communication UART bidirectionnelle avec LabVIEW, les interruptions Timer0, INT2 et UART RX, la mémoire EEPROM I²C, le mode manuel, ainsi que plusieurs corrections de conformité au CDC V2.0 (format des trames, LEDs, seuil de surcharge dynamique).


## Avancement hors séances
Ajout de UART1_Init(9600) et de la fonction uart_send_data() qui envoie 
la trame <DATA,ET:%d,DIR:%d,PT:%d,PRT:%d,AL:%d,URG:%d> en format numerique.
Emission automatique toutes les 2 secondes via un compteur dans la boucle.

Amélioration du code MikroC. 
04 — Initialisation UART + envoi automatique de trames <DATA>
05 — Timer0 16 bits + envoi de <DATA> toutes les 2 secondes
06 — Interruption externe RB6/RB7 pour urgence et alarme
07 — Interruption UART RX + assemblage de trames <CMD>
08 — Traitement des commandes <CMD> reçues de LabVIEW
09 — EEPROM I²C lecture/écriture