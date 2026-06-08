#define SIMULATION_PROTEUS

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

#define LED1       LATA2_bit
#define LED2       LATA3_bit
#define BUZZER     LATC5_bit

#define BP_URGENCE PORTB.F6
#define BP_ALARME  PORTB.F7
#define BP_ACQ     PORTD.F4

#define MOTEUR_MONTER()    do { LATC0_bit = 1; LATC1_bit = 0; moteur_actif = 1; } while(0)
#define MOTEUR_DESCENDRE()  do { LATC0_bit = 0; LATC1_bit = 1; moteur_actif = 1; } while(0)
#define MOTEUR_ARRETER()    do { LATC0_bit = 0; LATC1_bit = 0; PWM1_Set_Duty(0); moteur_actif = 0; pwm_actuel = 0; } while(0)

#define PWM_MIN     80
#define PWM_PALIERS  6

#ifdef SIMULATION_PROTEUS
  #define MS_PALIER           20
  #define MS_CROISIERE        500
  #define MS_FERMETURE        50
  #define MS_OUVERTURE        100
  #define MS_ARRET_INTERMED   500
  #define MS_PWM_PAUSE        0
  #define MS_LOOP_STEP        20
#else
  #define MS_PALIER           150
  #define MS_CROISIERE        1800
  #define MS_FERMETURE        300
  #define MS_OUVERTURE        600
  #define MS_ARRET_INTERMED   3000
  #define MS_PWM_PAUSE        5
  #define MS_LOOP_STEP        50
#endif

#define MS_CROISIERE_1ET  (MS_CROISIERE - PWM_PALIERS * MS_PALIER)

#define _FOSC_HZ        16000000UL

#define T0_TICKS_1S     (_FOSC_HZ / 1024UL)
#define T0_RELOAD       (65536UL - T0_TICKS_1S)
#define T0_RELOAD_H     ((unsigned char)((T0_RELOAD >> 8) & 0xFF))
#define T0_RELOAD_L     ((unsigned char)(T0_RELOAD & 0xFF))

#define NB_ETAGES        4
#define POIDS_MAX_DEF    630
#define POT_ADC_MAX      900

#define EEPROM_W         0xA0
#define EEPROM_R         0xA1

unsigned char etage_actuel      = 0;
unsigned char etage_cible       = 0;
unsigned char en_mouvement      = 0;
char          direction         = 'S';
unsigned int  poids_kg          = 0;
unsigned char ir_porte          = 0;
unsigned char req[NB_ETAGES]    = {0,0,0,0};

unsigned char al_active         = 0;
unsigned char urg_active        = 0;
unsigned char mode_auto         = 1;

unsigned int  poids_max         = POIDS_MAX_DEF;
unsigned int  seuil_surge       = POIDS_MAX_DEF;
unsigned char surcharge_active  = 0;

unsigned int  nb_session        = 0;
unsigned int  nb_trajets        = 0;

unsigned char last_etage        = 0;
unsigned char vitesse_max_pc    = 100;
unsigned char vitesse_eeprom    = 100;
unsigned char pwm_max_eff       = 255;

unsigned char pwm_actuel        = 0;
unsigned int  temps_trajet      = 0;

unsigned char position_inconnue = 0;
unsigned char entre_etages      = 0;
unsigned char porte_cmd         = 0;
unsigned char moteur_actif      = 0;

unsigned char etat_surcharge    = 0;

volatile unsigned char timer0_flag  = 0;
volatile unsigned int  timer0_count = 0;
volatile unsigned char urgence_flag = 0;
volatile unsigned char al_flag      = 0;

volatile unsigned char suppress_data_count = 0;

#define CMD_QSIZE 4
#define CMD_QLEN  40

volatile char          rx_buf[50];
volatile unsigned char rx_idx   = 0;

volatile char          cmd_queue[CMD_QSIZE][CMD_QLEN];
volatile unsigned char cmd_qhead = 0;
volatile unsigned char cmd_qtail = 0;

volatile unsigned char stop_demande = 0;

char l1[20];
char l2[20];

void recalc_pwm_max();
unsigned char pop_cmd(char *dest);
void eeprom_charger();
void eeprom_sauver_trajet();
void eeprom_reset();
void set_pwm(unsigned char duty);

void uart_send_data();
void uart_send_eeprom();
void uart_ack_ok();
void uart_ack_err();

void lire_capteurs();
void gerer_leds();
void maj_surcharge(unsigned char force_transition);
char etat_porte_char();

void lcd_build_surcharge_l2(char *buf);
void afficher_lcd();
void lcd_transition();
void lcd_update_transit();

void appliquer_pmax(unsigned int val);
void appliquer_spd(unsigned char val);

void attendre_ms(unsigned int ms);

void rampe_accel();
void rampe_decel();
void demarrer_moteur(char sens);

void scanner_req();
void vider_req();
unsigned char prochain_req();

void deplacer_vers(unsigned char cible);
void parser_cmd(char *buf);

void init_timer1();

