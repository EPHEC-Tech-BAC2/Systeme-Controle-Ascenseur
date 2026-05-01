# A211 - Systèmes embarqués 1 - 2025-2026
# A208 - Acquisition et visualisation de données - 2025-2026
## Projet final du 2ème quadrimestre


**Binôme: A08**
- NOM Prénom (Matricule)
- EL YAZAMI Yassine (HE305212)
- TABICH Mohamed (HE305311)

**Objectifs :**  

**Initialisation du projet**

- Création du dépôt GitHub du projet final A208 & A211
- Ajout du fichier README.md avec description du projet
- Mise en place de la structure des dossiers (MikroC / LabVIEW / Rapport / Proteus)
- Définition du scénario : système de contrôle automatique d'un ascenseur

**Cahier des charges**
  
- Rédaction du cahier des charges complet (A208 & A211)
- Création de la carte mentale (Mind Map) — 6 branches principales
- Réalisation du schéma fonctionnel par blocs (Hardware)
- Conception du croquis de la face avant LabVIEW
- Définition du protocole de communication UART bidirectionnel (trames < >)
- Description complète des périphériques utilisés et de leurs rôles
- Description du mode automatique et du mode manuel
- Définition des 3 interruptions simultanées (Timer0 / Externe / UART RX)
- Définition de l'utilisation de la mémoire EEPROM I²C
- Dépôt du cahier des charges sur Moodle au format PDF

**Mise à jour Cahier des charges — Version 2**   

- Correction du brochage des boutons d'étages BP1–BP4 → RD0, RD1, RD2, RD3
- Correction du bouton d'acquittement ACQ → RD4
- Reconfiguration du capteur IR sur RA0 en entrée digitale (simulation par bouton poussoir, pas d'ouverture automatique)
- Remplacement du MOSFET IRF520 par le driver L293D : IN1=RC0, IN2=RC1, EN=RC2 (CCP1)
- Ajout du brochage EEPROM I²C : SCL=RC3, SDA=RC4, adresse 0x50
- Confirmation du brochage UART : TX=RC6, RX=RC7 à 9600 bauds
- Mise à jour du tableau récapitulatif complet du brochage
- Ajout de la section Historique des révisions (V1.0 → V2.0)