#define BUZZER     LATC5_bit
#define LED2       LATA3_bit

#define BP_URGENCE PORTB.F6
#define BP_ALARME  PORTB.F7
#define BP_ACQ     PORTD.F4

#define _FOSC_HZ        16000000UL

#define T0_TICKS_1S     (_FOSC_HZ / 1024UL)
#define T0_RELOAD       (65536UL - T0_TICKS_1S)
#define T0_RELOAD_H     ((unsigned char)((T0_RELOAD >> 8) & 0xFF))
#define T0_RELOAD_L     ((unsigned char)(T0_RELOAD & 0xFF))

unsigned char etage_actuel   = 0;
char          direction      = 'S';
unsigned int  poids_kg       = 0;
unsigned char ir_porte       = 0;
unsigned char al_active      = 0;
unsigned char urg_active     = 0;
unsigned char mode_auto      = 1;
unsigned int  nb_session     = 0;
unsigned char pwm_actuel     = 0;
unsigned int  temps_trajet   = 0;
unsigned char porte_cmd      = 0;

volatile unsigned char suppress_data_count = 0;

volatile unsigned char timer0_flag  = 0;
volatile unsigned int  timer0_count = 0;
volatile unsigned char urgence_flag = 0;
volatile unsigned char al_flag      = 0;

void init_timer1();

void interrupt() {
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

void init_timer1() {
    T1CON = 0x00;
    TMR1H = 0xFE;
    TMR1L = 0x0C;
    TMR1IF_bit = 0;
    TMR1IE_bit = 1;
    TMR1ON_bit = 1;
}

void main() {
    ANSELA = 0x00;
    TRISA3_bit = 0;
    LATA3_bit = 0;

    ANSELB = 0x00;
    TRISB6_bit = 1;
    TRISB7_bit = 1;
    INTCON2.RBPU = 1;

    ANSELC = 0x00;
    TRISC5_bit = 0;
    TRISC6_bit = 0;
    TRISC7_bit = 1;
    LATC5_bit = 0;

    ANSELD = 0x00;
    TRISD4_bit = 1;

    UART1_Init(9600);
    Delay_ms(100);

    T0CON = 0x07;
    TMR0H = T0_RELOAD_H;
    TMR0L = T0_RELOAD_L;
    TMR0IF_bit = 0;
    TMR0IE_bit = 1;

    init_timer1();

    PEIE_bit = 1;
    GIE_bit = 1;
    T0CON = 0x87;

    UART1_Write_Text("<DATA,ET:0,DIR:0,PT:0,PRT:0,AL:0,URG:0,NB:0,PWM:0,TPS:0>\r\n");

    while (1) {

        if (BP_URGENCE && !urg_active) {
            Delay_ms(20);
            if (BP_URGENCE) {
                urg_active = 1;
                LED2 = 1;
                urgence_flag = 1;
            }
        }

        if (urgence_flag) {
            urgence_flag = 0;
            uart_send_data();

            {
                unsigned char acq_recu = 0;
                while (acq_recu == 0) {
                    Delay_ms(20);
                    if (timer0_flag) {
                        timer0_flag = 0;
                        uart_send_data();
                    }
                    if (BP_ACQ && !BP_URGENCE) {
                        Delay_ms(50);
                        acq_recu = 1;
                    }
                }
                Delay_ms(200);
            }

            urg_active = 0;
            al_active = 0;
            al_flag = 0;
            LED2 = 0;
            uart_send_data();
        }

        if (al_flag) {
            al_flag = 0;
            uart_send_data();

            {
                unsigned char acq_recu = 0;
                while (acq_recu == 0) {
                    Delay_ms(20);
                    if (timer0_flag) {
                        timer0_flag = 0;
                        uart_send_data();
                    }
                    if (BP_ACQ) {
                        Delay_ms(50);
                        acq_recu = 1;
                    }
                }
                Delay_ms(200);
            }

            al_active = 0;
            LED2 = 0;
            uart_send_data();
        }

        if (BP_ALARME && !al_active) {
            Delay_ms(20);
            if (BP_ALARME) {
                al_active = 1;
                al_flag = 1;
                LED2 = 1;
            }
        }

        if (timer0_flag) {
            timer0_flag = 0;
            uart_send_data();
        }
    }
}