void interrupt() {
    char c;

    if (TMR0IE_bit && TMR0IF_bit) {
        TMR0IF_bit = 0;
        TMR0H = T0_RELOAD_H;
        TMR0L = T0_RELOAD_L;
        timer0_flag = 1;
        timer0_count++;
    }

    if (TMR1IE_bit && TMR1IF_bit) {
        TMR1IF_bit = 0;
        TMR1H = 0xFE;
        TMR1L = 0x0C;
        if (al_active) BUZZER = ~BUZZER;
        else           BUZZER = 0;
    }

    if (RC1IE_bit && RC1IF_bit) {
        unsigned char j;
        unsigned char n;
        unsigned char nxt;

        if (OERR1_bit) {
            CREN1_bit = 0;
            CREN1_bit = 1;
        }

        c = RCREG1;

        if (c == '<') {
            rx_idx = 0;
        }

        if (rx_idx < 48) {
            rx_buf[rx_idx++] = c;
        }

        if (c == '>') {
            if (rx_idx >= 5 && rx_buf[0] == '<') {
                nxt = (unsigned char)((cmd_qtail + 1) & (CMD_QSIZE - 1));
                if (nxt != cmd_qhead) {
                    n = rx_idx;
                    if (n > (CMD_QLEN - 2)) n = CMD_QLEN - 2;
                    for (j = 0; j < n; j++)
                        cmd_queue[cmd_qtail][j] = rx_buf[j];
                    cmd_queue[cmd_qtail][n] = '\0';
                    cmd_qtail = nxt;
                }
            }
            rx_idx = 0;
        }
    }
}

void eep_write_byte(unsigned char addr, unsigned char val) {
    I2C1_Start();
    I2C1_Wr(EEPROM_W);
    I2C1_Wr(addr);
    I2C1_Wr(val);
    I2C1_Stop();
    Delay_ms(10);
}

unsigned char eep_read_byte(unsigned char addr) {
    unsigned char val;
    I2C1_Start();
    I2C1_Wr(EEPROM_W);
    I2C1_Wr(addr);
    I2C1_Repeated_Start();
    I2C1_Wr(EEPROM_R);
    val = I2C1_Rd(0);
    I2C1_Stop();
    return val;
}

void eep_write_word(unsigned char addr, unsigned int val) {
    eep_write_byte(addr,     (unsigned char)(val >> 8));
    eep_write_byte(addr + 1, (unsigned char)(val & 0xFF));
}

unsigned int eep_read_word(unsigned char addr) {
    unsigned int hi = (unsigned int)eep_read_byte(addr);
    unsigned int lo = (unsigned int)eep_read_byte(addr + 1);
    return (hi << 8) | lo;
}

void recalc_pwm_max() {
    pwm_max_eff = (unsigned char)((unsigned int)vitesse_max_pc * 255 / 100);
    if (pwm_max_eff < (unsigned char)(PWM_MIN + 20))
        pwm_max_eff = (unsigned char)(PWM_MIN + 20);
}

unsigned char pop_cmd(char *dest) {
    unsigned char i;
    if (cmd_qhead == cmd_qtail) return 0;
    GIE_bit = 0;
    for (i = 0; i < (CMD_QLEN - 1); i++)
        dest[i] = cmd_queue[cmd_qhead][i];
    dest[CMD_QLEN - 1] = '\0';
    cmd_qhead = (unsigned char)((cmd_qhead + 1) & (CMD_QSIZE - 1));
    GIE_bit = 1;
    return 1;
}

void eeprom_charger() {
    unsigned int  stored_traj;
    unsigned char stored_vit;

    stored_traj = eep_read_word(0x00);
    last_etage  = eep_read_byte(0x02);
    stored_vit  = eep_read_byte(0x03);

    if (stored_traj == 0xFFFF) {
        nb_trajets = 0;
        eep_write_word(0x00, 0);
    } else {
        nb_trajets = stored_traj;
    }

    if (last_etage == 0xFF) {
        last_etage = 0;
        eep_write_byte(0x02, 0);
    }

    if (stored_vit == 0xFF || stored_vit == 0) {
        vitesse_eeprom = 100;
        vitesse_max_pc  = 100;
        eep_write_byte(0x03, 100);
    } else {
        vitesse_eeprom = stored_vit;
        vitesse_max_pc  = stored_vit;
    }

    poids_max        = POIDS_MAX_DEF;
    seuil_surge      = POIDS_MAX_DEF;
    surcharge_active = 0;
    etat_surcharge   = 0;

    recalc_pwm_max();
}

void eeprom_sauver_trajet() {
    nb_session++;
    nb_trajets++;
    last_etage = etage_actuel;
    eep_write_word(0x00, nb_trajets);
    eep_write_byte(0x02, last_etage);
}

void eeprom_reset() {
    nb_trajets = 0;
    last_etage = 0;
    vitesse_eeprom = 100;
    vitesse_max_pc = 100;
    recalc_pwm_max();

    eep_write_byte(0x00, 0x00);
    eep_write_byte(0x01, 0x00);
    eep_write_byte(0x02, 0x00);
    eep_write_byte(0x03, 100);
    eep_write_byte(0x04, 0x00);
    eep_write_byte(0x05, 0x00);
}

void set_pwm(unsigned char duty) {
    PWM1_Set_Duty(duty);

    if (pwm_max_eff > 0) {
        if (duty >= pwm_max_eff)
            pwm_actuel = vitesse_max_pc;
        else
            pwm_actuel = (unsigned char)((unsigned long)vitesse_max_pc * duty / pwm_max_eff);
    } else {
        pwm_actuel = 0;
    }
}

