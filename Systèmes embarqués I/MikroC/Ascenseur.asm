
_lire_capteurs:

;Ascenseur.c,35 :: 		void lire_capteurs() {
;Ascenseur.c,36 :: 		ir_porte = PORTA.F0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       _ir_porte+0 
;Ascenseur.c,37 :: 		poids_kg = (unsigned int)((ADC_Read(1) * 900UL) / 1023UL);
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
;Ascenseur.c,38 :: 		}
L_end_lire_capteurs:
	RETURN      0
; end of _lire_capteurs

_gerer_leds:

;Ascenseur.c,40 :: 		void gerer_leds() {
;Ascenseur.c,41 :: 		LED1 = (!en_mouvement && ir_porte == 0) ? 1 : 0;
	MOVF        _en_mouvement+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_gerer_leds2
	MOVF        _ir_porte+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_gerer_leds2
L__gerer_leds97:
	MOVLW       1
	MOVWF       R1 
	GOTO        L_gerer_leds3
L_gerer_leds2:
	CLRF        R1 
L_gerer_leds3:
	BTFSC       R1, 0 
	GOTO        L__gerer_leds100
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L__gerer_leds101
L__gerer_leds100:
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
L__gerer_leds101:
;Ascenseur.c,42 :: 		LED2 = (poids_kg >= SEUIL_SURCHARGE)    ? 1 : 0;
	MOVLW       2
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds102
	MOVLW       181
	SUBWF       _poids_kg+0, 0 
L__gerer_leds102:
	BTFSS       STATUS+0, 0 
	GOTO        L_gerer_leds4
	MOVLW       1
	MOVWF       R2 
	GOTO        L_gerer_leds5
L_gerer_leds4:
	CLRF        R2 
L_gerer_leds5:
	BTFSC       R2, 0 
	GOTO        L__gerer_leds103
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
	GOTO        L__gerer_leds104
L__gerer_leds103:
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
L__gerer_leds104:
;Ascenseur.c,43 :: 		}
L_end_gerer_leds:
	RETURN      0
; end of _gerer_leds

_afficher_lcd:

