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

#define LED1         LATA2_bit
#define LED2         LATA3_bit
#define MOTEUR_ON()  do { TRISC2_bit=0; LATC2_bit=1; } while(0)
#define MOTEUR_OFF() do { TRISC2_bit=0; LATC2_bit=0; } while(0)

#define MS_PAR_ETAGE    2500
#define MS_FERMETURE     300
#define MS_OUVERTURE     600
#define MS_DECEL         400
#define SEUIL_SURCHARGE  693

unsigned char etage_actuel = 0;
unsigned char etage_cible  = 0;
unsigned char en_mouvement = 0;
char          direction    = 'S';
unsigned int  poids_kg     = 0;
unsigned char ir_porte     = 0;
unsigned char req[4]       = {0,0,0,0};
char          l1[17];
char          l2[17];

void lire_capteurs() {
    ir_porte = PORTA.F0;
    poids_kg = (unsigned int)((ADC_Read(1) * 900UL) / 1023UL);
}

void gerer_leds() {
    LED1 = (!en_mouvement && ir_porte == 0) ? 1 : 0;
    LED2 = (poids_kg >= SEUIL_SURCHARGE)    ? 1 : 0;
}

void afficher_lcd() {
    if (en_mouvement) {
        l1[0]='E'; l1[1]='T'; l1[2]=':';
        l1[3]=(char)('0'+etage_actuel);
        l1[4]='-'; l1[5]='>';
        l1[6]=(char)('0'+etage_cible);
        l1[7]=' '; l1[8]='D'; l1[9]='I'; l1[10]='R'; l1[11]=':';
        if (direction=='U') { l1[12]='U'; l1[13]='P'; l1[14]=' '; }
        else                { l1[12]='D'; l1[13]='W'; l1[14]='N'; }
        l1[15]=' '; l1[16]=0;
    } else {
        l1[0]='E'; l1[1]='T'; l1[2]=':';
        l1[3]=(char)('0'+etage_actuel);
        l1[4]=' '; l1[5]=' '; l1[6]=' ';
        l1[7]=' '; l1[8]='D'; l1[9]='I'; l1[10]='R'; l1[11]=':';
        l1[12]='-'; l1[13]='-'; l1[14]='-';
        l1[15]=' '; l1[16]=0;
    }
    Lcd_Out(1, 1, l1);
    sprintf(l2, "P:%3dkg IR:%c %c%c ",
        (int)poids_kg,
        ir_porte ? '1' : '0',
        LED1 ? 'V' : '-',
        LED2 ? 'A' : '-');
    Lcd_Out(2, 1, l2);
}

void scanner_req() {
    if (PORTD.F0) req[0] = 1;
    if (PORTD.F1) req[1] = 1;
    if (PORTD.F2) req[2] = 1;
    if (PORTD.F3) req[3] = 1;
}

void deplacer_vers(unsigned char cible) {
    char          sens;
    unsigned char nb_etages;
    unsigned char i;

    if (cible == etage_actuel) return;

    sens         = (cible > etage_actuel) ? 'U' : 'D';
    direction    = sens;
    etage_cible  = cible;
    en_mouvement = 1;
    LED1         = 0;

    nb_etages = (cible > etage_actuel)
                ? (cible - etage_actuel)
                : (etage_actuel - cible);


    afficher_lcd();
    Delay_ms(MS_FERMETURE);
    MOTEUR_ON();
    for (i = 0; i < nb_etages - 1; i++) {

        Delay_ms(MS_PAR_ETAGE);

        if (sens == 'U') etage_actuel++;
        else             etage_actuel--;


        if (req[etage_actuel]) {
            req[etage_actuel] = 0;


            MOTEUR_OFF();
            Delay_ms(MS_DECEL);
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
            LED1         = 0;
            afficher_lcd();
            Delay_ms(MS_FERMETURE);
            MOTEUR_ON();
        } else {

            Lcd_Chr(1, 4, (char)('0' + etage_actuel));
        }
    }

    Delay_ms(MS_PAR_ETAGE);

    MOTEUR_OFF();
    Delay_ms(MS_DECEL);

    if (sens == 'U') etage_actuel++;
    else             etage_actuel--;

    en_mouvement = 0;
    direction    = 'S';
    etage_cible  = etage_actuel;
    lire_capteurs();
    gerer_leds();
    afficher_lcd();
    Delay_ms(MS_OUVERTURE);
}

unsigned char prochain_req() {
    unsigned char i, nearest;
    unsigned int  d, min_d;

    req[etage_actuel] = 0;

    if (direction == 'U') {
        for (i = etage_actuel+1; i <= 3; i++)
            if (req[i]) { req[i]=0; return i; }
        for (i = 0; i < etage_actuel; i++)
            if (req[i]) { req[i]=0; return i; }
    } else if (direction == 'D') {
        for (i = etage_actuel; i > 0; i--)
            if (req[i-1]) { req[i-1]=0; return i-1; }
        for (i = etage_actuel+1; i <= 3; i++)
            if (req[i]) { req[i]=0; return i; }
    } else {
        nearest=0xFF; min_d=10;
        for (i=0; i<=3; i++) {
            if (!req[i]) continue;
            d = (i>=etage_actuel) ? i-etage_actuel : etage_actuel-i;
            if (d<min_d) { min_d=d; nearest=i; }
        }
        if (nearest!=0xFF) { req[nearest]=0; return nearest; }
    }
    return 0xFF;
}
void main() {
    unsigned char prochain;

    CCP1CON    = 0x00;
    TRISC2_bit = 0;
    LATC2_bit  = 0;

    ANSELA = 0x02;
    ANSELB = 0x00;
    ANSELC = 0x00;
    ANSELD = 0x00;

    TRISA0_bit = 1;
    TRISA1_bit = 1;
    TRISA2_bit = 0;
    TRISA3_bit = 0;
    TRISC2_bit = 0;
    TRISC3_bit = 0;
    TRISC4_bit = 1;
    TRISC6_bit = 0;
    TRISC7_bit = 1;
    TRISD0_bit = 1;
    TRISD1_bit = 1;
    TRISD2_bit = 1;
    TRISD3_bit = 1;
    TRISD4_bit = 1;
    TRISB6_bit = 1;
    TRISB7_bit = 1;

    LATA = 0x00;
    LATC = 0x00;

    ADC_Init();
    ANSELA     = 0x02;
    TRISA0_bit = 1;

    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Out(1, 1, " ASCENSEUR 4ET ");
    Lcd_Out(2, 1, "  Pret - ET:0  ");
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
            if (poids_kg >= SEUIL_SURCHARGE) {
                LED2 = 1;
                MOTEUR_OFF();
                Lcd_Cmd(_LCD_CLEAR);
                Lcd_Out(1, 1, "  SURCHARGE!  ");
                Lcd_Out(2, 1, " MAX: 630 kg  ");
                Delay_ms(2000);
                Lcd_Cmd(_LCD_CLEAR);
                afficher_lcd();
            } else {
                deplacer_vers(prochain);
                while (1) {
                    lire_capteurs();
                    prochain = prochain_req();
                    if (prochain == 0xFF) break;
                    if (poids_kg >= SEUIL_SURCHARGE) break;
                    deplacer_vers(prochain);
                }
                direction = 'S';
            }
        }
        afficher_lcd();
        Delay_ms(50);
    }
}