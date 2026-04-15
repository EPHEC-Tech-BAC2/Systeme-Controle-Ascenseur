#line 1 "C:/Users/yelya/OneDrive/Bureau/SystémeEmbarquée/ProjetFinal/projet-final-a08_a211_25_26/Systèmes embarqués I/MikroC/Ascenseur.c"



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




unsigned char etage_actuel = 0;
unsigned char etage_precedent = 0;
unsigned int poids_kg = 0;
unsigned char ir_presence = 0;

char ligne1[17];
char ligne2[17];

void lire_capteurs() {
 unsigned int adc_ir = ADC_Read(0);
 unsigned int adc_poids = ADC_Read(1);


 ir_presence = (adc_ir > 512) ? 1 : 0;


 poids_kg = (unsigned int)((adc_poids * 300UL) / 1023);
}

void afficher_lcd() {
 char *direction;

 if (etage_actuel > etage_precedent)
 direction = "UP ";
 else if (etage_actuel < etage_precedent)
 direction = "DWN";
 else
 direction = "---";

 sprintf(ligne1, "ET:%u  DIR:%s   ", etage_actuel, direction);
 Lcd_Out(1, 1, ligne1);

 sprintf(ligne2, "Poids:%3ukg IR:%c", poids_kg, ir_presence ? '1' : '0');
 Lcd_Out(2, 1, ligne2);
}

void gerer_boutons_etages() {
 etage_precedent = etage_actuel;

 if (Button(&PORTD, 0, 50, 1))
 etage_actuel = 1;
 else if (Button(&PORTD, 1, 50, 1))
 etage_actuel = 2;
 else if (Button(&PORTD, 2, 50, 1))
 etage_actuel = 3;
 else if (Button(&PORTD, 3, 50, 1))
 etage_actuel = 0;
}

void main() {
 ANSELA = 0x03;
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

  LATA2_bit  = 0;
  LATA3_bit  = 0;

 ADC_Init();
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 Lcd_Out(1, 1, "  ASCENSEUR   ");
 Lcd_Out(2, 1, "Initialisation");
 Delay_ms(1500);
 Lcd_Cmd(_LCD_CLEAR);

 while(1) {
 lire_capteurs();
 gerer_boutons_etages();
 afficher_lcd();
 Delay_ms(100);
 }
}