;Ascenseur.c,45 :: 		void afficher_lcd() {
;Ascenseur.c,46 :: 		if (en_mouvement) {
	MOVF        _en_mouvement+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd6
;Ascenseur.c,47 :: 		l1[0]='E'; l1[1]='T'; l1[2]=':';
	MOVLW       69
	MOVWF       _l1+0 
	MOVLW       84
	MOVWF       _l1+1 
	MOVLW       58
	MOVWF       _l1+2 
;Ascenseur.c,48 :: 		l1[3]=(char)('0'+etage_actuel);
	MOVF        _etage_actuel+0, 0 
	ADDLW       48
	MOVWF       _l1+3 
;Ascenseur.c,49 :: 		l1[4]='-'; l1[5]='>';
	MOVLW       45
	MOVWF       _l1+4 
	MOVLW       62
	MOVWF       _l1+5 
;Ascenseur.c,50 :: 		l1[6]=(char)('0'+etage_cible);
	MOVF        _etage_cible+0, 0 
	ADDLW       48
	MOVWF       _l1+6 
;Ascenseur.c,51 :: 		l1[7]=' '; l1[8]='D'; l1[9]='I'; l1[10]='R'; l1[11]=':';
	MOVLW       32
	MOVWF       _l1+7 
	MOVLW       68
	MOVWF       _l1+8 
	MOVLW       73
	MOVWF       _l1+9 
	MOVLW       82
	MOVWF       _l1+10 
	MOVLW       58
	MOVWF       _l1+11 
;Ascenseur.c,52 :: 		if (direction=='U') { l1[12]='U'; l1[13]='P'; l1[14]=' '; }
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd7
	MOVLW       85
	MOVWF       _l1+12 
	MOVLW       80
	MOVWF       _l1+13 
	MOVLW       32
	MOVWF       _l1+14 
	GOTO        L_afficher_lcd8
L_afficher_lcd7:
;Ascenseur.c,53 :: 		else                { l1[12]='D'; l1[13]='W'; l1[14]='N'; }
	MOVLW       68
	MOVWF       _l1+12 
	MOVLW       87
	MOVWF       _l1+13 
	MOVLW       78
	MOVWF       _l1+14 
L_afficher_lcd8:
;Ascenseur.c,54 :: 		l1[15]=' '; l1[16]=0;
	MOVLW       32
	MOVWF       _l1+15 
	CLRF        _l1+16 
;Ascenseur.c,55 :: 		} else {
	GOTO        L_afficher_lcd9
L_afficher_lcd6:
;Ascenseur.c,56 :: 		l1[0]='E'; l1[1]='T'; l1[2]=':';
	MOVLW       69
	MOVWF       _l1+0 
	MOVLW       84
	MOVWF       _l1+1 
	MOVLW       58
	MOVWF       _l1+2 
;Ascenseur.c,57 :: 		l1[3]=(char)('0'+etage_actuel);
	MOVF        _etage_actuel+0, 0 
	ADDLW       48
	MOVWF       _l1+3 
;Ascenseur.c,58 :: 		l1[4]=' '; l1[5]=' '; l1[6]=' ';
	MOVLW       32
	MOVWF       _l1+4 
	MOVLW       32
	MOVWF       _l1+5 
	MOVLW       32
	MOVWF       _l1+6 
;Ascenseur.c,59 :: 		l1[7]=' '; l1[8]='D'; l1[9]='I'; l1[10]='R'; l1[11]=':';
	MOVLW       32
	MOVWF       _l1+7 
	MOVLW       68
	MOVWF       _l1+8 
	MOVLW       73
	MOVWF       _l1+9 
	MOVLW       82
	MOVWF       _l1+10 
	MOVLW       58
	MOVWF       _l1+11 
;Ascenseur.c,60 :: 		l1[12]='-'; l1[13]='-'; l1[14]='-';
	MOVLW       45
	MOVWF       _l1+12 
	MOVLW       45
	MOVWF       _l1+13 
	MOVLW       45
	MOVWF       _l1+14 
;Ascenseur.c,61 :: 		l1[15]=' '; l1[16]=0;
	MOVLW       32
	MOVWF       _l1+15 
	CLRF        _l1+16 
;Ascenseur.c,62 :: 		}
L_afficher_lcd9:
;Ascenseur.c,63 :: 		Lcd_Out(1, 1, l1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,64 :: 		sprintf(l2, "P:%3dkg IR:%c %c%c ",
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
;Ascenseur.c,65 :: 		(int)poids_kg,
	MOVF        _poids_kg+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _poids_kg+1, 0 
	MOVWF       FARG_sprintf_wh+6 
;Ascenseur.c,66 :: 		ir_porte ? '1' : '0',
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd10
	MOVLW       49
	MOVWF       ?FLOC___afficher_lcdT58+0 
	GOTO        L_afficher_lcd11
L_afficher_lcd10:
	MOVLW       48
	MOVWF       ?FLOC___afficher_lcdT58+0 
L_afficher_lcd11:
	MOVF        ?FLOC___afficher_lcdT58+0, 0 
	MOVWF       FARG_sprintf_wh+7 
;Ascenseur.c,67 :: 		LED1 ? 'V' : '-',
	BTFSS       LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L_afficher_lcd12
	MOVLW       86
	MOVWF       ?FLOC___afficher_lcdT59+0 
	GOTO        L_afficher_lcd13
L_afficher_lcd12:
	MOVLW       45
	MOVWF       ?FLOC___afficher_lcdT59+0 
L_afficher_lcd13:
	MOVF        ?FLOC___afficher_lcdT59+0, 0 
	MOVWF       FARG_sprintf_wh+8 
;Ascenseur.c,68 :: 		LED2 ? 'A' : '-');
	BTFSS       LATA3_bit+0, BitPos(LATA3_bit+0) 
	GOTO        L_afficher_lcd14
	MOVLW       65
	MOVWF       ?FLOC___afficher_lcdT60+0 
	GOTO        L_afficher_lcd15
L_afficher_lcd14:
	MOVLW       45
	MOVWF       ?FLOC___afficher_lcdT60+0 
L_afficher_lcd15:
	MOVF        ?FLOC___afficher_lcdT60+0, 0 
	MOVWF       FARG_sprintf_wh+9 
	CALL        _sprintf+0, 0
;Ascenseur.c,69 :: 		Lcd_Out(2, 1, l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,70 :: 		}
L_end_afficher_lcd:
	RETURN      0
; end of _afficher_lcd

_scanner_req:

;Ascenseur.c,72 :: 		void scanner_req() {
;Ascenseur.c,73 :: 		if (PORTD.F0) req[0] = 1;
	BTFSS       PORTD+0, 0 
	GOTO        L_scanner_req16
	MOVLW       1
	MOVWF       _req+0 
L_scanner_req16:
;Ascenseur.c,74 :: 		if (PORTD.F1) req[1] = 1;
	BTFSS       PORTD+0, 1 
	GOTO        L_scanner_req17
	MOVLW       1
	MOVWF       _req+1 
L_scanner_req17:
;Ascenseur.c,75 :: 		if (PORTD.F2) req[2] = 1;
	BTFSS       PORTD+0, 2 
	GOTO        L_scanner_req18
	MOVLW       1
	MOVWF       _req+2 
L_scanner_req18:
;Ascenseur.c,76 :: 		if (PORTD.F3) req[3] = 1;
	BTFSS       PORTD+0, 3 
	GOTO        L_scanner_req19
	MOVLW       1
	MOVWF       _req+3 
L_scanner_req19:
;Ascenseur.c,77 :: 		}
L_end_scanner_req:
	RETURN      0
; end of _scanner_req

_deplacer_vers:

;Ascenseur.c,79 :: 		void deplacer_vers(unsigned char cible) {
;Ascenseur.c,84 :: 		if (cible == etage_actuel) return;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	XORWF       _etage_actuel+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers20
	GOTO        L_end_deplacer_vers
L_deplacer_vers20:
;Ascenseur.c,86 :: 		sens         = (cible > etage_actuel) ? 'U' : 'D';
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers21
	MOVLW       85
	MOVWF       ?FLOC___deplacer_versT72+0 
	GOTO        L_deplacer_vers22
L_deplacer_vers21:
	MOVLW       68
	MOVWF       ?FLOC___deplacer_versT72+0 
L_deplacer_vers22:
	MOVF        ?FLOC___deplacer_versT72+0, 0 
	MOVWF       deplacer_vers_sens_L0+0 
;Ascenseur.c,87 :: 		direction    = sens;
	MOVF        ?FLOC___deplacer_versT72+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,88 :: 		etage_cible  = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,89 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,90 :: 		LED1         = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;Ascenseur.c,93 :: 		? (cible - etage_actuel)
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers23
	MOVF        _etage_actuel+0, 0 
	SUBWF       FARG_deplacer_vers_cible+0, 0 
	MOVWF       ?FLOC___deplacer_versT75+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT75+1 
;Ascenseur.c,94 :: 		: (etage_actuel - cible);
	GOTO        L_deplacer_vers24
L_deplacer_vers23:
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       ?FLOC___deplacer_versT75+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT75+1 
L_deplacer_vers24:
	MOVF        ?FLOC___deplacer_versT75+0, 0 
	MOVWF       deplacer_vers_nb_etages_L0+0 
;Ascenseur.c,97 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,98 :: 		Delay_ms(MS_FERMETURE);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_deplacer_vers25:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers25
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers25
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers25
	NOP
	NOP
;Ascenseur.c,99 :: 		MOTEUR_ON();
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;Ascenseur.c,100 :: 		for (i = 0; i < nb_etages - 1; i++) {
	CLRF        deplacer_vers_i_L0+0 
L_deplacer_vers29:
	DECF        deplacer_vers_nb_etages_L0+0, 0 
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	SUBWFB      R2, 1 
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers108
	MOVF        R1, 0 
	SUBWF       deplacer_vers_i_L0+0, 0 
L__deplacer_vers108:
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers30
;Ascenseur.c,102 :: 		Delay_ms(MS_PAR_ETAGE);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_deplacer_vers32:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers32
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers32
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers32
	NOP
;Ascenseur.c,104 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers33
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers34
L_deplacer_vers33:
;Ascenseur.c,105 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers34:
;Ascenseur.c,108 :: 		if (req[etage_actuel]) {
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
	GOTO        L_deplacer_vers35
;Ascenseur.c,109 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,112 :: 		MOTEUR_OFF();
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;Ascenseur.c,113 :: 		Delay_ms(MS_DECEL);
	MOVLW       5
	MOVWF       R11, 0
	MOVLW       15
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_deplacer_vers39:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers39
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers39
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers39
;Ascenseur.c,114 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,115 :: 		direction    = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,116 :: 		etage_cible  = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,117 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,118 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,119 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,120 :: 		Delay_ms(MS_OUVERTURE);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_deplacer_vers40:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers40
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers40
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers40
	NOP
;Ascenseur.c,123 :: 		direction    = sens;
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,124 :: 		etage_cible  = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,125 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,126 :: 		LED1         = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;Ascenseur.c,127 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,128 :: 		Delay_ms(MS_FERMETURE);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_deplacer_vers41:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers41
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers41
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers41
	NOP
	NOP
;Ascenseur.c,129 :: 		MOTEUR_ON();
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;Ascenseur.c,130 :: 		} else {
	GOTO        L_deplacer_vers45
L_deplacer_vers35:
;Ascenseur.c,132 :: 		Lcd_Chr(1, 4, (char)('0' + etage_actuel));
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _etage_actuel+0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;Ascenseur.c,133 :: 		}
L_deplacer_vers45:
;Ascenseur.c,100 :: 		for (i = 0; i < nb_etages - 1; i++) {
	INCF        deplacer_vers_i_L0+0, 1 
;Ascenseur.c,134 :: 		}
	GOTO        L_deplacer_vers29
L_deplacer_vers30:
;Ascenseur.c,136 :: 		Delay_ms(MS_PAR_ETAGE);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_deplacer_vers46:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers46
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers46
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers46
	NOP
;Ascenseur.c,138 :: 		MOTEUR_OFF();
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;Ascenseur.c,139 :: 		Delay_ms(MS_DECEL);
	MOVLW       5
	MOVWF       R11, 0
	MOVLW       15
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_deplacer_vers50:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers50
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers50
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers50
;Ascenseur.c,141 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers51
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers52
L_deplacer_vers51:
;Ascenseur.c,142 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers52:
;Ascenseur.c,144 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,145 :: 		direction    = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,146 :: 		etage_cible  = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,147 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,148 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,149 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,150 :: 		Delay_ms(MS_OUVERTURE);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_deplacer_vers53:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers53
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers53
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers53
	NOP
;Ascenseur.c,151 :: 		}
L_end_deplacer_vers:
	RETURN      0
; end of _deplacer_vers

_prochain_req:

;Ascenseur.c,153 :: 		unsigned char prochain_req() {
;Ascenseur.c,157 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,159 :: 		if (direction == 'U') {
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req54
;Ascenseur.c,160 :: 		for (i = etage_actuel+1; i <= 3; i++)
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       R4 
L_prochain_req55:
	MOVF        R4, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_prochain_req56
;Ascenseur.c,161 :: 		if (req[i]) { req[i]=0; return i; }
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
	GOTO        L_prochain_req58
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
L_prochain_req58:
;Ascenseur.c,160 :: 		for (i = etage_actuel+1; i <= 3; i++)
	INCF        R4, 1 
;Ascenseur.c,161 :: 		if (req[i]) { req[i]=0; return i; }
	GOTO        L_prochain_req55
L_prochain_req56:
;Ascenseur.c,162 :: 		for (i = 0; i < etage_actuel; i++)
	CLRF        R4 
L_prochain_req59:
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req60
;Ascenseur.c,163 :: 		if (req[i]) { req[i]=0; return i; }
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
	GOTO        L_prochain_req62
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
L_prochain_req62:
;Ascenseur.c,162 :: 		for (i = 0; i < etage_actuel; i++)
	INCF        R4, 1 
;Ascenseur.c,163 :: 		if (req[i]) { req[i]=0; return i; }
	GOTO        L_prochain_req59
L_prochain_req60:
;Ascenseur.c,164 :: 		} else if (direction == 'D') {
	GOTO        L_prochain_req63
L_prochain_req54:
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req64
;Ascenseur.c,165 :: 		for (i = etage_actuel; i > 0; i--)
	MOVF        _etage_actuel+0, 0 
	MOVWF       R4 
L_prochain_req65:
	MOVF        R4, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req66
;Ascenseur.c,166 :: 		if (req[i-1]) { req[i-1]=0; return i-1; }
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
	GOTO        L_prochain_req68
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
L_prochain_req68:
;Ascenseur.c,165 :: 		for (i = etage_actuel; i > 0; i--)
	DECF        R4, 1 
;Ascenseur.c,166 :: 		if (req[i-1]) { req[i-1]=0; return i-1; }
	GOTO        L_prochain_req65
L_prochain_req66:
;Ascenseur.c,167 :: 		for (i = etage_actuel+1; i <= 3; i++)
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       R4 
L_prochain_req69:
	MOVF        R4, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_prochain_req70
;Ascenseur.c,168 :: 		if (req[i]) { req[i]=0; return i; }
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
	GOTO        L_prochain_req72
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
L_prochain_req72:
;Ascenseur.c,167 :: 		for (i = etage_actuel+1; i <= 3; i++)
	INCF        R4, 1 
;Ascenseur.c,168 :: 		if (req[i]) { req[i]=0; return i; }
	GOTO        L_prochain_req69
L_prochain_req70:
;Ascenseur.c,169 :: 		} else {
	GOTO        L_prochain_req73
L_prochain_req64:
;Ascenseur.c,170 :: 		nearest=0xFF; min_d=10;
	MOVLW       255
	MOVWF       R5 
	MOVLW       10
	MOVWF       R8 
	MOVLW       0
	MOVWF       R9 
;Ascenseur.c,171 :: 		for (i=0; i<=3; i++) {
	CLRF        R4 
L_prochain_req74:
	MOVF        R4, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_prochain_req75
;Ascenseur.c,172 :: 		if (!req[i]) continue;
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
	GOTO        L_prochain_req77
	GOTO        L_prochain_req76
L_prochain_req77:
;Ascenseur.c,173 :: 		d = (i>=etage_actuel) ? i-etage_actuel : etage_actuel-i;
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_prochain_req78
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
	GOTO        L_prochain_req79
L_prochain_req78:
	MOVF        R4, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
L_prochain_req79:
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
;Ascenseur.c,174 :: 		if (d<min_d) { min_d=d; nearest=i; }
	MOVF        R9, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__prochain_req110
	MOVF        R8, 0 
	SUBWF       R2, 0 
L__prochain_req110:
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req80
	MOVF        R6, 0 
	MOVWF       R8 
	MOVF        R7, 0 
	MOVWF       R9 
	MOVF        R4, 0 
	MOVWF       R5 
L_prochain_req80:
;Ascenseur.c,175 :: 		}
L_prochain_req76:
;Ascenseur.c,171 :: 		for (i=0; i<=3; i++) {
	INCF        R4, 1 
;Ascenseur.c,175 :: 		}
	GOTO        L_prochain_req74
L_prochain_req75:
;Ascenseur.c,176 :: 		if (nearest!=0xFF) { req[nearest]=0; return nearest; }
	MOVF        R5, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_prochain_req81
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
L_prochain_req81:
;Ascenseur.c,177 :: 		}
L_prochain_req73:
L_prochain_req63:
;Ascenseur.c,178 :: 		return 0xFF;
	MOVLW       255
	MOVWF       R0 
;Ascenseur.c,179 :: 		}
L_end_prochain_req:
	RETURN      0
; end of _prochain_req

_main:

;Ascenseur.c,180 :: 		void main() {
;Ascenseur.c,183 :: 		CCP1CON    = 0x00;
	CLRF        CCP1CON+0 
;Ascenseur.c,184 :: 		TRISC2_bit = 0;
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;Ascenseur.c,185 :: 		LATC2_bit  = 0;
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;Ascenseur.c,187 :: 		ANSELA = 0x02;
	MOVLW       2
	MOVWF       ANSELA+0 
;Ascenseur.c,188 :: 		ANSELB = 0x00;
	CLRF        ANSELB+0 
;Ascenseur.c,189 :: 		ANSELC = 0x00;
	CLRF        ANSELC+0 
;Ascenseur.c,190 :: 		ANSELD = 0x00;
	CLRF        ANSELD+0 
;Ascenseur.c,192 :: 		TRISA0_bit = 1;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Ascenseur.c,193 :: 		TRISA1_bit = 1;
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,194 :: 		TRISA2_bit = 0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;Ascenseur.c,195 :: 		TRISA3_bit = 0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;Ascenseur.c,196 :: 		TRISC2_bit = 0;
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;Ascenseur.c,197 :: 		TRISC3_bit = 0;
	BCF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;Ascenseur.c,198 :: 		TRISC4_bit = 1;
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;Ascenseur.c,199 :: 		TRISC6_bit = 0;
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;Ascenseur.c,200 :: 		TRISC7_bit = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;Ascenseur.c,201 :: 		TRISD0_bit = 1;
	BSF         TRISD0_bit+0, BitPos(TRISD0_bit+0) 
;Ascenseur.c,202 :: 		TRISD1_bit = 1;
	BSF         TRISD1_bit+0, BitPos(TRISD1_bit+0) 
;Ascenseur.c,203 :: 		TRISD2_bit = 1;
	BSF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
;Ascenseur.c,204 :: 		TRISD3_bit = 1;
	BSF         TRISD3_bit+0, BitPos(TRISD3_bit+0) 
;Ascenseur.c,205 :: 		TRISD4_bit = 1;
	BSF         TRISD4_bit+0, BitPos(TRISD4_bit+0) 
;Ascenseur.c,206 :: 		TRISB6_bit = 1;
	BSF         TRISB6_bit+0, BitPos(TRISB6_bit+0) 
;Ascenseur.c,207 :: 		TRISB7_bit = 1;
	BSF         TRISB7_bit+0, BitPos(TRISB7_bit+0) 
;Ascenseur.c,209 :: 		LATA = 0x00;
	CLRF        LATA+0 
;Ascenseur.c,210 :: 		LATC = 0x00;
	CLRF        LATC+0 
;Ascenseur.c,212 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;Ascenseur.c,213 :: 		ANSELA     = 0x02;
	MOVLW       2
	MOVWF       ANSELA+0 
;Ascenseur.c,214 :: 		TRISA0_bit = 1;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Ascenseur.c,216 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;Ascenseur.c,217 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,218 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,219 :: 		Lcd_Out(1, 1, " ASCENSEUR 4ET ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,220 :: 		Lcd_Out(2, 1, "  Pret - ET:0  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,221 :: 		Delay_ms(1500);
	MOVLW       16
	MOVWF       R11, 0
	MOVLW       57
	MOVWF       R12, 0
	MOVLW       13
	MOVWF       R13, 0
L_main82:
	DECFSZ      R13, 1, 1
	BRA         L_main82
	DECFSZ      R12, 1, 1
	BRA         L_main82
	DECFSZ      R11, 1, 1
	BRA         L_main82
	NOP
	NOP
;Ascenseur.c,222 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,224 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,225 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,226 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,228 :: 		while (1) {
L_main83:
;Ascenseur.c,229 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,230 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,231 :: 		scanner_req();
	CALL        _scanner_req+0, 0
;Ascenseur.c,233 :: 		prochain = prochain_req();
	CALL        _prochain_req+0, 0
	MOVF        R0, 0 
	MOVWF       main_prochain_L0+0 
;Ascenseur.c,235 :: 		if (prochain != 0xFF) {
	MOVF        R0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_main85
;Ascenseur.c,236 :: 		if (poids_kg >= SEUIL_SURCHARGE) {
	MOVLW       2
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main112
	MOVLW       181
	SUBWF       _poids_kg+0, 0 
L__main112:
	BTFSS       STATUS+0, 0 
	GOTO        L_main86
;Ascenseur.c,237 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,238 :: 		MOTEUR_OFF();
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;Ascenseur.c,239 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,240 :: 		Lcd_Out(1, 1, "  SURCHARGE!  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,241 :: 		Lcd_Out(2, 1, " MAX: 630 kg  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,242 :: 		Delay_ms(2000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main90:
	DECFSZ      R13, 1, 1
	BRA         L_main90
	DECFSZ      R12, 1, 1
	BRA         L_main90
	DECFSZ      R11, 1, 1
	BRA         L_main90
	NOP
;Ascenseur.c,243 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,244 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,245 :: 		} else {
	GOTO        L_main91
L_main86:
;Ascenseur.c,246 :: 		deplacer_vers(prochain);
	MOVF        main_prochain_L0+0, 0 
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,247 :: 		while (1) {
L_main92:
;Ascenseur.c,248 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,249 :: 		prochain = prochain_req();
	CALL        _prochain_req+0, 0
	MOVF        R0, 0 
	MOVWF       main_prochain_L0+0 
;Ascenseur.c,250 :: 		if (prochain == 0xFF) break;
	MOVF        R0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_main94
	GOTO        L_main93
L_main94:
;Ascenseur.c,251 :: 		if (poids_kg >= SEUIL_SURCHARGE) break;
	MOVLW       2
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main113
	MOVLW       181
	SUBWF       _poids_kg+0, 0 
L__main113:
	BTFSS       STATUS+0, 0 
	GOTO        L_main95
	GOTO        L_main93
L_main95:
;Ascenseur.c,252 :: 		deplacer_vers(prochain);
	MOVF        main_prochain_L0+0, 0 
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,253 :: 		}
	GOTO        L_main92
L_main93:
;Ascenseur.c,254 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,255 :: 		}
L_main91:
;Ascenseur.c,256 :: 		}
L_main85:
;Ascenseur.c,257 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,258 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main96:
	DECFSZ      R13, 1, 1
	BRA         L_main96
	DECFSZ      R12, 1, 1
	BRA         L_main96
	NOP
	NOP
;Ascenseur.c,259 :: 		}
	GOTO        L_main83
;Ascenseur.c,260 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
