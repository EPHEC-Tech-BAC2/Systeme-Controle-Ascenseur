sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;

#define LED1  LATA2_bit
#define LED2  LATA3_bit

// --- Moteur L293D ---
#define MOTEUR_MONTER()    do { LATC0_bit=1; LATC1_bit=0; } while(0)
#define MOTEUR_DESCENDRE() do { LATC0_bit=0; LATC1_bit=1; } while(0)
#define MOTEUR_ARRETER()   do { LATC0_bit=0; LATC1_bit=0; } while(0)

// --- Profil vitesse ---
#define PWM_MIN         80
#define PWM_MAX         255
#define PWM_PALIERS     6
#define MS_PALIER       150
#define MS_CROISIERE    1800
#define MS_CROISIERE_1ET (MS_CROISIERE - PWM_PALIERS * MS_PALIER)
#define MS_FERMETURE    300
#define MS_OUVERTURE    600
#define SEUIL_SURCHARGE 693
#define NB_ETAGES       4

// --- Variables globales ---
unsigned char etage_actuel = 0;
unsigned char etage_cible  = 0;
unsigned char en_mouvement = 0;
char          direction    = 'S';
unsigned int  poids_kg     = 0;
unsigned char ir_porte     = 0;
unsigned char req[NB_ETAGES] = {0,0,0,0};
char          l1[17];
char          l2[17];

// -------------------------------------------------------
void rampe_accel() {
    unsigned char i;
    unsigned int  pwm;
    for (i = 0; i <= PWM_PALIERS; i++) {
        pwm = PWM_MIN + ((unsigned int)(PWM_MAX - PWM_MIN) * i) / PWM_PALIERS;
        PWM1_Set_Duty((unsigned char)pwm);
        Delay_ms(MS_PALIER);
    }
}

// -------------------------------------------------------
void rampe_decel() {
    unsigned char i;
    unsigned int  pwm;
    for (i = PWM_PALIERS; i > 0; i--) {
        pwm = PWM_MIN + ((unsigned int)(PWM_MAX - PWM_MIN) * (i-1)) / PWM_PALIERS;
        PWM1_Set_Duty((unsigned char)pwm);
        Delay_ms(MS_PALIER);
    }
    MOTEUR_ARRETER();
    PWM1_Set_Duty(0);
}

// -------------------------------------------------------
void lire_capteurs() {
    ir_porte = PORTA.F0;
    poids_kg = (unsigned int)((ADC_Read(1) * 900UL) / 1023UL);
}

// -------------------------------------------------------
void gerer_leds() {
    LED1 = (ir_porte == 1) ? 1 : 0;
    LED2 = (poids_kg >= SEUIL_SURCHARGE) ? 1 : 0;
}

// -------------------------------------------------------
void afficher_etage_lcd(unsigned char etage, unsigned char col) {
    if (etage == 0) {
        Lcd_Chr(1, col,   'R');
        Lcd_Chr(1, col+1, 'D');
        Lcd_Chr(1, col+2, 'C');
    } else {
        Lcd_Chr(1, col,   (char)('0' + etage));
        Lcd_Chr(1, col+1, ' ');
        Lcd_Chr(1, col+2, ' ');
    }
}

// -------------------------------------------------------
void afficher_lcd() {
    if (en_mouvement) {
        l1[0]='E'; l1[1]='T'; l1[2]=':';
        if (etage_actuel==0){l1[3]='R';l1[4]='D';l1[5]='C';}
        else {l1[3]=(char)('0'+etage_actuel);l1[4]=' ';l1[5]=' ';}
        l1[6]='-'; l1[7]='>';
        if (etage_cible==0){l1[8]='R';l1[9]='D';l1[10]='C';}
        else {l1[8]=(char)('0'+etage_cible);l1[9]=' ';l1[10]=' ';}

        l1[11]='D'; l1[12]=':';
        if (direction=='U') { l1[13]='U'; l1[14]='P'; }
        else                { l1[13]='D'; l1[14]='N'; }
        l1[15]=' '; l1[16]=0;
    } else {
        l1[0]='E'; l1[1]='T'; l1[2]=':';
        if (etage_actuel==0){l1[3]='R';l1[4]='D';l1[5]='C';}
        else {l1[3]=(char)('0'+etage_actuel);l1[4]=' ';l1[5]=' ';}
        l1[6]=' ';l1[7]=' ';l1[8]=' ';l1[9]=' ';
        l1[10]='S';l1[11]='T';l1[12]='O';l1[13]='P';
        l1[14]=' ';l1[15]=' ';l1[16]=0;
    }
    Lcd_Out(1, 1, l1);
    sprintf(l2, "P:%3dkg IR:%c %c%c ",
        (int)poids_kg,
        ir_porte ? '1' : '0',
        LED1 ? 'V' : '-',
        LED2 ? 'A' : '-');
    Lcd_Out(2, 1, l2);
}

// -------------------------------------------------------
void scanner_req() {
    if (PORTD.F0) req[0] = 1;
    if (PORTD.F1) req[1] = 1;
    if (PORTD.F2) req[2] = 1;
    if (PORTD.F3) req[3] = 1;
}

// -------------------------------------------------------
void demarrer_moteur(char sens) {
    if (sens == 'U') MOTEUR_MONTER();
    else             MOTEUR_DESCENDRE();
    PWM1_Set_Duty(PWM_MIN);
    PWM1_Start();
    rampe_accel();
}

