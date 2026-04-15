
_lire_capteurs:

;Ascenseur.c,28 :: 		void lire_capteurs() {
;Ascenseur.c,29 :: 		unsigned int adc_ir   = ADC_Read(0);   // AN0 — IR porte
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       lire_capteurs_adc_ir_L0+0 
	MOVF        R1, 0 
	MOVWF       lire_capteurs_adc_ir_L0+1 
;Ascenseur.c,30 :: 		unsigned int adc_poids = ADC_Read(1);  // AN1 — potentiomètre poids
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       lire_capteurs_adc_poids_L0+0 
	MOVF        R1, 0 
	MOVWF       lire_capteurs_adc_poids_L0+1 
;Ascenseur.c,33 :: 		ir_presence = (adc_ir > 512) ? 1 : 0;
	MOVF        lire_capteurs_adc_ir_L0+1, 0 
	SUBLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__lire_capteurs20
	MOVF        lire_capteurs_adc_ir_L0+0, 0 
	SUBLW       0
L__lire_capteurs20:
	BTFSC       STATUS+0, 0 
	GOTO        L_lire_capteurs0
	MOVLW       1
	MOVWF       ?FLOC___lire_capteursT1+0 
	GOTO        L_lire_capteurs1
L_lire_capteurs0:
	CLRF        ?FLOC___lire_capteursT1+0 
L_lire_capteurs1:
	MOVF        ?FLOC___lire_capteursT1+0, 0 
	MOVWF       _ir_presence+0 
;Ascenseur.c,36 :: 		poids_kg = (unsigned int)((adc_poids * 300UL) / 1023);
	MOVF        lire_capteurs_adc_poids_L0+0, 0 
	MOVWF       R0 
	MOVF        lire_capteurs_adc_poids_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVWF       R3 
	MOVLW       44
	MOVWF       R4 
	MOVLW       1
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       255
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _poids_kg+0 
	MOVF        R1, 0 
	MOVWF       _poids_kg+1 
;Ascenseur.c,37 :: 		}
L_end_lire_capteurs:
	RETURN      0
; end of _lire_capteurs

_afficher_lcd:

