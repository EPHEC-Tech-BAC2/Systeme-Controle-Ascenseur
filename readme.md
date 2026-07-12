# **🛗 Système de contrôle automatique d'un ascenseur**

# **A211 — Systèmes embarqués I** &nbsp;|&nbsp; **A208 — Acquisition et visualisation de données**
### Projet final du 2ᵉ quadrimestre — EPHEC Tech — Année académique 2025-2026

**Binôme A08**
- EL YAZAMI Yassine (HE305212)
- TABICH Mohamed (HE305311)

**Professeurs :** Emile COSTA, François DONNAY
**Plateforme :** Carte EasyPIC V7 — PIC18F45K22 8 MHz — MikroC PRO / LabVIEW

## 📋 Contexte

Ce projet combine deux unités d'enseignement complémentaires :

- **A211 — Systèmes embarqués I** : programmation du microcontrôleur PIC18F45K22 en MikroC
- **A208 — Acquisition et visualisation de données** : développement d'une interface de supervision sous LabVIEW

Le scénario retenu est celui d'un ascenseur desservant quatre étages (0 à 3), commandé localement par le microcontrôleur et supervisé à distance depuis un PC.

## ⚙️ Description du système

Le PIC18F45K22 pilote le moteur de translation via un pont en H L293D commandé en PWM, lit le poids de la cabine (ADC) et l'état de la porte, affiche l'état du système sur un écran LCD 16×2, et stocke le compteur de trajets, le dernier étage desservi et la vitesse configurée dans une mémoire EEPROM I²C.

L'interface LabVIEW communique avec le PIC en UART (9600 bauds) via un protocole de trames délimitées par `<` et `>`, acquitté dans les deux sens. Elle permet de superviser en direct la position de la cabine, la charge, le mode de fonctionnement (automatique / manuel) et l'historique des trajets, ainsi que d'agir sur le système : appel d'étage, changement de mode, arrêt d'urgence, alarme, réglage des seuils de poids et de vitesse, consultation et remise à zéro de l'EEPROM.

Le système gère trois sources d'interruption simultanées (base de temps Timer0, boutons urgence/alarme, réception UART), une file circulaire de commandes pour découpler réception et traitement, ainsi que des rampes d'accélération/décélération progressives du moteur.

## 🧩 Défis rencontrés

- Concevoir un protocole UART bidirectionnel robuste (trames encadrées, acquittement systématique, gestion des erreurs) sans bloquer le programme principal pendant les déplacements
- Garder le système réactif pendant un trajet (arrêt d'urgence, commandes série, rafraîchissement LCD) via une fonction d'attente non bloquante surveillée en continu
- Gérer les cas limites : arrêt d'urgence en cours de trajet (position devenue inconnue), surcharge détectée en cours d'appel, alarme déclenchée depuis le PIC ou depuis le PC
- Faire cohabiter deux jeux de temporisations (simulation Proteus vs carte réelle) avec un seul et même code source, via une directive de compilation
- Synchroniser côté LabVIEW le décodage des trames `DATA` / `EEP` (Scan From String) avec la mise à jour des indicateurs, des graphiques déroulants et de l'historique, sans perdre de trames

## 🖥️ Logiciels utilisés

| Outil | Usage |
|---|---|
| MikroC PRO for PIC | Firmware du PIC18F45K22 |
| Proteus | Simulation électronique et validation du firmware |
| LabVIEW + NI-VISA | Interface de supervision et communication série |
| Git / GitHub | Gestion de version et documentation du projet |

## 📁 Structure du dépôt

```
Systeme-Controle-Ascenseur/
├── Acquisition et visualisation de données/  → VI LabVIEW (VISA, affichage, alarmes, sauvegarde)
├── Cahier des charges du projet/       → 3 versions du cahier des charges
├── Etat d'avancement/                  → suivi individuel de chaque membre
├── Présentation PPT/                   → support de présentation orale
├── Rapport final/                      → rapport complet remis (PDF)
├── Ressources/                         → schémas et images du rapport
└── Systèmes embarqués I/               → code MikroC + simulation Proteus
```