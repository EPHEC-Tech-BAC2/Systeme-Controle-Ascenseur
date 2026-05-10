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

#define LED1        LATA2_bit
#define LED2        LATA3_bit

#define MOTEUR_MONTER()     do { LATC0_bit = 1; LATC1_bit = 0; } while(0)
#define MOTEUR_DESCENDRE()  do { LATC0_bit = 0; LATC1_bit = 1; } while(0)
#define MOTEUR_ARRETER()    do { LATC0_bit = 0; LATC1_bit = 0; \
                                 PWM1_Set_Duty(0); } while(0)

#define PWM_MIN             80
#define PWM_MAX             255
#define PWM_PALIERS         6
#define MS_PALIER           150
#define MS_CROISIERE        1800
#define MS_CROISIERE_1ET    (MS_CROISIERE - PWM_PALIERS * MS_PALIER)
#define MS_FERMETURE        300
#define MS_OUVERTURE        600

#define NB_ETAGES           4
#define POIDS_MAX_DEF       630

unsigned char etage_actuel   = 0;
unsigned char etage_cible    = 0;
unsigned char en_mouvement   = 0;
char          direction      = 'S';
unsigned int  poids_kg       = 0;
unsigned char ir_porte       = 0;
unsigned char req[NB_ETAGES] = {0, 0, 0, 0};

unsigned char al_active      = 0;
unsigned char urg_active     = 0;
unsigned int  poids_max      = POIDS_MAX_DEF;
unsigned int  seuil_surge    = 693;

char l1[17], l2[17];

void uart_send_data() {
    char trame[64];
    unsigned char dir_n;
    unsigned char prt_n;

    if      (direction == 'U') dir_n = 1;
    else if (direction == 'D') dir_n = 2;
    else                       dir_n = 0;

    prt_n = ir_porte ? 1 : 0;

    sprintf(trame,
        "<DATA,ET:%d,DIR:%d,PT:%d,PRT:%d,AL:%d,URG:%d>\r\n",
        (int)etage_actuel, (int)dir_n, (int)poids_kg,
        (int)prt_n, (int)al_active, (int)urg_active);
    UART1_Write_Text(trame);
}

void lire_capteurs() {
    ir_porte = PORTA.F0;
    poids_kg = (unsigned int)((ADC_Read(1) * 900UL) / 1023UL);
}

void gerer_leds() {
    LED1 = ir_porte ? 1 : 0;
    LED2 = (poids_kg >= seuil_surge || urg_active || al_active) ? 1 : 0;
}

void afficher_lcd() {
    if (en_mouvement) {
        sprintf(l1, "ET:%u->%u %s     ",
            (unsigned)etage_actuel,
            (unsigned)etage_cible,
            (direction == 'U') ? "UP" : "DN");
    } else {
        sprintf(l1, "ET:%u STOP       ",
            (unsigned)etage_actuel);
    }
    Lcd_Out(1, 1, l1);

    sprintf(l2, "P:%3dkg IR:%c    ",
        (int)poids_kg, ir_porte ? 'O' : 'F');
    Lcd_Out(2, 1, l2);
}

void rampe_accel() {
    unsigned char i;
    unsigned int  pwm;
    for (i = 0; i <= PWM_PALIERS; i++) {
        pwm = PWM_MIN + ((unsigned int)(PWM_MAX - PWM_MIN) * i) / PWM_PALIERS;
        PWM1_Set_Duty((unsigned char)pwm);
        Delay_ms(MS_PALIER);
    }
}

void rampe_decel() {
    unsigned char i;
    unsigned int  pwm;
    for (i = PWM_PALIERS; i > 0; i--) {
        pwm = PWM_MIN + ((unsigned int)(PWM_MAX - PWM_MIN) * (i-1)) / PWM_PALIERS;
        PWM1_Set_Duty((unsigned char)pwm);
        Delay_ms(MS_PALIER);
    }
    MOTEUR_ARRETER();
}

