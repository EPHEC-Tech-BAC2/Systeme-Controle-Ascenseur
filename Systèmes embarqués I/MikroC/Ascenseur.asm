
_rampe_accel:

;Ascenseur.c,46 :: 		void rampe_accel() {
;Ascenseur.c,49 :: 		for (i = 0; i <= PWM_PALIERS; i++) {
	CLRF        rampe_accel_i_L0+0 
L_rampe_accel0:
	MOVF        rampe_accel_i_L0+0, 0 
	SUBLW       6
	BTFSS       STATUS+0, 0 
	GOTO        L_rampe_accel1
;Ascenseur.c,50 :: 		pwm = PWM_MIN + ((unsigned int)(PWM_MAX - PWM_MIN) * i) / PWM_PALIERS;
	MOVLW       175
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        rampe_accel_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       6
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       80
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
;Ascenseur.c,51 :: 		PWM1_Set_Duty((unsigned char)pwm);
	MOVF        R0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,52 :: 		Delay_ms(MS_PALIER);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_rampe_accel3:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_accel3
	DECFSZ      R12, 1, 1
	BRA         L_rampe_accel3
	DECFSZ      R11, 1, 1
	BRA         L_rampe_accel3
;Ascenseur.c,49 :: 		for (i = 0; i <= PWM_PALIERS; i++) {
	INCF        rampe_accel_i_L0+0, 1 
;Ascenseur.c,53 :: 		}
	GOTO        L_rampe_accel0
L_rampe_accel1:
;Ascenseur.c,54 :: 		}
L_end_rampe_accel:
	RETURN      0
; end of _rampe_accel

_rampe_decel:

;Ascenseur.c,57 :: 		void rampe_decel() {
;Ascenseur.c,60 :: 		for (i = PWM_PALIERS; i > 0; i--) {
	MOVLW       6
	MOVWF       rampe_decel_i_L0+0 
L_rampe_decel4:
	MOVF        rampe_decel_i_L0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_rampe_decel5
;Ascenseur.c,61 :: 		pwm = PWM_MIN + ((unsigned int)(PWM_MAX - PWM_MIN) * (i-1)) / PWM_PALIERS;
	DECF        rampe_decel_i_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       175
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       6
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       80
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
;Ascenseur.c,62 :: 		PWM1_Set_Duty((unsigned char)pwm);
	MOVF        R0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,63 :: 		Delay_ms(MS_PALIER);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_rampe_decel7:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_decel7
	DECFSZ      R12, 1, 1
	BRA         L_rampe_decel7
	DECFSZ      R11, 1, 1
	BRA         L_rampe_decel7
;Ascenseur.c,60 :: 		for (i = PWM_PALIERS; i > 0; i--) {
	DECF        rampe_decel_i_L0+0, 1 
;Ascenseur.c,64 :: 		}
	GOTO        L_rampe_decel4
L_rampe_decel5:
;Ascenseur.c,65 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;Ascenseur.c,66 :: 		PWM1_Set_Duty(0);
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,67 :: 		}
L_end_rampe_decel:
	RETURN      0
; end of _rampe_decel

_lire_capteurs:

;Ascenseur.c,70 :: 		void lire_capteurs() {
;Ascenseur.c,71 :: 		ir_porte = PORTA.F0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       _ir_porte+0 
;Ascenseur.c,72 :: 		poids_kg = (unsigned int)((ADC_Read(1) * 900UL) / 1023UL);
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVLW       0
	MOVWF       R2 
	MOVWF       R3 
	MOVLW       132
	MOVWF       R4 
	MOVLW       3
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
	MOVLW       0
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _poids_kg+0 
	MOVF        R1, 0 
	MOVWF       _poids_kg+1 
;Ascenseur.c,73 :: 		}
L_end_lire_capteurs:
	RETURN      0
; end of _lire_capteurs

_gerer_leds:

;Ascenseur.c,76 :: 		void gerer_leds() {
;Ascenseur.c,77 :: 		LED1 = (ir_porte == 1) ? 1 : 0;
	MOVF        _ir_porte+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_gerer_leds11
	MOVLW       1
	MOVWF       R1 
	GOTO        L_gerer_leds12
L_gerer_leds11:
	CLRF        R1 
L_gerer_leds12:
	BTFSC       R1, 0 
	GOTO        L__gerer_leds123
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L__gerer_leds124
L__gerer_leds123:
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
L__gerer_leds124:
;Ascenseur.c,78 :: 		LED2 = (poids_kg >= SEUIL_SURCHARGE) ? 1 : 0;
	MOVLW       2
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds125
	MOVLW       181
	SUBWF       _poids_kg+0, 0 
L__gerer_leds125:
	BTFSS       STATUS+0, 0 
	GOTO        L_gerer_leds13
	MOVLW       1
	MOVWF       R2 
	GOTO        L_gerer_leds14
L_gerer_leds13:
	CLRF        R2 
L_gerer_leds14:
	BTFSC       R2, 0 
	GOTO        L__gerer_leds126
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
	GOTO        L__gerer_leds127
L__gerer_leds126:
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
L__gerer_leds127:
;Ascenseur.c,79 :: 		}
L_end_gerer_leds:
	RETURN      0
; end of _gerer_leds

_afficher_etage_lcd:

;Ascenseur.c,82 :: 		void afficher_etage_lcd(unsigned char etage, unsigned char col) {
;Ascenseur.c,83 :: 		if (etage == 0) {
	MOVF        FARG_afficher_etage_lcd_etage+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_etage_lcd15
;Ascenseur.c,84 :: 		Lcd_Chr(1, col,   'R');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        FARG_afficher_etage_lcd_col+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       82
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;Ascenseur.c,85 :: 		Lcd_Chr(1, col+1, 'D');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        FARG_afficher_etage_lcd_col+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       68
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;Ascenseur.c,86 :: 		Lcd_Chr(1, col+2, 'C');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       2
	ADDWF       FARG_afficher_etage_lcd_col+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;Ascenseur.c,87 :: 		} else {
	GOTO        L_afficher_etage_lcd16
L_afficher_etage_lcd15:
;Ascenseur.c,88 :: 		Lcd_Chr(1, col,   (char)('0' + etage));
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        FARG_afficher_etage_lcd_col+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        FARG_afficher_etage_lcd_etage+0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;Ascenseur.c,89 :: 		Lcd_Chr(1, col+1, ' ');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        FARG_afficher_etage_lcd_col+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;Ascenseur.c,90 :: 		Lcd_Chr(1, col+2, ' ');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       2
	ADDWF       FARG_afficher_etage_lcd_col+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;Ascenseur.c,91 :: 		}
L_afficher_etage_lcd16:
;Ascenseur.c,92 :: 		}
L_end_afficher_etage_lcd:
	RETURN      0
; end of _afficher_etage_lcd

_afficher_lcd:

;Ascenseur.c,95 :: 		void afficher_lcd() {
;Ascenseur.c,96 :: 		if (en_mouvement) {
	MOVF        _en_mouvement+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd17
;Ascenseur.c,97 :: 		l1[0]='E'; l1[1]='T'; l1[2]=':';
	MOVLW       69
	MOVWF       _l1+0 
	MOVLW       84
	MOVWF       _l1+1 
	MOVLW       58
	MOVWF       _l1+2 
;Ascenseur.c,98 :: 		if (etage_actuel==0){l1[3]='R';l1[4]='D';l1[5]='C';}
	MOVF        _etage_actuel+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd18
	MOVLW       82
	MOVWF       _l1+3 
	MOVLW       68
	MOVWF       _l1+4 
	MOVLW       67
	MOVWF       _l1+5 
	GOTO        L_afficher_lcd19
L_afficher_lcd18:
;Ascenseur.c,99 :: 		else {l1[3]=(char)('0'+etage_actuel);l1[4]=' ';l1[5]=' ';}
	MOVF        _etage_actuel+0, 0 
	ADDLW       48
	MOVWF       _l1+3 
	MOVLW       32
	MOVWF       _l1+4 
	MOVLW       32
	MOVWF       _l1+5 
L_afficher_lcd19:
;Ascenseur.c,100 :: 		l1[6]='-'; l1[7]='>';
	MOVLW       45
	MOVWF       _l1+6 
	MOVLW       62
	MOVWF       _l1+7 
;Ascenseur.c,101 :: 		if (etage_cible==0){l1[8]='R';l1[9]='D';l1[10]='C';}
	MOVF        _etage_cible+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd20
	MOVLW       82
	MOVWF       _l1+8 
	MOVLW       68
	MOVWF       _l1+9 
	MOVLW       67
	MOVWF       _l1+10 
	GOTO        L_afficher_lcd21
L_afficher_lcd20:
;Ascenseur.c,102 :: 		else {l1[8]=(char)('0'+etage_cible);l1[9]=' ';l1[10]=' ';}
	MOVF        _etage_cible+0, 0 
	ADDLW       48
	MOVWF       _l1+8 
	MOVLW       32
	MOVWF       _l1+9 
	MOVLW       32
	MOVWF       _l1+10 
L_afficher_lcd21:
;Ascenseur.c,104 :: 		l1[11]='D'; l1[12]=':';
	MOVLW       68
	MOVWF       _l1+11 
	MOVLW       58
	MOVWF       _l1+12 
;Ascenseur.c,105 :: 		if (direction=='U') { l1[13]='U'; l1[14]='P'; }
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd22
	MOVLW       85
	MOVWF       _l1+13 
	MOVLW       80
	MOVWF       _l1+14 
	GOTO        L_afficher_lcd23
L_afficher_lcd22:
;Ascenseur.c,106 :: 		else                { l1[13]='D'; l1[14]='N'; }
	MOVLW       68
	MOVWF       _l1+13 
	MOVLW       78
	MOVWF       _l1+14 
L_afficher_lcd23:
;Ascenseur.c,107 :: 		l1[15]=' '; l1[16]=0;
	MOVLW       32
	MOVWF       _l1+15 
	CLRF        _l1+16 
;Ascenseur.c,108 :: 		} else {
	GOTO        L_afficher_lcd24
L_afficher_lcd17:
;Ascenseur.c,109 :: 		l1[0]='E'; l1[1]='T'; l1[2]=':';
	MOVLW       69
	MOVWF       _l1+0 
	MOVLW       84
	MOVWF       _l1+1 
	MOVLW       58
	MOVWF       _l1+2 
;Ascenseur.c,110 :: 		if (etage_actuel==0){l1[3]='R';l1[4]='D';l1[5]='C';}
	MOVF        _etage_actuel+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd25
	MOVLW       82
	MOVWF       _l1+3 
	MOVLW       68
	MOVWF       _l1+4 
	MOVLW       67
	MOVWF       _l1+5 
	GOTO        L_afficher_lcd26
L_afficher_lcd25:
;Ascenseur.c,111 :: 		else {l1[3]=(char)('0'+etage_actuel);l1[4]=' ';l1[5]=' ';}
	MOVF        _etage_actuel+0, 0 
	ADDLW       48
	MOVWF       _l1+3 
	MOVLW       32
	MOVWF       _l1+4 
	MOVLW       32
	MOVWF       _l1+5 
L_afficher_lcd26:
;Ascenseur.c,112 :: 		l1[6]=' ';l1[7]=' ';l1[8]=' ';l1[9]=' ';
	MOVLW       32
	MOVWF       _l1+6 
	MOVLW       32
	MOVWF       _l1+7 
	MOVLW       32
	MOVWF       _l1+8 
	MOVLW       32
	MOVWF       _l1+9 
;Ascenseur.c,113 :: 		l1[10]='S';l1[11]='T';l1[12]='O';l1[13]='P';
	MOVLW       83
	MOVWF       _l1+10 
	MOVLW       84
	MOVWF       _l1+11 
	MOVLW       79
	MOVWF       _l1+12 
	MOVLW       80
	MOVWF       _l1+13 
;Ascenseur.c,114 :: 		l1[14]=' ';l1[15]=' ';l1[16]=0;
	MOVLW       32
	MOVWF       _l1+14 
	MOVLW       32
	MOVWF       _l1+15 
	CLRF        _l1+16 
;Ascenseur.c,115 :: 		}
L_afficher_lcd24:
;Ascenseur.c,116 :: 		Lcd_Out(1, 1, l1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,117 :: 		sprintf(l2, "P:%3dkg IR:%c %c%c ",
	MOVLW       _l2+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_1_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,118 :: 		(int)poids_kg,
	MOVF        _poids_kg+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _poids_kg+1, 0 
	MOVWF       FARG_sprintf_wh+6 
;Ascenseur.c,119 :: 		ir_porte ? '1' : '0',
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd27
	MOVLW       49
	MOVWF       ?FLOC___afficher_lcdT89+0 
	GOTO        L_afficher_lcd28
L_afficher_lcd27:
	MOVLW       48
	MOVWF       ?FLOC___afficher_lcdT89+0 
L_afficher_lcd28:
	MOVF        ?FLOC___afficher_lcdT89+0, 0 
	MOVWF       FARG_sprintf_wh+7 
;Ascenseur.c,120 :: 		LED1 ? 'V' : '-',
	BTFSS       LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L_afficher_lcd29
	MOVLW       86
	MOVWF       ?FLOC___afficher_lcdT90+0 
	GOTO        L_afficher_lcd30
L_afficher_lcd29:
	MOVLW       45
	MOVWF       ?FLOC___afficher_lcdT90+0 
L_afficher_lcd30:
	MOVF        ?FLOC___afficher_lcdT90+0, 0 
	MOVWF       FARG_sprintf_wh+8 
;Ascenseur.c,121 :: 		LED2 ? 'A' : '-');
	BTFSS       LATA3_bit+0, BitPos(LATA3_bit+0) 
	GOTO        L_afficher_lcd31
	MOVLW       65
	MOVWF       ?FLOC___afficher_lcdT91+0 
	GOTO        L_afficher_lcd32
L_afficher_lcd31:
	MOVLW       45
	MOVWF       ?FLOC___afficher_lcdT91+0 
L_afficher_lcd32:
	MOVF        ?FLOC___afficher_lcdT91+0, 0 
	MOVWF       FARG_sprintf_wh+9 
	CALL        _sprintf+0, 0
;Ascenseur.c,122 :: 		Lcd_Out(2, 1, l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,123 :: 		}
L_end_afficher_lcd:
	RETURN      0
; end of _afficher_lcd

_scanner_req:

;Ascenseur.c,126 :: 		void scanner_req() {
;Ascenseur.c,127 :: 		if (PORTD.F0) req[0] = 1;
	BTFSS       PORTD+0, 0 
	GOTO        L_scanner_req33
	MOVLW       1
	MOVWF       _req+0 
L_scanner_req33:
;Ascenseur.c,128 :: 		if (PORTD.F1) req[1] = 1;
	BTFSS       PORTD+0, 1 
	GOTO        L_scanner_req34
	MOVLW       1
	MOVWF       _req+1 
L_scanner_req34:
;Ascenseur.c,129 :: 		if (PORTD.F2) req[2] = 1;
	BTFSS       PORTD+0, 2 
	GOTO        L_scanner_req35
	MOVLW       1
	MOVWF       _req+2 
L_scanner_req35:
;Ascenseur.c,130 :: 		if (PORTD.F3) req[3] = 1;
	BTFSS       PORTD+0, 3 
	GOTO        L_scanner_req36
	MOVLW       1
	MOVWF       _req+3 
L_scanner_req36:
;Ascenseur.c,131 :: 		}
L_end_scanner_req:
	RETURN      0
; end of _scanner_req

_demarrer_moteur:

;Ascenseur.c,134 :: 		void demarrer_moteur(char sens) {
;Ascenseur.c,135 :: 		if (sens == 'U') MOTEUR_MONTER();
	MOVF        FARG_demarrer_moteur_sens+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_demarrer_moteur37
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	GOTO        L_demarrer_moteur41
L_demarrer_moteur37:
;Ascenseur.c,136 :: 		else             MOTEUR_DESCENDRE();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
L_demarrer_moteur41:
;Ascenseur.c,137 :: 		PWM1_Set_Duty(PWM_MIN);
	MOVLW       80
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,138 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;Ascenseur.c,139 :: 		rampe_accel();
	CALL        _rampe_accel+0, 0
;Ascenseur.c,140 :: 		}
L_end_demarrer_moteur:
	RETURN      0
; end of _demarrer_moteur

_deplacer_vers:

;Ascenseur.c,143 :: 		void deplacer_vers(unsigned char cible) {
;Ascenseur.c,149 :: 		if (cible == etage_actuel) return;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	XORWF       _etage_actuel+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers45
	GOTO        L_end_deplacer_vers
L_deplacer_vers45:
;Ascenseur.c,151 :: 		sens         = (cible > etage_actuel) ? 'U' : 'D';
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers46
	MOVLW       85
	MOVWF       ?FLOC___deplacer_versT104+0 
	GOTO        L_deplacer_vers47
L_deplacer_vers46:
	MOVLW       68
	MOVWF       ?FLOC___deplacer_versT104+0 
L_deplacer_vers47:
	MOVF        ?FLOC___deplacer_versT104+0, 0 
	MOVWF       deplacer_vers_sens_L0+0 
;Ascenseur.c,152 :: 		direction    = sens;
	MOVF        ?FLOC___deplacer_versT104+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,153 :: 		etage_cible  = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,154 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,155 :: 		LED1         = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;Ascenseur.c,157 :: 		? (cible - etage_actuel)
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers48
	MOVF        _etage_actuel+0, 0 
	SUBWF       FARG_deplacer_vers_cible+0, 0 
	MOVWF       ?FLOC___deplacer_versT107+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT107+1 
;Ascenseur.c,158 :: 		: (etage_actuel - cible);
	GOTO        L_deplacer_vers49
L_deplacer_vers48:
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       ?FLOC___deplacer_versT107+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT107+1 
L_deplacer_vers49:
	MOVF        ?FLOC___deplacer_versT107+0, 0 
	MOVWF       deplacer_vers_nb_etages_L0+0 
;Ascenseur.c,160 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,161 :: 		Delay_ms(MS_FERMETURE);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_deplacer_vers50:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers50
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers50
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers50
	NOP
	NOP
;Ascenseur.c,162 :: 		demarrer_moteur(sens);
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       FARG_demarrer_moteur_sens+0 
	CALL        _demarrer_moteur+0, 0
;Ascenseur.c,164 :: 		for (i = 0; i < nb_etages; i++) {
	CLRF        deplacer_vers_i_L0+0 
L_deplacer_vers51:
	MOVF        deplacer_vers_nb_etages_L0+0, 0 
	SUBWF       deplacer_vers_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers52
;Ascenseur.c,165 :: 		est_dernier = (i == nb_etages - 1);
	DECF        deplacer_vers_nb_etages_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers133
	MOVF        R0, 0 
	XORWF       deplacer_vers_i_L0+0, 0 
L__deplacer_vers133:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       deplacer_vers_est_dernier_L0+0 
;Ascenseur.c,166 :: 		PWM1_Set_Duty(PWM_MAX);
	MOVLW       255
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,168 :: 		if (!est_dernier) {
	MOVF        deplacer_vers_est_dernier_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers54
;Ascenseur.c,169 :: 		Delay_ms(MS_CROISIERE);
	MOVLW       19
	MOVWF       R11, 0
	MOVLW       68
	MOVWF       R12, 0
	MOVLW       68
	MOVWF       R13, 0
L_deplacer_vers55:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers55
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers55
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers55
	NOP
;Ascenseur.c,170 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers56
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers57
L_deplacer_vers56:
;Ascenseur.c,171 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers57:
;Ascenseur.c,173 :: 		if (req[etage_actuel]) {
	MOVLW       _req+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR0L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_deplacer_vers58
;Ascenseur.c,174 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,175 :: 		rampe_decel();
	CALL        _rampe_decel+0, 0
;Ascenseur.c,176 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,177 :: 		direction    = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,178 :: 		etage_cible  = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,179 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,180 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,181 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,182 :: 		Delay_ms(MS_OUVERTURE);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_deplacer_vers59:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers59
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers59
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers59
	NOP
;Ascenseur.c,183 :: 		direction    = sens;
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,184 :: 		etage_cible  = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,185 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,186 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,187 :: 		Delay_ms(MS_FERMETURE);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_deplacer_vers60:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers60
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers60
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers60
	NOP
	NOP
;Ascenseur.c,188 :: 		demarrer_moteur(sens);
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       FARG_demarrer_moteur_sens+0 
	CALL        _demarrer_moteur+0, 0
;Ascenseur.c,189 :: 		} else {
	GOTO        L_deplacer_vers61
L_deplacer_vers58:
;Ascenseur.c,190 :: 		afficher_etage_lcd(etage_actuel, 4);
	MOVF        _etage_actuel+0, 0 
	MOVWF       FARG_afficher_etage_lcd_etage+0 
	MOVLW       4
	MOVWF       FARG_afficher_etage_lcd_col+0 
	CALL        _afficher_etage_lcd+0, 0
;Ascenseur.c,191 :: 		}
L_deplacer_vers61:
;Ascenseur.c,192 :: 		} else {
	GOTO        L_deplacer_vers62
L_deplacer_vers54:
;Ascenseur.c,193 :: 		if (nb_etages == 1) {
	MOVF        deplacer_vers_nb_etages_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers63
;Ascenseur.c,194 :: 		Delay_ms(MS_CROISIERE_1ET);
	MOVLW       10
	MOVWF       R11, 0
	MOVLW       34
	MOVWF       R12, 0
	MOVLW       161
	MOVWF       R13, 0
L_deplacer_vers64:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers64
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers64
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers64
;Ascenseur.c,195 :: 		} else {
	GOTO        L_deplacer_vers65
L_deplacer_vers63:
;Ascenseur.c,196 :: 		Delay_ms(MS_CROISIERE);
	MOVLW       19
	MOVWF       R11, 0
	MOVLW       68
	MOVWF       R12, 0
	MOVLW       68
	MOVWF       R13, 0
L_deplacer_vers66:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers66
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers66
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers66
	NOP
;Ascenseur.c,197 :: 		}
L_deplacer_vers65:
;Ascenseur.c,198 :: 		rampe_decel();
	CALL        _rampe_decel+0, 0
;Ascenseur.c,199 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers67
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers68
L_deplacer_vers67:
;Ascenseur.c,200 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers68:
;Ascenseur.c,201 :: 		}
L_deplacer_vers62:
;Ascenseur.c,164 :: 		for (i = 0; i < nb_etages; i++) {
	INCF        deplacer_vers_i_L0+0, 1 
;Ascenseur.c,202 :: 		}
	GOTO        L_deplacer_vers51
L_deplacer_vers52:
;Ascenseur.c,204 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,205 :: 		direction    = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,206 :: 		etage_cible  = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,207 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,208 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,209 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,210 :: 		Delay_ms(MS_OUVERTURE);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_deplacer_vers69:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers69
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers69
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers69
	NOP
;Ascenseur.c,211 :: 		}
L_end_deplacer_vers:
	RETURN      0
; end of _deplacer_vers

_prochain_req:

;Ascenseur.c,214 :: 		unsigned char prochain_req() {
;Ascenseur.c,220 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,222 :: 		if (direction == 'U') {
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req70
;Ascenseur.c,223 :: 		for (i = etage_actuel+1; i < NB_ETAGES; i++)
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       R4 
L_prochain_req71:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req72
;Ascenseur.c,224 :: 		if (req[i]) { req[i]=0; return i; }
	MOVLW       _req+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR0L+1 
	MOVF        R4, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_prochain_req74
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        R4, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
	MOVF        R4, 0 
	MOVWF       R0 
	GOTO        L_end_prochain_req
L_prochain_req74:
;Ascenseur.c,223 :: 		for (i = etage_actuel+1; i < NB_ETAGES; i++)
	INCF        R4, 1 
;Ascenseur.c,224 :: 		if (req[i]) { req[i]=0; return i; }
	GOTO        L_prochain_req71
L_prochain_req72:
;Ascenseur.c,225 :: 		for (i = 0; i < etage_actuel; i++)
	CLRF        R4 
L_prochain_req75:
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req76
;Ascenseur.c,226 :: 		if (req[i]) { req[i]=0; return i; }
	MOVLW       _req+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR0L+1 
	MOVF        R4, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_prochain_req78
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        R4, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
	MOVF        R4, 0 
	MOVWF       R0 
	GOTO        L_end_prochain_req
L_prochain_req78:
;Ascenseur.c,225 :: 		for (i = 0; i < etage_actuel; i++)
	INCF        R4, 1 
;Ascenseur.c,226 :: 		if (req[i]) { req[i]=0; return i; }
	GOTO        L_prochain_req75
L_prochain_req76:
;Ascenseur.c,227 :: 		} else if (direction == 'D') {
	GOTO        L_prochain_req79
L_prochain_req70:
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req80
;Ascenseur.c,228 :: 		for (i = etage_actuel; i > 0; i--)
	MOVF        _etage_actuel+0, 0 
	MOVWF       R4 
L_prochain_req81:
	MOVF        R4, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req82
;Ascenseur.c,229 :: 		if (req[i-1]) { req[i-1]=0; return i-1; }
	DECF        R4, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       _req+0
	ADDWF       R0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_req+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_prochain_req84
	DECF        R4, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       _req+0
	ADDWF       R0, 0 
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
	DECF        R4, 0 
	MOVWF       R0 
	GOTO        L_end_prochain_req
L_prochain_req84:
;Ascenseur.c,228 :: 		for (i = etage_actuel; i > 0; i--)
	DECF        R4, 1 
;Ascenseur.c,229 :: 		if (req[i-1]) { req[i-1]=0; return i-1; }
	GOTO        L_prochain_req81
L_prochain_req82:
;Ascenseur.c,230 :: 		for (i = etage_actuel+1; i < NB_ETAGES; i++)
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       R4 
L_prochain_req85:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req86
;Ascenseur.c,231 :: 		if (req[i]) { req[i]=0; return i; }
	MOVLW       _req+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR0L+1 
	MOVF        R4, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_prochain_req88
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        R4, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
	MOVF        R4, 0 
	MOVWF       R0 
	GOTO        L_end_prochain_req
L_prochain_req88:
;Ascenseur.c,230 :: 		for (i = etage_actuel+1; i < NB_ETAGES; i++)
	INCF        R4, 1 
;Ascenseur.c,231 :: 		if (req[i]) { req[i]=0; return i; }
	GOTO        L_prochain_req85
L_prochain_req86:
;Ascenseur.c,232 :: 		} else {
	GOTO        L_prochain_req89
L_prochain_req80:
;Ascenseur.c,233 :: 		nearest = 0xFF;
	MOVLW       255
	MOVWF       R5 
;Ascenseur.c,234 :: 		min_d   = 10;
	MOVLW       10
	MOVWF       R8 
	MOVLW       0
	MOVWF       R9 
;Ascenseur.c,235 :: 		for (i = 0; i < NB_ETAGES; i++) {
	CLRF        R4 
L_prochain_req90:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req91
;Ascenseur.c,236 :: 		if (!req[i]) continue;
	MOVLW       _req+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR0L+1 
	MOVF        R4, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req93
	GOTO        L_prochain_req92
L_prochain_req93:
;Ascenseur.c,237 :: 		d = (i >= etage_actuel) ? i - etage_actuel : etage_actuel - i;
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_prochain_req94
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
	GOTO        L_prochain_req95
L_prochain_req94:
	MOVF        R4, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
L_prochain_req95:
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
;Ascenseur.c,238 :: 		if (d < min_d) { min_d = d; nearest = i; }
	MOVF        R9, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__prochain_req135
	MOVF        R8, 0 
	SUBWF       R2, 0 
L__prochain_req135:
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req96
	MOVF        R6, 0 
	MOVWF       R8 
	MOVF        R7, 0 
	MOVWF       R9 
	MOVF        R4, 0 
	MOVWF       R5 
L_prochain_req96:
;Ascenseur.c,239 :: 		}
L_prochain_req92:
;Ascenseur.c,235 :: 		for (i = 0; i < NB_ETAGES; i++) {
	INCF        R4, 1 
;Ascenseur.c,239 :: 		}
	GOTO        L_prochain_req90
L_prochain_req91:
;Ascenseur.c,240 :: 		if (nearest != 0xFF) { req[nearest]=0; return nearest; }
	MOVF        R5, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_prochain_req97
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        R5, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
	MOVF        R5, 0 
	MOVWF       R0 
	GOTO        L_end_prochain_req
L_prochain_req97:
;Ascenseur.c,241 :: 		}
L_prochain_req89:
L_prochain_req79:
;Ascenseur.c,242 :: 		return 0xFF;
	MOVLW       255
	MOVWF       R0 
;Ascenseur.c,243 :: 		}
L_end_prochain_req:
	RETURN      0
; end of _prochain_req

_main:

;Ascenseur.c,246 :: 		void main() {
;Ascenseur.c,249 :: 		PWM1_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;Ascenseur.c,250 :: 		PWM1_Set_Duty(0);
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,251 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;Ascenseur.c,253 :: 		TRISC0_bit = 0; TRISC1_bit = 0; TRISC2_bit = 0;
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
	BCF         TRISC1_bit+0, BitPos(TRISC1_bit+0) 
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;Ascenseur.c,254 :: 		LATC0_bit  = 0; LATC1_bit  = 0; LATC2_bit  = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;Ascenseur.c,256 :: 		ANSELA = 0x02; ANSELB = 0x00; ANSELC = 0x00; ANSELD = 0x00;
	MOVLW       2
	MOVWF       ANSELA+0 
	CLRF        ANSELB+0 
	CLRF        ANSELC+0 
	CLRF        ANSELD+0 
;Ascenseur.c,258 :: 		TRISA0_bit = 1; TRISA1_bit = 1; TRISA2_bit = 0; TRISA3_bit = 0;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;Ascenseur.c,259 :: 		TRISC3_bit = 0; TRISC4_bit = 1; TRISC6_bit = 0; TRISC7_bit = 1;
	BCF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;Ascenseur.c,260 :: 		TRISD0_bit = 1; TRISD1_bit = 1; TRISD2_bit = 1; TRISD3_bit = 1;
	BSF         TRISD0_bit+0, BitPos(TRISD0_bit+0) 
	BSF         TRISD1_bit+0, BitPos(TRISD1_bit+0) 
	BSF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
	BSF         TRISD3_bit+0, BitPos(TRISD3_bit+0) 
;Ascenseur.c,261 :: 		TRISD4_bit = 1; TRISB6_bit = 1; TRISB7_bit = 1;
	BSF         TRISD4_bit+0, BitPos(TRISD4_bit+0) 
	BSF         TRISB6_bit+0, BitPos(TRISB6_bit+0) 
	BSF         TRISB7_bit+0, BitPos(TRISB7_bit+0) 
;Ascenseur.c,263 :: 		LATA = 0x00; LATC = 0x00;
	CLRF        LATA+0 
	CLRF        LATC+0 
;Ascenseur.c,265 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;Ascenseur.c,266 :: 		ANSELA = 0x02;
	MOVLW       2
	MOVWF       ANSELA+0 
;Ascenseur.c,267 :: 		TRISA1_bit = 1;
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,269 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;Ascenseur.c,270 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,271 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,272 :: 		Lcd_Out(1, 1, " ASCENSEUR 4ET ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,273 :: 		Lcd_Out(2, 1, "  Pret - RDC   ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,274 :: 		Delay_ms(1500);
	MOVLW       16
	MOVWF       R11, 0
	MOVLW       57
	MOVWF       R12, 0
	MOVLW       13
	MOVWF       R13, 0
L_main98:
	DECFSZ      R13, 1, 1
	BRA         L_main98
	DECFSZ      R12, 1, 1
	BRA         L_main98
	DECFSZ      R11, 1, 1
	BRA         L_main98
	NOP
	NOP
;Ascenseur.c,275 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,277 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,278 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,279 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,281 :: 		while (1) {
L_main99:
;Ascenseur.c,282 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,283 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,284 :: 		scanner_req();
	CALL        _scanner_req+0, 0
;Ascenseur.c,286 :: 		prochain = prochain_req();
	CALL        _prochain_req+0, 0
	MOVF        R0, 0 
	MOVWF       main_prochain_L0+0 
;Ascenseur.c,288 :: 		if (prochain != 0xFF) {
	MOVF        R0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_main101
;Ascenseur.c,290 :: 		if (ir_porte == 1) {
	MOVF        _ir_porte+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main102
;Ascenseur.c,291 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,292 :: 		Lcd_Out(1, 1, "PORTE OUVERTE! ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,293 :: 		Lcd_Out(2, 1, "Veuillez fermer");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,294 :: 		Delay_ms(2000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main103:
	DECFSZ      R13, 1, 1
	BRA         L_main103
	DECFSZ      R12, 1, 1
	BRA         L_main103
	DECFSZ      R11, 1, 1
	BRA         L_main103
	NOP
;Ascenseur.c,295 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,296 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,297 :: 		}
	GOTO        L_main104
L_main102:
;Ascenseur.c,298 :: 		else if (poids_kg >= SEUIL_SURCHARGE) {
	MOVLW       2
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main137
	MOVLW       181
	SUBWF       _poids_kg+0, 0 
L__main137:
	BTFSS       STATUS+0, 0 
	GOTO        L_main105
;Ascenseur.c,299 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,300 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;Ascenseur.c,301 :: 		PWM1_Set_Duty(0);
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,302 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,303 :: 		Lcd_Out(1, 1, "  SURCHARGE!   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,304 :: 		Lcd_Out(2, 1, "  MAX: 630 kg  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,305 :: 		Delay_ms(2000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main109:
	DECFSZ      R13, 1, 1
	BRA         L_main109
	DECFSZ      R12, 1, 1
	BRA         L_main109
	DECFSZ      R11, 1, 1
	BRA         L_main109
	NOP
;Ascenseur.c,306 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,307 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,308 :: 		} else {
	GOTO        L_main110
L_main105:
;Ascenseur.c,309 :: 		deplacer_vers(prochain);
	MOVF        main_prochain_L0+0, 0 
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,310 :: 		while (1) {
L_main111:
;Ascenseur.c,311 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,312 :: 		prochain = prochain_req();
	CALL        _prochain_req+0, 0
	MOVF        R0, 0 
	MOVWF       main_prochain_L0+0 
;Ascenseur.c,313 :: 		if (prochain == 0xFF) break;
	MOVF        R0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_main113
	GOTO        L_main112
L_main113:
;Ascenseur.c,315 :: 		if (ir_porte == 1 || poids_kg >= SEUIL_SURCHARGE) break;
	MOVF        _ir_porte+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L__main118
	MOVLW       2
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main138
	MOVLW       181
	SUBWF       _poids_kg+0, 0 
L__main138:
	BTFSC       STATUS+0, 0 
	GOTO        L__main118
	GOTO        L_main116
L__main118:
	GOTO        L_main112
L_main116:
;Ascenseur.c,316 :: 		deplacer_vers(prochain);
	MOVF        main_prochain_L0+0, 0 
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,317 :: 		}
	GOTO        L_main111
L_main112:
;Ascenseur.c,318 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,319 :: 		}
L_main110:
L_main104:
;Ascenseur.c,320 :: 		}
L_main101:
;Ascenseur.c,321 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,322 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main117:
	DECFSZ      R13, 1, 1
	BRA         L_main117
	DECFSZ      R12, 1, 1
	BRA         L_main117
	NOP
	NOP
;Ascenseur.c,323 :: 		}
	GOTO        L_main99
;Ascenseur.c,324 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