void uart_send_data() {
    char trame[90];
    unsigned char dir_n, prt_n;

    if (suppress_data_count > 0) {
        suppress_data_count--;
        return;
    }

    if      (direction == 'U') dir_n = 1;
    else if (direction == 'D') dir_n = 2;
    else                       dir_n = 0;

    prt_n = mode_auto ? (ir_porte ? 1 : 0) : (porte_cmd ? 1 : 0);

    sprintf(trame,
        "<DATA,ET:%d,DIR:%d,PT:%d,PRT:%d,AL:%d,URG:%d,NB:%d,PWM:%d,TPS:%d>\r\n",
        (int)etage_actuel, (int)dir_n, (int)poids_kg,
        (int)prt_n,        (int)al_active, (int)urg_active,
        (int)nb_session,   (int)pwm_actuel, (int)temps_trajet);

    UART1_Write_Text(trame);
}

void uart_send_eeprom() {
    char trame[60];
    suppress_data_count = 1;
    sprintf(trame,
        "<EEP,TRAJ:%d,LAST:%d,VITESSE:%d>\r\n",
        (int)nb_trajets, (int)last_etage, (int)vitesse_eeprom);
    UART1_Write_Text(trame);
}

void uart_ack_ok()  { UART1_Write_Text("<ACK,OK>\r\n");  }
void uart_ack_err() { UART1_Write_Text("<ACK,ERR>\r\n"); }

void lire_capteurs() {
    unsigned long somme = 0;
    unsigned int  raw_adc;
    unsigned char n;

    ir_porte = PORTA.F0;

    ADC_Read(1);
    for (n = 0; n < 8; n++) {
        somme += ADC_Read(1);
    }
    raw_adc = (unsigned int)(somme >> 3);

    if (raw_adc > POT_ADC_MAX) raw_adc = POT_ADC_MAX;
    poids_kg = (unsigned int)((raw_adc * 900UL) / POT_ADC_MAX);
}

void maj_surcharge(unsigned char force_transition) {
    surcharge_active = (poids_kg >= seuil_surge) ? 1 : 0;
    if (force_transition) {
        etat_surcharge = 0xFF;
    }
    gerer_leds();
}

void gerer_leds() {
    if (mode_auto) LED1 = ir_porte ? 1 : 0;
    else           LED1 = porte_cmd ? 1 : 0;

    LED2 = (surcharge_active || urg_active || al_active) ? 1 : 0;
}

char etat_porte_char() {
    return (mode_auto ? ir_porte : porte_cmd) ? 'O' : 'F';
}

void lcd_build_surcharge_l2(char *buf) {
    unsigned int v = poids_max;

    buf[0]  = ' ';
    buf[1]  = ' ';
    buf[2]  = 'M';
    buf[3]  = 'A';
    buf[4]  = 'X';
    buf[5]  = ':';
    buf[6]  = (v >= 100) ? ((char)('0' + (v / 100)))       : ' ';
    buf[7]  = (v >= 10)  ? ((char)('0' + ((v / 10) % 10))) : ' ';
    buf[8]  = (char)('0' + (v % 10));
    buf[9]  = ' ';
    buf[10] = 'k';
    buf[11] = 'g';
    buf[12] = ' ';
    buf[13] = ' ';
    buf[14] = ' ';
    buf[15] = ' ';
    buf[16] = '\0';
}

void afficher_lcd() {
    char dir_str[3];
    char mode_str[5];
    char surcharge_l2[17];

    if (position_inconnue) {
        Lcd_Out(1, 1, "POS INCONNUE!   ");
        Lcd_Out(2, 1, "Replacer manuel ");
        return;
    }

    if (!urg_active && !al_active && surcharge_active) {
        lcd_build_surcharge_l2(surcharge_l2);
        Lcd_Out(1, 1, "  SURCHARGE!    ");
        Lcd_Out(2, 1, surcharge_l2);
        return;
    }

    if (mode_auto) {
        mode_str[0]='A'; mode_str[1]='u'; mode_str[2]='t'; mode_str[3]='o'; mode_str[4]='\0';
    } else {
        mode_str[0]='M'; mode_str[1]='a'; mode_str[2]='n'; mode_str[3]='u'; mode_str[4]='\0';
    }

    if (en_mouvement) {
        if (direction == 'U') { dir_str[0]='U'; dir_str[1]='P'; dir_str[2]='\0'; }
        else                  { dir_str[0]='D'; dir_str[1]='N'; dir_str[2]='\0'; }

        sprintf(l1, "ET:%u->%u %s %s ",
            (unsigned)etage_actuel, (unsigned)etage_cible, dir_str, mode_str);
    } else {
        sprintf(l1, "ET:%u STOP  %s ",
            (unsigned)etage_actuel, mode_str);
    }

    Lcd_Out(1, 1, l1);
    sprintf(l2, "P:%3dkg IR:%c    ", (int)poids_kg, etat_porte_char());
    Lcd_Out(2, 1, l2);
}

void lcd_transition() {
    Lcd_Cmd(_LCD_CLEAR);
    afficher_lcd();
}