;Ascenseur.c,39 :: 		void afficher_lcd() {
;Ascenseur.c,42 :: 		if (etage_actuel > etage_precedent)
	MOVF        _etage_actuel+0, 0 
	SUBWF       _etage_precedent+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_afficher_lcd2
;Ascenseur.c,43 :: 		direction = "UP ";
	MOVLW       ?lstr1_Ascenseur+0
	MOVWF       afficher_lcd_direction_L0+0 
	MOVLW       hi_addr(?lstr1_Ascenseur+0)
	MOVWF       afficher_lcd_direction_L0+1 
	GOTO        L_afficher_lcd3
L_afficher_lcd2:
;Ascenseur.c,44 :: 		else if (etage_actuel < etage_precedent)
	MOVF        _etage_precedent+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_afficher_lcd4
;Ascenseur.c,45 :: 		direction = "DWN";
	MOVLW       ?lstr2_Ascenseur+0
	MOVWF       afficher_lcd_direction_L0+0 
	MOVLW       hi_addr(?lstr2_Ascenseur+0)
	MOVWF       afficher_lcd_direction_L0+1 
	GOTO        L_afficher_lcd5
L_afficher_lcd4:
;Ascenseur.c,47 :: 		direction = "---";
	MOVLW       ?lstr3_Ascenseur+0
	MOVWF       afficher_lcd_direction_L0+0 
	MOVLW       hi_addr(?lstr3_Ascenseur+0)
	MOVWF       afficher_lcd_direction_L0+1 
L_afficher_lcd5:
L_afficher_lcd3:
;Ascenseur.c,49 :: 		sprintf(ligne1, "ET:%u  DIR:%s   ", etage_actuel, direction);
	MOVLW       _ligne1+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_ligne1+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_4_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_4_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_4_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _etage_actuel+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        afficher_lcd_direction_L0+0, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        afficher_lcd_direction_L0+1, 0 
	MOVWF       FARG_sprintf_wh+7 
	CALL        _sprintf+0, 0
;Ascenseur.c,50 :: 		Lcd_Out(1, 1, ligne1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ligne1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ligne1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,52 :: 		sprintf(ligne2, "Poids:%3ukg IR:%c", poids_kg, ir_presence ? '1' : '0');
	MOVLW       _ligne2+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_ligne2+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_5_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_5_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_5_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _poids_kg+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _poids_kg+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _ir_presence+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd6
	MOVLW       49
	MOVWF       ?FLOC___afficher_lcdT15+0 
	GOTO        L_afficher_lcd7
L_afficher_lcd6:
	MOVLW       48
	MOVWF       ?FLOC___afficher_lcdT15+0 
L_afficher_lcd7:
	MOVF        ?FLOC___afficher_lcdT15+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	CALL        _sprintf+0, 0
;Ascenseur.c,53 :: 		Lcd_Out(2, 1, ligne2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ligne2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ligne2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,54 :: 		}
L_end_afficher_lcd:
	RETURN      0
; end of _afficher_lcd

_gerer_boutons_etages:

;Ascenseur.c,56 :: 		void gerer_boutons_etages() {
;Ascenseur.c,57 :: 		etage_precedent = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_precedent+0 
;Ascenseur.c,59 :: 		if (Button(&PORTD, 0, 50, 1))       // RD0 — Étage 1
	MOVLW       PORTD+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       50
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_boutons_etages8
;Ascenseur.c,60 :: 		etage_actuel = 1;
	MOVLW       1
	MOVWF       _etage_actuel+0 
	GOTO        L_gerer_boutons_etages9
L_gerer_boutons_etages8:
;Ascenseur.c,61 :: 		else if (Button(&PORTD, 1, 50, 1))  // RD1 — Étage 2
	MOVLW       PORTD+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       50
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_boutons_etages10
;Ascenseur.c,62 :: 		etage_actuel = 2;
	MOVLW       2
	MOVWF       _etage_actuel+0 
	GOTO        L_gerer_boutons_etages11
L_gerer_boutons_etages10:
;Ascenseur.c,63 :: 		else if (Button(&PORTD, 2, 50, 1))  // RD2 — Étage 3
	MOVLW       PORTD+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       50
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_boutons_etages12
;Ascenseur.c,64 :: 		etage_actuel = 3;
	MOVLW       3
	MOVWF       _etage_actuel+0 
	GOTO        L_gerer_boutons_etages13
L_gerer_boutons_etages12:
;Ascenseur.c,65 :: 		else if (Button(&PORTD, 3, 50, 1))  // RD3 — Étage 0
	MOVLW       PORTD+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTD+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       50
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_boutons_etages14
;Ascenseur.c,66 :: 		etage_actuel = 0;
	CLRF        _etage_actuel+0 
L_gerer_boutons_etages14:
L_gerer_boutons_etages13:
L_gerer_boutons_etages11:
L_gerer_boutons_etages9:
;Ascenseur.c,67 :: 		}
L_end_gerer_boutons_etages:
	RETURN      0
; end of _gerer_boutons_etages

_main:

;Ascenseur.c,69 :: 		void main() {
;Ascenseur.c,70 :: 		ANSELA = 0x03;
	MOVLW       3
	MOVWF       ANSELA+0 
;Ascenseur.c,71 :: 		ANSELB = 0x00;
	CLRF        ANSELB+0 
;Ascenseur.c,72 :: 		ANSELC = 0x00;
	CLRF        ANSELC+0 
;Ascenseur.c,73 :: 		ANSELD = 0x00;
	CLRF        ANSELD+0 
;Ascenseur.c,75 :: 		TRISA0_bit = 1;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Ascenseur.c,76 :: 		TRISA1_bit = 1;
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,77 :: 		TRISA2_bit = 0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;Ascenseur.c,78 :: 		TRISA3_bit = 0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;Ascenseur.c,80 :: 		TRISC2_bit = 0;
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;Ascenseur.c,81 :: 		TRISC3_bit = 0;
	BCF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;Ascenseur.c,82 :: 		TRISC4_bit = 1;
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;Ascenseur.c,83 :: 		TRISC6_bit = 0;
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;Ascenseur.c,84 :: 		TRISC7_bit = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;Ascenseur.c,86 :: 		TRISD0_bit = 1;
	BSF         TRISD0_bit+0, BitPos(TRISD0_bit+0) 
;Ascenseur.c,87 :: 		TRISD1_bit = 1;
	BSF         TRISD1_bit+0, BitPos(TRISD1_bit+0) 
;Ascenseur.c,88 :: 		TRISD2_bit = 1;
	BSF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
;Ascenseur.c,89 :: 		TRISD3_bit = 1;
	BSF         TRISD3_bit+0, BitPos(TRISD3_bit+0) 
;Ascenseur.c,91 :: 		LED1 = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;Ascenseur.c,92 :: 		LED2 = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,94 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;Ascenseur.c,95 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;Ascenseur.c,96 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,97 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,99 :: 		Lcd_Out(1, 1, "  ASCENSEUR   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,100 :: 		Lcd_Out(2, 1, "Initialisation");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,101 :: 		Delay_ms(1500);
	MOVLW       16
	MOVWF       R11, 0
	MOVLW       57
	MOVWF       R12, 0
	MOVLW       13
	MOVWF       R13, 0
L_main15:
	DECFSZ      R13, 1, 1
	BRA         L_main15
	DECFSZ      R12, 1, 1
	BRA         L_main15
	DECFSZ      R11, 1, 1
	BRA         L_main15
	NOP
	NOP
;Ascenseur.c,102 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,104 :: 		while(1) {
L_main16:
;Ascenseur.c,105 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,106 :: 		gerer_boutons_etages();
	CALL        _gerer_boutons_etages+0, 0
;Ascenseur.c,107 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,108 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main18:
	DECFSZ      R13, 1, 1
	BRA         L_main18
	DECFSZ      R12, 1, 1
	BRA         L_main18
	DECFSZ      R11, 1, 1
	BRA         L_main18
	NOP
;Ascenseur.c,109 :: 		}
	GOTO        L_main16
;Ascenseur.c,110 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