void demarrer_moteur(char sens) {
    if (sens == 'U') MOTEUR_MONTER();
    else             MOTEUR_DESCENDRE();
    PWM1_Set_Duty(PWM_MIN);
    PWM1_Start();
    rampe_accel();
}

void scanner_req() {
    if (PORTD.F0) req[0] = 1;
    if (PORTD.F1) req[1] = 1;
    if (PORTD.F2) req[2] = 1;
    if (PORTD.F3) req[3] = 1;
}

unsigned char prochain_req() {
    unsigned char i, nearest;
    unsigned int  d, min_d;

    req[etage_actuel] = 0;
    nearest = 0xFF;
    min_d   = 10;
    for (i = 0; i < NB_ETAGES; i++) {
        if (!req[i]) continue;
        d = (i >= etage_actuel) ? (i - etage_actuel) : (etage_actuel - i);
        if (d < min_d) { min_d = d; nearest = i; }
    }
    if (nearest != 0xFF) { req[nearest] = 0; return nearest; }
    return 0xFF;
}

void deplacer_vers(unsigned char cible) {
    char          sens;
    unsigned char nb_et, i;

    if (cible == etage_actuel) return;

    sens         = (cible > etage_actuel) ? 'U' : 'D';
    direction    = sens;
    etage_cible  = cible;
    en_mouvement = 1;

    afficher_lcd();
    uart_send_data();
    Delay_ms(MS_FERMETURE);

    nb_et = (cible > etage_actuel) ? (cible - etage_actuel)
                                   : (etage_actuel - cible);
    demarrer_moteur(sens);
    PWM1_Set_Duty(PWM_MAX);

    for (i = 0; i < nb_et; i++) {
        if (i == nb_et - 1 && nb_et == 1) Delay_ms(MS_CROISIERE_1ET);
        else                              Delay_ms(MS_CROISIERE);

        if (i == nb_et - 1) rampe_decel();

        if (sens == 'U') etage_actuel++;
        else             etage_actuel--;
        afficher_lcd();
    }

    MOTEUR_ARRETER();
    en_mouvement = 0;
    direction    = 'S';
    etage_cible  = etage_actuel;
    afficher_lcd();
    uart_send_data();
    Delay_ms(MS_OUVERTURE);
}

void main() {
    unsigned char prochain;
    unsigned int  compteur_ms = 0;

    PWM1_Init(5000);
    PWM1_Set_Duty(0);
    PWM1_Start();

    ANSELA     = 0x02;
    TRISA0_bit = 1;
    TRISA1_bit = 1;
    TRISA2_bit = 0;
    TRISA3_bit = 0;
    LATA2_bit  = 0;
    LATA3_bit  = 0;

    ANSELB = 0x00;

    ANSELC     = 0x00;
    TRISC0_bit = 0; TRISC1_bit = 0; TRISC2_bit = 0;
    TRISC6_bit = 0; TRISC7_bit = 1;
    LATC0_bit  = 0; LATC1_bit = 0;

    ANSELD = 0x00;
    TRISD  = 0xFF;

    ADC_Init();
    ANSELA = 0x02; TRISA1_bit = 1;

    UART1_Init(9600);
    Delay_ms(100);

    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Out(1, 1, " ASCENSEUR 4ET ");
    Lcd_Out(2, 1, "  V0.4 - EPHEC ");
    Delay_ms(1500);
    Lcd_Cmd(_LCD_CLEAR);

    UART1_Write_Text("<DATA,ET:0,DIR:0,PT:0,PRT:0,AL:0,URG:0>\r\n");

    lire_capteurs();
    gerer_leds();
    afficher_lcd();

    while (1) {
        lire_capteurs();
        gerer_leds();

        scanner_req();
        prochain = prochain_req();

        if (prochain != 0xFF && ir_porte == 0 && poids_kg < seuil_surge) {
            deplacer_vers(prochain);
        }

        compteur_ms += 50;
        if (compteur_ms >= 2000) {
            compteur_ms = 0;
            uart_send_data();
        }

        afficher_lcd();
        Delay_ms(50);
    }
}