void lcd_update_transit() {
    char dir_str[3];
    char mode_str[5];

    if (direction == 'U') { dir_str[0]='U'; dir_str[1]='P'; dir_str[2]='\0'; }
    else                  { dir_str[0]='D'; dir_str[1]='N'; dir_str[2]='\0'; }

    if (mode_auto) {
        mode_str[0]='A'; mode_str[1]='u'; mode_str[2]='t'; mode_str[3]='o'; mode_str[4]='\0';
    } else {
        mode_str[0]='M'; mode_str[1]='a'; mode_str[2]='n'; mode_str[3]='u'; mode_str[4]='\0';
    }

#ifndef SIMULATION_PROTEUS
    PWM1_Set_Duty(0);
    Delay_ms(MS_PWM_PAUSE);
#endif

    sprintf(l1, "ET:%u->%u %s %s ",
        (unsigned)etage_actuel, (unsigned)etage_cible, dir_str, mode_str);
    Lcd_Out(1, 1, l1);

    sprintf(l2, "P:%3dkg IR:%c    ", (int)poids_kg, etat_porte_char());
    Lcd_Out(2, 1, l2);

#ifndef SIMULATION_PROTEUS
    PWM1_Set_Duty(pwm_max_eff);
#endif
}

void appliquer_pmax(unsigned int val) {
    if (val < 1)   val = 1;
    if (val > 999) val = 999;

    poids_max  = val;
    seuil_surge = val;

    lire_capteurs();
    maj_surcharge(1);

    uart_ack_ok();
    uart_send_data();
}

void appliquer_spd(unsigned char val) {
    if (val > 100) val = 100;
    if (val < 10)  val = 10;

    vitesse_max_pc = val;
    vitesse_eeprom = val;
    recalc_pwm_max();
    eep_write_byte(0x03, vitesse_eeprom);

    if (moteur_actif) set_pwm(pwm_max_eff);

    suppress_data_count = 1;
    uart_ack_ok();
    uart_send_data();
}

void attendre_ms(unsigned int ms) {
    unsigned int  elapsed = 0;
    unsigned char b;
    char          local_cmd[50];
    char         *pp;
    unsigned int  pv;
    unsigned char sv;
    unsigned char nc;

    while (elapsed < ms) {

        if (BP_URGENCE && !urg_active) {
            Delay_ms(20);
            if (BP_URGENCE) {
                MOTEUR_ARRETER();
                urg_active = 1;
                LED2 = 1;
                urgence_flag = 1;
            }
        }

        if (urgence_flag || stop_demande) return;

        if (pop_cmd(local_cmd)) {

            if (strstr(local_cmd, "CMD,STOP")) {
                MOTEUR_ARRETER();
                urg_active = 1;
                direction = 'S';
                en_mouvement = 0;
                LED2 = 1;
                urgence_flag = 1;
                uart_ack_ok();

            } else if (strstr(local_cmd, "MOT:STP") || strstr(local_cmd, "MOT:STOP")) {

                MOTEUR_ARRETER();
                stop_demande = 1;
                uart_ack_ok();

            } else if (strstr(local_cmd, "AL:ON")) {
                al_active = 1;
                al_flag = 1;
                LED2 = 1;
                uart_ack_ok();

            } else if ((pp = strstr(local_cmd, "CALL:")) != 0) {
                nc = (unsigned char)(*(pp + 5) - '0');
                if (nc < NB_ETAGES && !al_active && !surcharge_active) {
                    if      (direction == 'U' && nc > etage_actuel) req[nc] = 1;
                    else if (direction == 'D' && nc < etage_actuel) req[nc] = 1;
                    uart_ack_ok();
                } else {
                    uart_ack_err();
                }

            } else if ((pp = strstr(local_cmd, "PMAX:")) != 0) {
                pv = 0;
                pp += 5;
                while (*pp >= '0' && *pp <= '9') {
                    pv = pv * 10 + (unsigned int)(*pp - '0');
                    pp++;
                }
                appliquer_pmax(pv);

            } else if ((pp = strstr(local_cmd, "SPD:")) != 0) {
                sv = 0;
                pp += 4;
                while (*pp >= '0' && *pp <= '9') {
                    sv = sv * 10 + (unsigned char)(*pp - '0');
                    pp++;
                }
                appliquer_spd(sv);

            } else if (strstr(local_cmd, "GET:EEP")) {
                uart_send_eeprom();

            } else if (strstr(local_cmd, "EEP:RST") || strstr(local_cmd, "RST:EEP")) {
                eeprom_reset();
                uart_ack_ok();
                uart_send_eeprom();
            }
        }

        if (urgence_flag || stop_demande) return;

        for (b = 0; b < NB_ETAGES; b++) {
            if (PORTD & (1 << b)) {
                if      (direction == 'U' && b > etage_actuel) req[b] = 1;
                else if (direction == 'D' && b < etage_actuel) req[b] = 1;
            }
        }

        if (timer0_flag) {
            timer0_flag = 0;
            lire_capteurs();
            maj_surcharge(0);
            uart_send_data();

            if (moteur_actif) lcd_update_transit();
            else              afficher_lcd();
        }

        Delay_ms(MS_LOOP_STEP);
        elapsed += MS_LOOP_STEP;
    }
}

