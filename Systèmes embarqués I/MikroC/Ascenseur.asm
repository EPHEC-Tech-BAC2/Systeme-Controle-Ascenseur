
_uart_send_data:

;Ascenseur.c,49 :: 		void uart_send_data() {
;Ascenseur.c,54 :: 		if      (direction == 'U') dir_n = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data0
	MOVLW       1
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data1
L_uart_send_data0:
;Ascenseur.c,55 :: 		else if (direction == 'D') dir_n = 2;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data2
	MOVLW       2
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data3
L_uart_send_data2:
;Ascenseur.c,56 :: 		else                       dir_n = 0;
	CLRF        uart_send_data_dir_n_L0+0 
L_uart_send_data3:
L_uart_send_data1:
;Ascenseur.c,58 :: 		prt_n = ir_porte ? 1 : 0;
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data4
	MOVLW       1
	MOVWF       ?FLOC___uart_send_dataT2+0 
	GOTO        L_uart_send_data5
L_uart_send_data4:
	CLRF        ?FLOC___uart_send_dataT2+0 
L_uart_send_data5:
;Ascenseur.c,60 :: 		sprintf(trame,
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_sprintf_wh+1 
;Ascenseur.c,61 :: 		"<DATA,ET:%d,DIR:%d,PT:%d,PRT:%d,AL:%d,URG:%d>\r\n",
	MOVLW       ?lstr_1_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,62 :: 		(int)etage_actuel, (int)dir_n, (int)poids_kg,
	MOVF        _etage_actuel+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+6 
	MOVF        uart_send_data_dir_n_L0+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+8 
	MOVF        _poids_kg+0, 0 
	MOVWF       FARG_sprintf_wh+9 
	MOVF        _poids_kg+1, 0 
	MOVWF       FARG_sprintf_wh+10 
;Ascenseur.c,63 :: 		(int)prt_n, (int)al_active, (int)urg_active);
	MOVF        ?FLOC___uart_send_dataT2+0, 0 
	MOVWF       FARG_sprintf_wh+11 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+12 
	MOVF        _al_active+0, 0 
	MOVWF       FARG_sprintf_wh+13 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+14 
	MOVF        _urg_active+0, 0 
	MOVWF       FARG_sprintf_wh+15 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+16 
	CALL        _sprintf+0, 0
;Ascenseur.c,64 :: 		UART1_Write_Text(trame);
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,65 :: 		}
L_end_uart_send_data:
	RETURN      0
; end of _uart_send_data

_lire_capteurs:

;Ascenseur.c,67 :: 		void lire_capteurs() {
;Ascenseur.c,68 :: 		ir_porte = PORTA.F0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       _ir_porte+0 
;Ascenseur.c,69 :: 		poids_kg = (unsigned int)((ADC_Read(1) * 900UL) / 1023UL);
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
;Ascenseur.c,70 :: 		}
L_end_lire_capteurs:
	RETURN      0
; end of _lire_capteurs

_gerer_leds:

;Ascenseur.c,72 :: 		void gerer_leds() {
;Ascenseur.c,73 :: 		LED1 = ir_porte ? 1 : 0;
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_leds6
	MOVLW       1
	MOVWF       R1 
	GOTO        L_gerer_leds7
L_gerer_leds6:
	CLRF        R1 
L_gerer_leds7:
	BTFSC       R1, 0 
	GOTO        L__gerer_leds86
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L__gerer_leds87
L__gerer_leds86:
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
L__gerer_leds87:
;Ascenseur.c,74 :: 		LED2 = (poids_kg >= seuil_surge || urg_active || al_active) ? 1 : 0;
	MOVF        _seuil_surge+1, 0 
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds88
	MOVF        _seuil_surge+0, 0 
	SUBWF       _poids_kg+0, 0 
L__gerer_leds88:
	BTFSC       STATUS+0, 0 
	GOTO        L__gerer_leds80
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds80
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds80
	GOTO        L_gerer_leds10
L__gerer_leds80:
	MOVLW       1
	MOVWF       R2 
	GOTO        L_gerer_leds11
L_gerer_leds10:
	CLRF        R2 
L_gerer_leds11:
	BTFSC       R2, 0 
	GOTO        L__gerer_leds89
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
	GOTO        L__gerer_leds90
L__gerer_leds89:
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
L__gerer_leds90:
;Ascenseur.c,75 :: 		}
L_end_gerer_leds:
	RETURN      0