// -------------------------------------------------------
void deplacer_vers(unsigned char cible) {
    char          sens;
    unsigned char nb_etages;
    unsigned char i;
    unsigned char est_dernier;

    if (cible == etage_actuel) return;

    sens         = (cible > etage_actuel) ? 'U' : 'D';
    direction    = sens;
    etage_cible  = cible;
    en_mouvement = 1;
    LED1         = 0;
    nb_etages    = (cible > etage_actuel)
                   ? (cible - etage_actuel)
                   : (etage_actuel - cible);

    afficher_lcd();
    Delay_ms(MS_FERMETURE);
    demarrer_moteur(sens);

    for (i = 0; i < nb_etages; i++) {
        est_dernier = (i == nb_etages - 1);
        PWM1_Set_Duty(PWM_MAX);

        if (!est_dernier) {
            Delay_ms(MS_CROISIERE);
            if (sens == 'U') etage_actuel++;
            else             etage_actuel--;

            if (req[etage_actuel]) {
                req[etage_actuel] = 0;
                rampe_decel();
                en_mouvement = 0;
                direction    = 'S';
                etage_cible  = etage_actuel;
                lire_capteurs();
                gerer_leds();
                afficher_lcd();
                Delay_ms(MS_OUVERTURE);
                direction    = sens;
                etage_cible  = cible;
                en_mouvement = 1;
                afficher_lcd();
                Delay_ms(MS_FERMETURE);
                demarrer_moteur(sens);
            } else {
                afficher_etage_lcd(etage_actuel, 4);
            }
        } else {
            if (nb_etages == 1) {
                Delay_ms(MS_CROISIERE_1ET);
            } else {
                Delay_ms(MS_CROISIERE);
            }
            rampe_decel();
            if (sens == 'U') etage_actuel++;
            else             etage_actuel--;
        }
    }

    en_mouvement = 0;
    direction    = 'S';
    etage_cible  = etage_actuel;
    lire_capteurs();
    gerer_leds();
    afficher_lcd();
    Delay_ms(MS_OUVERTURE);
}

// -------------------------------------------------------
unsigned char prochain_req() {
    unsigned char i;
    unsigned char nearest;
    unsigned int  d;
    unsigned int  min_d;

    req[etage_actuel] = 0;

    if (direction == 'U') {
        for (i = etage_actuel+1; i < NB_ETAGES; i++)
            if (req[i]) { req[i]=0; return i; }
        for (i = 0; i < etage_actuel; i++)
            if (req[i]) { req[i]=0; return i; }
    } else if (direction == 'D') {
        for (i = etage_actuel; i > 0; i--)
            if (req[i-1]) { req[i-1]=0; return i-1; }
        for (i = etage_actuel+1; i < NB_ETAGES; i++)
            if (req[i]) { req[i]=0; return i; }
    } else {
        nearest = 0xFF;
        min_d   = 10;
        for (i = 0; i < NB_ETAGES; i++) {
            if (!req[i]) continue;
            d = (i >= etage_actuel) ? i - etage_actuel : etage_actuel - i;
            if (d < min_d) { min_d = d; nearest = i; }
        }
        if (nearest != 0xFF) { req[nearest]=0; return nearest; }
    }
    return 0xFF;
}

// -------------------------------------------------------
void main() {
    unsigned char prochain;

    PWM1_Init(5000);
    PWM1_Set_Duty(0);
    PWM1_Start();

    TRISC0_bit = 0; TRISC1_bit = 0; TRISC2_bit = 0;
    LATC0_bit  = 0; LATC1_bit  = 0; LATC2_bit  = 0;

    ANSELA = 0x02; ANSELB = 0x00; ANSELC = 0x00; ANSELD = 0x00;

    TRISA0_bit = 1; TRISA1_bit = 1; TRISA2_bit = 0; TRISA3_bit = 0;
    TRISC3_bit = 0; TRISC4_bit = 1; TRISC6_bit = 0; TRISC7_bit = 1;
    TRISD0_bit = 1; TRISD1_bit = 1; TRISD2_bit = 1; TRISD3_bit = 1;
    TRISD4_bit = 1; TRISB6_bit = 1; TRISB7_bit = 1;

    LATA = 0x00; LATC = 0x00;

    ADC_Init();
    ANSELA = 0x02;
    TRISA1_bit = 1;

    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Out(1, 1, " ASCENSEUR 4ET ");
    Lcd_Out(2, 1, "  Pret - RDC   ");
    Delay_ms(1500);
    Lcd_Cmd(_LCD_CLEAR);

    lire_capteurs();
    gerer_leds();
    afficher_lcd();

    while (1) {
        lire_capteurs();
        gerer_leds();
        scanner_req();

        prochain = prochain_req();

        if (prochain != 0xFF) {
            // --- NOUVELLE SÉCURITÉ ---
            if (ir_porte == 1) {
                Lcd_Cmd(_LCD_CLEAR);
                Lcd_Out(1, 1, "PORTE OUVERTE! ");
                Lcd_Out(2, 1, "Veuillez fermer");
                Delay_ms(2000);
                Lcd_Cmd(_LCD_CLEAR);
                afficher_lcd();
            }
            else if (poids_kg >= SEUIL_SURCHARGE) {
                LED2 = 1;
                MOTEUR_ARRETER();
                PWM1_Set_Duty(0);
                Lcd_Cmd(_LCD_CLEAR);
                Lcd_Out(1, 1, "  SURCHARGE!   ");
                Lcd_Out(2, 1, "  MAX: 630 kg  ");
                Delay_ms(2000);
                Lcd_Cmd(_LCD_CLEAR);
                afficher_lcd();
            } else {
                deplacer_vers(prochain);
                while (1) {
                    lire_capteurs();
                    prochain = prochain_req();
                    if (prochain == 0xFF) break;
                    // On arrête si porte ouverte ou surcharge détectée en cours de trajet
                    if (ir_porte == 1 || poids_kg >= SEUIL_SURCHARGE) break;
                    deplacer_vers(prochain);
                }
                direction = 'S';
            }
        }
        afficher_lcd();
        Delay_ms(50);
    }
}