void rampe_accel() {
    unsigned char i;
    unsigned int  pwm;

    for (i = 0; i <= PWM_PALIERS; i++) {
        if (BP_URGENCE && !urg_active) {
            Delay_ms(20);
            if (BP_URGENCE) {
                MOTEUR_ARRETER();
                urg_active = 1;
                LED2 = 1;
                urgence_flag = 1;
            }
        }

        if (urgence_flag || stop_demande) {
            MOTEUR_ARRETER();
            return;
        }

        pwm = PWM_MIN + ((unsigned int)(pwm_max_eff - PWM_MIN) * i) / PWM_PALIERS;
        set_pwm((unsigned char)pwm);
        uart_send_data();
        Delay_ms(MS_PALIER);
    }
}

void rampe_decel() {
    unsigned char i;
    unsigned int  pwm;

    for (i = PWM_PALIERS; i > 0; i--) {
        if (BP_URGENCE && !urg_active) {
            Delay_ms(20);
            if (BP_URGENCE) {
                MOTEUR_ARRETER();
                urg_active = 1;
                LED2 = 1;
                urgence_flag = 1;
            }
        }

        if (urgence_flag || stop_demande) {
            MOTEUR_ARRETER();
            return;
        }

        pwm = PWM_MIN + ((unsigned int)(pwm_max_eff - PWM_MIN) * (i - 1)) / PWM_PALIERS;
        set_pwm((unsigned char)pwm);
        uart_send_data();
        Delay_ms(MS_PALIER);
    }

    MOTEUR_ARRETER();
}

void demarrer_moteur(char sens) {
    if (sens == 'U') MOTEUR_MONTER();
    else             MOTEUR_DESCENDRE();

    set_pwm(PWM_MIN);
    PWM1_Start();
    rampe_accel();
}

void scanner_req() {
    if (PORTD.F0) req[0] = 1;
    if (PORTD.F1) req[1] = 1;
    if (PORTD.F2) req[2] = 1;
    if (PORTD.F3) req[3] = 1;
}

void vider_req() {
    unsigned char i;
    for (i = 0; i < NB_ETAGES; i++) req[i] = 0;
}

unsigned char prochain_req() {
    unsigned char i, nearest;
    unsigned int  d, min_d;

    req[etage_actuel] = 0;

    if (direction == 'U') {
        for (i = etage_actuel + 1; i < NB_ETAGES; i++)
            if (req[i]) { req[i] = 0; return i; }

        for (i = 0; i < etage_actuel; i++)
            if (req[i]) { req[i] = 0; return i; }

    } else if (direction == 'D') {
        for (i = etage_actuel; i > 0; i--)
            if (req[i - 1]) { req[i - 1] = 0; return i - 1; }

        for (i = etage_actuel + 1; i < NB_ETAGES; i++)
            if (req[i]) { req[i] = 0; return i; }

    } else {
        nearest = 0xFF;
        min_d = 10;

        for (i = 0; i < NB_ETAGES; i++) {
            if (!req[i]) continue;

            d = (i >= etage_actuel) ? (unsigned int)(i - etage_actuel)
                                    : (unsigned int)(etage_actuel - i);

            if (d < min_d) {
                min_d = d;
                nearest = i;
            }
        }

        if (nearest != 0xFF) {
            req[nearest] = 0;
            return nearest;
        }
    }

    return 0xFF;
}

void deplacer_vers(unsigned char cible) {
    char          sens;
    unsigned char nb_et, i, est_dernier;
    unsigned int  temps_debut;

    if (cible == etage_actuel || urgence_flag) return;

    stop_demande = 0;

    sens = (cible > etage_actuel) ? 'U' : 'D';
    direction = sens;
    etage_cible = cible;
    en_mouvement = 1;

    lire_capteurs();
    maj_surcharge(1);
    lcd_transition();
    uart_send_data();
    temps_debut = timer0_count;

    attendre_ms(MS_FERMETURE);
    if (urgence_flag || stop_demande) goto fin_deplacement;

    nb_et = (cible > etage_actuel) ? (cible - etage_actuel) : (etage_actuel - cible);

    demarrer_moteur(sens);
    lcd_update_transit();

    for (i = 0; i < nb_et; i++) {
        if (urgence_flag || stop_demande) goto fin_deplacement;

        est_dernier = (i == nb_et - 1);
        set_pwm(pwm_max_eff);

        if (!est_dernier) {
            entre_etages = 1;
            attendre_ms(MS_CROISIERE);
            if (urgence_flag || stop_demande) goto fin_deplacement;
            entre_etages = 0;

            if (sens == 'U') etage_actuel++;
            else             etage_actuel--;

            lire_capteurs();
            maj_surcharge(0);
            lcd_update_transit();
            uart_send_data();

            if (req[etage_actuel]) {
                req[etage_actuel] = 0;
                rampe_decel();
                if (urgence_flag || stop_demande) goto fin_deplacement;

                en_mouvement = 0;
                direction = 'S';
                etage_cible = etage_actuel;
                lire_capteurs();
                maj_surcharge(1);
                lcd_transition();
                uart_send_data();

                attendre_ms(MS_ARRET_INTERMED);
                if (urgence_flag || stop_demande) goto fin_deplacement;

                direction = sens;
                etage_cible = cible;
                en_mouvement = 1;
                lcd_transition();
                attendre_ms(MS_FERMETURE);
                if (urgence_flag || stop_demande) goto fin_deplacement;
                demarrer_moteur(sens);
                lcd_update_transit();
            }

        } else {
            entre_etages = 1;
            if (nb_et == 1) attendre_ms(MS_CROISIERE_1ET);
            else            attendre_ms(MS_CROISIERE);

            if (urgence_flag || stop_demande) goto fin_deplacement;
            entre_etages = 0;

            rampe_decel();
            if (urgence_flag || stop_demande) {
                position_inconnue = 1;
                goto fin_deplacement;
            }

            if (sens == 'U') etage_actuel++;
            else             etage_actuel--;
        }
    }

fin_deplacement:
    MOTEUR_ARRETER();

    if ((urgence_flag || stop_demande) && entre_etages) {
        position_inconnue = 1;
        entre_etages = 0;
    }

    temps_trajet = timer0_count - temps_debut;
    en_mouvement = 0;
    direction = 'S';
    etage_cible = etage_actuel;
    etat_surcharge = 0xFF;

    if (!urgence_flag && !stop_demande) {
        position_inconnue = 0;
    }

    lire_capteurs();
    maj_surcharge(1);
    lcd_transition();
    uart_send_data();

    if (!urgence_flag && !stop_demande) {
        eeprom_sauver_trajet();
        attendre_ms(MS_OUVERTURE);
    }

    stop_demande = 0;
}