; end of _gerer_leds

_afficher_lcd:

;Ascenseur.c,77 :: 		void afficher_lcd() {
;Ascenseur.c,78 :: 		if (en_mouvement) {
	MOVF        _en_mouvement+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd12
;Ascenseur.c,79 :: 		sprintf(l1, "ET:%u->%u %s     ",
	MOVLW       _l1+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_2_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_2_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_2_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,80 :: 		(unsigned)etage_actuel,
	MOVF        _etage_actuel+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+6 
;Ascenseur.c,81 :: 		(unsigned)etage_cible,
	MOVF        _etage_cible+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+8 
;Ascenseur.c,82 :: 		(direction == 'U') ? "UP" : "DN");
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd13
	MOVLW       ?lstr_3_Ascenseur+0
	MOVWF       ?FLOC___afficher_lcdT26+0 
	MOVLW       hi_addr(?lstr_3_Ascenseur+0)
	MOVWF       ?FLOC___afficher_lcdT26+1 
	MOVLW       higher_addr(?lstr_3_Ascenseur+0)
	MOVWF       ?FLOC___afficher_lcdT26+2 
	GOTO        L_afficher_lcd14
L_afficher_lcd13:
	MOVLW       ?lstr_4_Ascenseur+0
	MOVWF       ?FLOC___afficher_lcdT26+0 
	MOVLW       hi_addr(?lstr_4_Ascenseur+0)
	MOVWF       ?FLOC___afficher_lcdT26+1 
	MOVLW       higher_addr(?lstr_4_Ascenseur+0)
	MOVWF       ?FLOC___afficher_lcdT26+2 
L_afficher_lcd14:
	MOVF        ?FLOC___afficher_lcdT26+0, 0 
	MOVWF       FARG_sprintf_wh+9 
	MOVF        ?FLOC___afficher_lcdT26+1, 0 
	MOVWF       FARG_sprintf_wh+10 
	MOVF        ?FLOC___afficher_lcdT26+2, 0 
	MOVWF       FARG_sprintf_wh+11 
	CALL        _sprintf+0, 0
;Ascenseur.c,83 :: 		} else {
	GOTO        L_afficher_lcd15
L_afficher_lcd12:
;Ascenseur.c,84 :: 		sprintf(l1, "ET:%u STOP       ",
	MOVLW       _l1+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_5_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_5_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_5_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,85 :: 		(unsigned)etage_actuel);
	MOVF        _etage_actuel+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
;Ascenseur.c,86 :: 		}
L_afficher_lcd15:
;Ascenseur.c,87 :: 		Lcd_Out(1, 1, l1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,89 :: 		sprintf(l2, "P:%3dkg IR:%c    ",
	MOVLW       _l2+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_6_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_6_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_6_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,90 :: 		(int)poids_kg, ir_porte ? 'O' : 'F');
	MOVF        _poids_kg+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _poids_kg+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd16
	MOVLW       79
	MOVWF       ?FLOC___afficher_lcdT35+0 
	GOTO        L_afficher_lcd17
L_afficher_lcd16:
	MOVLW       70
	MOVWF       ?FLOC___afficher_lcdT35+0 
L_afficher_lcd17:
	MOVF        ?FLOC___afficher_lcdT35+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	CALL        _sprintf+0, 0
;Ascenseur.c,91 :: 		Lcd_Out(2, 1, l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,92 :: 		}
L_end_afficher_lcd:
	RETURN      0
; end of _afficher_lcd

_rampe_accel:

;Ascenseur.c,94 :: 		void rampe_accel() {
;Ascenseur.c,97 :: 		for (i = 0; i <= PWM_PALIERS; i++) {
	CLRF        rampe_accel_i_L0+0 
L_rampe_accel18:
	MOVF        rampe_accel_i_L0+0, 0 
	SUBLW       6
	BTFSS       STATUS+0, 0 
	GOTO        L_rampe_accel19
;Ascenseur.c,98 :: 		pwm = PWM_MIN + ((unsigned int)(PWM_MAX - PWM_MIN) * i) / PWM_PALIERS;
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
;Ascenseur.c,99 :: 		PWM1_Set_Duty((unsigned char)pwm);
	MOVF        R0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,100 :: 		Delay_ms(MS_PALIER);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_rampe_accel21:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_accel21
	DECFSZ      R12, 1, 1
	BRA         L_rampe_accel21
	DECFSZ      R11, 1, 1
	BRA         L_rampe_accel21
;Ascenseur.c,97 :: 		for (i = 0; i <= PWM_PALIERS; i++) {
	INCF        rampe_accel_i_L0+0, 1 
;Ascenseur.c,101 :: 		}
	GOTO        L_rampe_accel18
L_rampe_accel19:
;Ascenseur.c,102 :: 		}
L_end_rampe_accel:
	RETURN      0
; end of _rampe_accel

_rampe_decel:

;Ascenseur.c,104 :: 		void rampe_decel() {
;Ascenseur.c,107 :: 		for (i = PWM_PALIERS; i > 0; i--) {
	MOVLW       6
	MOVWF       rampe_decel_i_L0+0 
L_rampe_decel22:
	MOVF        rampe_decel_i_L0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_rampe_decel23
;Ascenseur.c,108 :: 		pwm = PWM_MIN + ((unsigned int)(PWM_MAX - PWM_MIN) * (i-1)) / PWM_PALIERS;
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
;Ascenseur.c,109 :: 		PWM1_Set_Duty((unsigned char)pwm);
	MOVF        R0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,110 :: 		Delay_ms(MS_PALIER);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_rampe_decel25:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_decel25
	DECFSZ      R12, 1, 1
	BRA         L_rampe_decel25
	DECFSZ      R11, 1, 1
	BRA         L_rampe_decel25
;Ascenseur.c,107 :: 		for (i = PWM_PALIERS; i > 0; i--) {
	DECF        rampe_decel_i_L0+0, 1 
;Ascenseur.c,111 :: 		}
	GOTO        L_rampe_decel22
L_rampe_decel23:
;Ascenseur.c,112 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,113 :: 		}
L_end_rampe_decel:
	RETURN      0
; end of _rampe_decel

_demarrer_moteur:

;Ascenseur.c,115 :: 		void demarrer_moteur(char sens) {
;Ascenseur.c,116 :: 		if (sens == 'U') MOTEUR_MONTER();
	MOVF        FARG_demarrer_moteur_sens+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_demarrer_moteur29
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	GOTO        L_demarrer_moteur33
L_demarrer_moteur29:
;Ascenseur.c,117 :: 		else             MOTEUR_DESCENDRE();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
L_demarrer_moteur33:
;Ascenseur.c,118 :: 		PWM1_Set_Duty(PWM_MIN);
	MOVLW       80
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,119 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;Ascenseur.c,120 :: 		rampe_accel();
	CALL        _rampe_accel+0, 0
;Ascenseur.c,121 :: 		}
L_end_demarrer_moteur:
	RETURN      0
; end of _demarrer_moteur

_scanner_req:

;Ascenseur.c,123 :: 		void scanner_req() {
;Ascenseur.c,124 :: 		if (PORTD.F0) req[0] = 1;
	BTFSS       PORTD+0, 0 
	GOTO        L_scanner_req37
	MOVLW       1
	MOVWF       _req+0 
L_scanner_req37:
;Ascenseur.c,125 :: 		if (PORTD.F1) req[1] = 1;
	BTFSS       PORTD+0, 1 
	GOTO        L_scanner_req38
	MOVLW       1
	MOVWF       _req+1 
L_scanner_req38:
;Ascenseur.c,126 :: 		if (PORTD.F2) req[2] = 1;
	BTFSS       PORTD+0, 2 
	GOTO        L_scanner_req39
	MOVLW       1
	MOVWF       _req+2 
L_scanner_req39:
;Ascenseur.c,127 :: 		if (PORTD.F3) req[3] = 1;
	BTFSS       PORTD+0, 3 
	GOTO        L_scanner_req40
	MOVLW       1
	MOVWF       _req+3 
L_scanner_req40:
;Ascenseur.c,128 :: 		}
L_end_scanner_req:
	RETURN      0
; end of _scanner_req

_prochain_req:

;Ascenseur.c,130 :: 		unsigned char prochain_req() {
;Ascenseur.c,134 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,135 :: 		nearest = 0xFF;
	MOVLW       255
	MOVWF       R4 
;Ascenseur.c,136 :: 		min_d   = 10;
	MOVLW       10
	MOVWF       R7 
	MOVLW       0
	MOVWF       R8 
;Ascenseur.c,137 :: 		for (i = 0; i < NB_ETAGES; i++) {
	CLRF        R3 
L_prochain_req41:
	MOVLW       4
	SUBWF       R3, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req42
;Ascenseur.c,138 :: 		if (!req[i]) continue;
	MOVLW       _req+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR0L+1 
	MOVF        R3, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req44
	GOTO        L_prochain_req43
L_prochain_req44:
;Ascenseur.c,139 :: 		d = (i >= etage_actuel) ? (i - etage_actuel) : (etage_actuel - i);
	MOVF        _etage_actuel+0, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_prochain_req45
	MOVF        _etage_actuel+0, 0 
	SUBWF       R3, 0 
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	SUBWFB      R2, 1 
	GOTO        L_prochain_req46
L_prochain_req45:
	MOVF        R3, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	SUBWFB      R2, 1 
L_prochain_req46:
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
;Ascenseur.c,140 :: 		if (d < min_d) { min_d = d; nearest = i; }
	MOVF        R8, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__prochain_req97
	MOVF        R7, 0 
	SUBWF       R1, 0 
L__prochain_req97:
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req47
	MOVF        R5, 0 
	MOVWF       R7 
	MOVF        R6, 0 
	MOVWF       R8 
	MOVF        R3, 0 
	MOVWF       R4 
L_prochain_req47:
;Ascenseur.c,141 :: 		}
L_prochain_req43:
;Ascenseur.c,137 :: 		for (i = 0; i < NB_ETAGES; i++) {
	INCF        R3, 1 
;Ascenseur.c,141 :: 		}
	GOTO        L_prochain_req41
L_prochain_req42:
;Ascenseur.c,142 :: 		if (nearest != 0xFF) { req[nearest] = 0; return nearest; }
	MOVF        R4, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_prochain_req48
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
L_prochain_req48:
;Ascenseur.c,143 :: 		return 0xFF;
	MOVLW       255
	MOVWF       R0 
;Ascenseur.c,144 :: 		}
L_end_prochain_req:
	RETURN      0
; end of _prochain_req

_deplacer_vers:

;Ascenseur.c,146 :: 		void deplacer_vers(unsigned char cible) {
;Ascenseur.c,150 :: 		if (cible == etage_actuel) return;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	XORWF       _etage_actuel+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers49
	GOTO        L_end_deplacer_vers
L_deplacer_vers49:
;Ascenseur.c,152 :: 		sens         = (cible > etage_actuel) ? 'U' : 'D';
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers50
	MOVLW       85
	MOVWF       ?FLOC___deplacer_versT82+0 
	GOTO        L_deplacer_vers51
L_deplacer_vers50:
	MOVLW       68
	MOVWF       ?FLOC___deplacer_versT82+0 
L_deplacer_vers51:
	MOVF        ?FLOC___deplacer_versT82+0, 0 
	MOVWF       deplacer_vers_sens_L0+0 
;Ascenseur.c,153 :: 		direction    = sens;
	MOVF        ?FLOC___deplacer_versT82+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,154 :: 		etage_cible  = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,155 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,157 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,158 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,159 :: 		Delay_ms(MS_FERMETURE);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_deplacer_vers52:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers52
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers52
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers52
	NOP
	NOP
;Ascenseur.c,161 :: 		nb_et = (cible > etage_actuel) ? (cible - etage_actuel)
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers53
	MOVF        _etage_actuel+0, 0 
	SUBWF       FARG_deplacer_vers_cible+0, 0 
	MOVWF       ?FLOC___deplacer_versT85+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT85+1 
;Ascenseur.c,162 :: 		: (etage_actuel - cible);
	GOTO        L_deplacer_vers54
L_deplacer_vers53:
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       ?FLOC___deplacer_versT85+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT85+1 
L_deplacer_vers54:
	MOVF        ?FLOC___deplacer_versT85+0, 0 
	MOVWF       deplacer_vers_nb_et_L0+0 
;Ascenseur.c,163 :: 		demarrer_moteur(sens);
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       FARG_demarrer_moteur_sens+0 
	CALL        _demarrer_moteur+0, 0
;Ascenseur.c,164 :: 		PWM1_Set_Duty(PWM_MAX);
	MOVLW       255
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,166 :: 		for (i = 0; i < nb_et; i++) {
	CLRF        deplacer_vers_i_L0+0 
L_deplacer_vers55:
	MOVF        deplacer_vers_nb_et_L0+0, 0 
	SUBWF       deplacer_vers_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers56
;Ascenseur.c,167 :: 		if (i == nb_et - 1 && nb_et == 1) Delay_ms(MS_CROISIERE_1ET);
	DECF        deplacer_vers_nb_et_L0+0, 0 
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	SUBWFB      R2, 1 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers99
	MOVF        R1, 0 
	XORWF       deplacer_vers_i_L0+0, 0 
L__deplacer_vers99:
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers60
	MOVF        deplacer_vers_nb_et_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers60
L__deplacer_vers81:
	MOVLW       10
	MOVWF       R11, 0
	MOVLW       34
	MOVWF       R12, 0
	MOVLW       161
	MOVWF       R13, 0
L_deplacer_vers61:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers61
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers61
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers61
	GOTO        L_deplacer_vers62
L_deplacer_vers60:
;Ascenseur.c,168 :: 		else                              Delay_ms(MS_CROISIERE);
	MOVLW       19
	MOVWF       R11, 0
	MOVLW       68
	MOVWF       R12, 0
	MOVLW       68
	MOVWF       R13, 0
L_deplacer_vers63:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers63
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers63
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers63
	NOP
L_deplacer_vers62:
;Ascenseur.c,170 :: 		if (i == nb_et - 1) rampe_decel();
	DECF        deplacer_vers_nb_et_L0+0, 0 
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	SUBWFB      R2, 1 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers100
	MOVF        R1, 0 
	XORWF       deplacer_vers_i_L0+0, 0 
L__deplacer_vers100:
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers64
	CALL        _rampe_decel+0, 0
L_deplacer_vers64:
;Ascenseur.c,172 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers65
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers66
L_deplacer_vers65:
;Ascenseur.c,173 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers66:
;Ascenseur.c,174 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,166 :: 		for (i = 0; i < nb_et; i++) {
	INCF        deplacer_vers_i_L0+0, 1 
;Ascenseur.c,175 :: 		}
	GOTO        L_deplacer_vers55
L_deplacer_vers56:
;Ascenseur.c,177 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,178 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,179 :: 		direction    = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,180 :: 		etage_cible  = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,181 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,182 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,183 :: 		Delay_ms(MS_OUVERTURE);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_deplacer_vers70:
	DECFSZ      R13, 1, 1
	BRA         L_deplacer_vers70
	DECFSZ      R12, 1, 1
	BRA         L_deplacer_vers70
	DECFSZ      R11, 1, 1
	BRA         L_deplacer_vers70
	NOP
;Ascenseur.c,184 :: 		}
L_end_deplacer_vers:
	RETURN      0
; end of _deplacer_vers

_main:

;Ascenseur.c,186 :: 		void main() {
;Ascenseur.c,188 :: 		unsigned int  compteur_ms = 0;
	CLRF        main_compteur_ms_L0+0 
	CLRF        main_compteur_ms_L0+1 
;Ascenseur.c,190 :: 		PWM1_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;Ascenseur.c,191 :: 		PWM1_Set_Duty(0);
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,192 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;Ascenseur.c,194 :: 		ANSELA     = 0x02;
	MOVLW       2
	MOVWF       ANSELA+0 
;Ascenseur.c,195 :: 		TRISA0_bit = 1;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Ascenseur.c,196 :: 		TRISA1_bit = 1;
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,197 :: 		TRISA2_bit = 0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;Ascenseur.c,198 :: 		TRISA3_bit = 0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;Ascenseur.c,199 :: 		LATA2_bit  = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;Ascenseur.c,200 :: 		LATA3_bit  = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,202 :: 		ANSELB = 0x00;
	CLRF        ANSELB+0 
;Ascenseur.c,204 :: 		ANSELC     = 0x00;
	CLRF        ANSELC+0 
;Ascenseur.c,205 :: 		TRISC0_bit = 0; TRISC1_bit = 0; TRISC2_bit = 0;
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
	BCF         TRISC1_bit+0, BitPos(TRISC1_bit+0) 
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;Ascenseur.c,206 :: 		TRISC6_bit = 0; TRISC7_bit = 1;
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;Ascenseur.c,207 :: 		LATC0_bit  = 0; LATC1_bit = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;Ascenseur.c,209 :: 		ANSELD = 0x00;
	CLRF        ANSELD+0 
;Ascenseur.c,210 :: 		TRISD  = 0xFF;
	MOVLW       255
	MOVWF       TRISD+0 
;Ascenseur.c,212 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;Ascenseur.c,213 :: 		ANSELA = 0x02; TRISA1_bit = 1;
	MOVLW       2
	MOVWF       ANSELA+0 
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,215 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Ascenseur.c,216 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main71:
	DECFSZ      R13, 1, 1
	BRA         L_main71
	DECFSZ      R12, 1, 1
	BRA         L_main71
	DECFSZ      R11, 1, 1
	BRA         L_main71
	NOP
;Ascenseur.c,218 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;Ascenseur.c,219 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,220 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,221 :: 		Lcd_Out(1, 1, " ASCENSEUR 4ET ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,222 :: 		Lcd_Out(2, 1, "  V0.4 - EPHEC ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr8_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr8_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,223 :: 		Delay_ms(1500);
	MOVLW       16
	MOVWF       R11, 0
	MOVLW       57
	MOVWF       R12, 0
	MOVLW       13
	MOVWF       R13, 0
L_main72:
	DECFSZ      R13, 1, 1
	BRA         L_main72
	DECFSZ      R12, 1, 1
	BRA         L_main72
	DECFSZ      R11, 1, 1
	BRA         L_main72
	NOP
	NOP
;Ascenseur.c,224 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,226 :: 		UART1_Write_Text("<DATA,ET:0,DIR:0,PT:0,PRT:0,AL:0,URG:0>\r\n");
	MOVLW       ?lstr9_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr9_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,228 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,229 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,230 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,232 :: 		while (1) {
L_main73:
;Ascenseur.c,233 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,234 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,236 :: 		scanner_req();
	CALL        _scanner_req+0, 0
;Ascenseur.c,237 :: 		prochain = prochain_req();
	CALL        _prochain_req+0, 0
	MOVF        R0, 0 
	MOVWF       main_prochain_L0+0 
;Ascenseur.c,239 :: 		if (prochain != 0xFF && ir_porte == 0 && poids_kg < seuil_surge) {
	MOVF        R0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_main77
	MOVF        _ir_porte+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main77
	MOVF        _seuil_surge+1, 0 
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main102
	MOVF        _seuil_surge+0, 0 
	SUBWF       _poids_kg+0, 0 
L__main102:
	BTFSC       STATUS+0, 0 
	GOTO        L_main77
L__main82:
;Ascenseur.c,240 :: 		deplacer_vers(prochain);
	MOVF        main_prochain_L0+0, 0 
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,241 :: 		}
L_main77:
;Ascenseur.c,243 :: 		compteur_ms += 50;
	MOVLW       50
	ADDWF       main_compteur_ms_L0+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      main_compteur_ms_L0+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       main_compteur_ms_L0+0 
	MOVF        R2, 0 
	MOVWF       main_compteur_ms_L0+1 
;Ascenseur.c,244 :: 		if (compteur_ms >= 2000) {
	MOVLW       7
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main103
	MOVLW       208
	SUBWF       R1, 0 
L__main103:
	BTFSS       STATUS+0, 0 
	GOTO        L_main78
;Ascenseur.c,245 :: 		compteur_ms = 0;
	CLRF        main_compteur_ms_L0+0 
	CLRF        main_compteur_ms_L0+1 
;Ascenseur.c,246 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,247 :: 		}
L_main78:
;Ascenseur.c,249 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,250 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main79:
	DECFSZ      R13, 1, 1
	BRA         L_main79
	DECFSZ      R12, 1, 1
	BRA         L_main79
	NOP
	NOP
;Ascenseur.c,251 :: 		}
	GOTO        L_main73
;Ascenseur.c,252 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