void parser_cmd(char *buf) {
    char         *p;
    unsigned char cible;
    unsigned int  pv;
    unsigned char sv;

    p = strstr(buf, "CALL:");
    if (p) {
        cible = (unsigned char)(*(p + 5) - '0');
        if (cible < NB_ETAGES && mode_auto && !al_active && !surcharge_active) {
            req[cible] = 1;
            uart_ack_ok();
        } else {
            uart_ack_err();
        }
        return;
    }

    if (strstr(buf, "CMD,STOP")) {
        MOTEUR_ARRETER();
        urg_active = 1;
        direction = 'S';
        en_mouvement = 0;
        LED2 = 1;
        urgence_flag = 1;
        uart_ack_ok();
        uart_send_data();
        return;
    }

    if (strstr(buf, "CMD,ACK")) {
        if (BP_URGENCE) {
            uart_ack_err();
        } else if (urg_active) {
            urg_active = 0;
            al_active = 0;
            urgence_flag = 0;
            position_inconnue = 0;
            direction = 'S';
            en_mouvement = 0;
            etat_surcharge = 0xFF;
            lire_capteurs();
            maj_surcharge(1);
            lcd_transition();
            uart_ack_ok();
            uart_send_data();
        } else if (surcharge_active) {
            uart_ack_err();
        } else {
            uart_ack_ok();
        }
        return;
    }

    if (strstr(buf, "MODE:AUTO")) {
        mode_auto = 1;
        direction = 'S';
        en_mouvement = 0;
        etat_surcharge = 0xFF;
        lire_capteurs();
        maj_surcharge(1);
        lcd_transition();
        uart_ack_ok();
        uart_send_data();
        return;
    }

    if (strstr(buf, "MODE:MAN")) {
        mode_auto = 0;
        direction = 'S';
        en_mouvement = 0;
        MOTEUR_ARRETER();
        etat_surcharge = 0xFF;
        lire_capteurs();
        maj_surcharge(1);
        lcd_transition();
        uart_ack_ok();
        uart_send_data();
        return;
    }

    if (strstr(buf, "GET:EEP")) {
        uart_send_eeprom();
        return;
    }

    if (strstr(buf, "EEP:RST") || strstr(buf, "RST:EEP")) {
        eeprom_reset();
        uart_ack_ok();
        uart_send_eeprom();
        return;
    }

    {
        char *pP = strstr(buf, "PMAX:");
        char *pS = strstr(buf, "SPD:");
        if (pP && pS) {
            pv = 0;
            pP += 5;
            while (*pP >= '0' && *pP <= '9') {
                pv = pv * 10 + (unsigned int)(*pP - '0');
                pP++;
            }
            sv = 0;
            pS += 4;
            while (*pS >= '0' && *pS <= '9') {
                sv = sv * 10 + (unsigned char)(*pS - '0');
                pS++;
            }

            if (pv < 1)   pv = 1;
            if (pv > 999) pv = 999;
            poids_max   = pv;
            seuil_surge = pv;

            if (sv > 100) sv = 100;
            if (sv < 10)  sv = 10;
            vitesse_max_pc = sv;
            vitesse_eeprom = sv;
            recalc_pwm_max();
            eep_write_byte(0x03, vitesse_eeprom);
            if (moteur_actif) set_pwm(pwm_max_eff);

            lire_capteurs();
            maj_surcharge(1);
            uart_ack_ok();
            uart_send_data();
            return;
        }
    }

    p = strstr(buf, "PMAX:");
    if (p) {
        pv = 0;
        p += 5;
        while (*p >= '0' && *p <= '9') {
            pv = pv * 10 + (unsigned int)(*p - '0');
            p++;
        }
        appliquer_pmax(pv);
        return;
    }

    p = strstr(buf, "SPD:");
    if (p) {
        sv = 0;
        p += 4;
        while (*p >= '0' && *p <= '9') {
            sv = sv * 10 + (unsigned char)(*p - '0');
            p++;
        }
        appliquer_spd(sv);
        return;
    }

    if (strstr(buf, "DOOR:O")) {
        if (!mode_auto) {
            porte_cmd = 1;
            gerer_leds();
            if (!moteur_actif) lcd_transition();
            uart_ack_ok();
            uart_send_data();
        } else {
            uart_ack_err();
        }
        return;
    }

    if (strstr(buf, "DOOR:F")) {
        if (!mode_auto) {
            porte_cmd = 0;
            gerer_leds();
            if (!moteur_actif) lcd_transition();
            uart_ack_ok();
            uart_send_data();
        } else {
            uart_ack_err();
        }
        return;
    }

    if (strstr(buf, "MOT:UP")) {
        if (!mode_auto && !urg_active && !al_active && !surcharge_active) {
            if (moteur_actif || en_mouvement) {
                uart_ack_err();
            } else if (etage_actuel >= NB_ETAGES - 1) {
                uart_ack_err();
            } else {
                uart_ack_ok();
                deplacer_vers(etage_actuel + 1);
            }
        } else {
            uart_ack_err();
        }
        return;
    }

    if (strstr(buf, "MOT:DWN")) {
        if (!mode_auto && !urg_active && !al_active && !surcharge_active) {
            if (moteur_actif || en_mouvement) {
                uart_ack_err();
            } else if (etage_actuel == 0) {
                uart_ack_err();
            } else {
                uart_ack_ok();
                deplacer_vers(etage_actuel - 1);
            }
        } else {
            uart_ack_err();
        }
        return;
    }

    if (strstr(buf, "MOT:STP") || strstr(buf, "MOT:STOP")) {
        if (!mode_auto) {
            MOTEUR_ARRETER();
            direction = 'S';
            en_mouvement = 0;
            etat_surcharge = 0xFF;
            lire_capteurs();
            maj_surcharge(1);
            lcd_transition();
            uart_ack_ok();
            uart_send_data();
        } else {
            uart_ack_err();
        }
        return;
    }

    if (strstr(buf, "AL:ON")) {
        al_active = 1;
        al_flag = 1;
        LED2 = 1;
        en_mouvement = 0;
        MOTEUR_ARRETER();
        uart_ack_ok();
        uart_send_data();
        return;
    }

    if (strstr(buf, "RST:AL")) {
        if (!urg_active) {
            al_active = 0;
            al_flag = 0;
            etat_surcharge = 0xFF;
            lire_capteurs();
            maj_surcharge(1);
            lcd_transition();
            uart_ack_ok();
            uart_send_data();
        } else {
            uart_ack_err();
        }
        return;
    }

    uart_ack_err();
}

void init_timer1() {
    T1CON = 0x00;
    TMR1H = 0xFE;
    TMR1L = 0x0C;
    TMR1IF_bit = 0;
    TMR1IE_bit = 1;
    TMR1ON_bit = 1;
}

void main() {
    unsigned char prochain;
    char          cmd[50];
    unsigned char surge_now;

    PWM1_Init(5000);
    PWM1_Set_Duty(0);
    PWM1_Start();

    ANSELA = 0x02;
    TRISA0_bit = 1;
    TRISA1_bit = 1;
    TRISA2_bit = 0;
    TRISA3_bit = 0;
    LATA2_bit = 0;
    LATA3_bit = 0;

    ANSELB = 0x00;
    TRISB6_bit = 1;
    TRISB7_bit = 1;
    INTCON2.RBPU = 1;

    ANSELC = 0x00;
    TRISC0_bit = 0;
    TRISC1_bit = 0;
    TRISC2_bit = 0;
    TRISC3_bit = 0;
    TRISC4_bit = 1;
    TRISC5_bit = 0;
    TRISC6_bit = 0;
    TRISC7_bit = 1;
    LATC0_bit = 0;
    LATC1_bit = 0;
    LATC5_bit = 0;

    ANSELD = 0x00;
    TRISD = 0xFF;

    ADC_Init();
    ANSELA = 0x02;
    TRISA0_bit = 1;
    TRISA1_bit = 1;

    UART1_Init(9600);
    Delay_ms(100);

    I2C1_Init(100000);
    Delay_ms(10);

    eeprom_charger();

    T0CON = 0x07;
    TMR0H = T0_RELOAD_H;
    TMR0L = T0_RELOAD_L;
    TMR0IF_bit = 0;
    TMR0IE_bit = 1;

    init_timer1();

    RC1IE_bit = 1;
    PEIE_bit = 1;
    GIE_bit = 1;
    T0CON = 0x87;

    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Out(1, 1, " ASCENSEUR 4ET  ");
    Lcd_Out(2, 1, "  Pret  - ET:0  ");
    Delay_ms(1500);
    Lcd_Cmd(_LCD_CLEAR);

    UART1_Write_Text("<DATA,ET:0,DIR:0,PT:0,PRT:0,AL:0,URG:0,NB:0,PWM:0,TPS:0>\r\n");

    lire_capteurs();
    maj_surcharge(1);
    lcd_transition();

    while (1) {

        if (BP_URGENCE && !urg_active) {
            Delay_ms(20);
            if (BP_URGENCE) {
                MOTEUR_ARRETER();
                direction = 'S';
                en_mouvement = 0;
                urg_active = 1;
                LED2 = 1;
                urgence_flag = 1;
            }
        }

        if (urgence_flag) {
            urgence_flag = 0;
            etat_surcharge = 0;
            MOTEUR_ARRETER();
            en_mouvement = 0;
            direction = 'S';
            vider_req();

            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, " ARRET URGENCE  ");
            if (position_inconnue) Lcd_Out(2, 1, "POS?-ACQ:BP/PC  ");
            else                   Lcd_Out(2, 1, "ACQ : BP ou PC  ");

            lire_capteurs();
            maj_surcharge(0);
            uart_send_data();

            {
                unsigned char acq_recu = 0;
                while (acq_recu == 0) {
                    Delay_ms(MS_LOOP_STEP);
                    if (timer0_flag) {
                        timer0_flag = 0;
                        uart_send_data();
                    }

                    if (BP_ACQ && !BP_URGENCE) {
                        Delay_ms(50);
                        acq_recu = 1;
                    }

                    if (pop_cmd(cmd)) {
                        if (strstr(cmd, "CMD,ACK") && !BP_URGENCE)
                            acq_recu = 1;
                    }
                }
                Delay_ms(200);
            }

            urg_active = 0;
            al_active = 0;
            al_flag = 0;
            position_inconnue = 0;
            direction = 'S';
            en_mouvement = 0;
            etat_surcharge = 0xFF;

            lire_capteurs();
            maj_surcharge(1);
            lcd_transition();
            uart_send_data();
        }

        if (al_flag) {
            al_flag = 0;
            vider_req();

            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "   ALARME !!!   ");
            Lcd_Out(2, 1, "ACQ : BP ou PC  ");
            uart_send_data();

            {
                unsigned char acq_recu = 0;
                while (acq_recu == 0) {
                    Delay_ms(MS_LOOP_STEP);
                    if (timer0_flag) {
                        timer0_flag = 0;
                        uart_send_data();
                    }
                    if (BP_ACQ) {
                        Delay_ms(50);
                        acq_recu = 1;
                    }
                    if (pop_cmd(cmd)) {
                        if (strstr(cmd, "RST:AL"))
                            acq_recu = 1;
                    }
                }
                Delay_ms(200);
            }

            al_active = 0;
            etat_surcharge = 0xFF;
            lire_capteurs();
            maj_surcharge(1);
            lcd_transition();
            uart_send_data();
        }

        if (BP_ALARME && !al_active) {
            Delay_ms(20);
            if (BP_ALARME) {
                al_active = 1;
                LED2 = 1;
                en_mouvement = 0;
                MOTEUR_ARRETER();
                vider_req();

                Lcd_Cmd(_LCD_CLEAR);
                Lcd_Out(1, 1, "   ALARME !!!   ");
                Lcd_Out(2, 1, "ACQ : BP ou PC  ");
                uart_send_data();

                {
                    unsigned char acq_recu = 0;
                    while (acq_recu == 0) {
                        Delay_ms(MS_LOOP_STEP);
                        if (timer0_flag) {
                            timer0_flag = 0;
                            uart_send_data();
                        }
                        if (BP_ACQ) {
                            Delay_ms(50);
                            acq_recu = 1;
                        }
                        if (pop_cmd(cmd)) {
                            if (strstr(cmd, "RST:AL"))
                                acq_recu = 1;
                        }
                    }
                    Delay_ms(200);
                }

                al_active = 0;
                al_flag = 0;
                etat_surcharge = 0xFF;
                lire_capteurs();
                maj_surcharge(1);
                lcd_transition();
                uart_send_data();
            }
        }

        lire_capteurs();
        maj_surcharge(0);

        while (pop_cmd(cmd)) {
            parser_cmd(cmd);
        }

        gerer_leds();

        if (!urg_active && !al_active) {
            surge_now = surcharge_active ? 1 : 0;
            if (surge_now != etat_surcharge) {
                etat_surcharge = surge_now;
                if (!moteur_actif) lcd_transition();
                uart_send_data();
            }
        }

        if (timer0_flag) {
            timer0_flag = 0;
            uart_send_data();
            if (moteur_actif) lcd_update_transit();
            else              afficher_lcd();
        }

        if (mode_auto && !urg_active && !al_active && !position_inconnue) {
            if (!surcharge_active) {
                scanner_req();
                prochain = prochain_req();

                if (prochain != 0xFF) {
                    lire_capteurs();
                    maj_surcharge(0);

                    if (ir_porte == 1) {
                        Lcd_Cmd(_LCD_CLEAR);
                        Lcd_Out(1, 1, "PORTE OUVERTE!  ");
                        Lcd_Out(2, 1, "Veuillez fermer ");
                        Delay_ms(2000);
                        lcd_transition();
                    }
                    else if (surcharge_active) {
                        uart_send_data();
                    }
                    else {
                        deplacer_vers(prochain);
                        direction = 'S';
                        etat_surcharge = 0xFF;
                    }
                }
            }
        }

        if (!moteur_actif) afficher_lcd();
        Delay_ms(MS_LOOP_STEP);
    }
}