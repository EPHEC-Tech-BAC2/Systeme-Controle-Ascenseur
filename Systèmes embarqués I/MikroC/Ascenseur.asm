
_interrupt:

;Ascenseur.c,36 :: 		void interrupt() {
;Ascenseur.c,37 :: 		if (TMR0IE_bit && TMR0IF_bit) {
	BTFSS       TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
	GOTO        L_interrupt2
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt2
L__interrupt52:
;Ascenseur.c,38 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Ascenseur.c,39 :: 		TMR0H = T0_RELOAD_H;
	MOVLW       194
	MOVWF       TMR0H+0 
;Ascenseur.c,40 :: 		TMR0L = T0_RELOAD_L;
	MOVLW       247
	MOVWF       TMR0L+0 
;Ascenseur.c,41 :: 		timer0_flag = 1;
	MOVLW       1
	MOVWF       _timer0_flag+0 
;Ascenseur.c,42 :: 		timer0_count++;
	MOVLW       1
	ADDWF       _timer0_count+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _timer0_count+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _timer0_count+0 
	MOVF        R1, 0 
	MOVWF       _timer0_count+1 
;Ascenseur.c,43 :: 		}
L_interrupt2:
;Ascenseur.c,45 :: 		if (TMR1IE_bit && TMR1IF_bit) {
	BTFSS       TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
	GOTO        L_interrupt5
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt5
L__interrupt51:
;Ascenseur.c,46 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Ascenseur.c,47 :: 		TMR1H = 0xFE;
	MOVLW       254
	MOVWF       TMR1H+0 
;Ascenseur.c,48 :: 		TMR1L = 0x0C;
	MOVLW       12
	MOVWF       TMR1L+0 
;Ascenseur.c,49 :: 		if (al_active) BUZZER = ~BUZZER;
	MOVF        _al_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt6
	BTG         LATC5_bit+0, BitPos(LATC5_bit+0) 
	GOTO        L_interrupt7
L_interrupt6:
;Ascenseur.c,50 :: 		else           BUZZER = 0;
	BCF         LATC5_bit+0, BitPos(LATC5_bit+0) 
L_interrupt7:
;Ascenseur.c,51 :: 		}
L_interrupt5:
;Ascenseur.c,52 :: 		}
L_end_interrupt:
L__interrupt57:
	RETFIE      1
; end of _interrupt

_uart_send_data:

;Ascenseur.c,54 :: 		void uart_send_data() {
;Ascenseur.c,58 :: 		if (suppress_data_count > 0) {
	MOVF        _suppress_data_count+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_uart_send_data8
;Ascenseur.c,59 :: 		suppress_data_count--;
	DECF        _suppress_data_count+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _suppress_data_count+0 
;Ascenseur.c,60 :: 		return;
	GOTO        L_end_uart_send_data
;Ascenseur.c,61 :: 		}
L_uart_send_data8:
;Ascenseur.c,63 :: 		if      (direction == 'U') dir_n = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data9
	MOVLW       1
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data10
L_uart_send_data9:
;Ascenseur.c,64 :: 		else if (direction == 'D') dir_n = 2;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data11
	MOVLW       2
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data12
L_uart_send_data11:
;Ascenseur.c,65 :: 		else                       dir_n = 0;
	CLRF        uart_send_data_dir_n_L0+0 
L_uart_send_data12:
L_uart_send_data10:
;Ascenseur.c,67 :: 		prt_n = mode_auto ? (ir_porte ? 1 : 0) : (porte_cmd ? 1 : 0);
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data13
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data15
	MOVLW       1
	MOVWF       ?FLOC___uart_send_dataT10+0 
	GOTO        L_uart_send_data16
L_uart_send_data15:
	CLRF        ?FLOC___uart_send_dataT10+0 
L_uart_send_data16:
	MOVF        ?FLOC___uart_send_dataT10+0, 0 
	MOVWF       ?FLOC___uart_send_dataT11+0 
	GOTO        L_uart_send_data14
L_uart_send_data13:
	MOVF        _porte_cmd+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data17
	MOVLW       1
	MOVWF       ?FLOC___uart_send_dataT12+0 
	GOTO        L_uart_send_data18
L_uart_send_data17:
	CLRF        ?FLOC___uart_send_dataT12+0 
L_uart_send_data18:
	MOVF        ?FLOC___uart_send_dataT12+0, 0 
	MOVWF       ?FLOC___uart_send_dataT11+0 
L_uart_send_data14:
;Ascenseur.c,69 :: 		sprintf(trame,
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_sprintf_wh+1 
;Ascenseur.c,70 :: 		"<DATA,ET:%d,DIR:%d,PT:%d,PRT:%d,AL:%d,URG:%d,NB:%d,PWM:%d,TPS:%d>\r\n",
	MOVLW       ?lstr_1_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,71 :: 		(int)etage_actuel, (int)dir_n, (int)poids_kg,
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
;Ascenseur.c,72 :: 		(int)prt_n,        (int)al_active, (int)urg_active,
	MOVF        ?FLOC___uart_send_dataT11+0, 0 
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
;Ascenseur.c,73 :: 		(int)nb_session,   (int)pwm_actuel, (int)temps_trajet);
	MOVF        _nb_session+0, 0 
	MOVWF       FARG_sprintf_wh+17 
	MOVF        _nb_session+1, 0 
	MOVWF       FARG_sprintf_wh+18 
	MOVF        _pwm_actuel+0, 0 
	MOVWF       FARG_sprintf_wh+19 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+20 
	MOVF        _temps_trajet+0, 0 
	MOVWF       FARG_sprintf_wh+21 
	MOVF        _temps_trajet+1, 0 
	MOVWF       FARG_sprintf_wh+22 
	CALL        _sprintf+0, 0
;Ascenseur.c,75 :: 		UART1_Write_Text(trame);
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,76 :: 		}
L_end_uart_send_data:
	RETURN      0
; end of _uart_send_data

_init_timer1:

;Ascenseur.c,78 :: 		void init_timer1() {
;Ascenseur.c,79 :: 		T1CON = 0x00;
	CLRF        T1CON+0 
;Ascenseur.c,80 :: 		TMR1H = 0xFE;
	MOVLW       254
	MOVWF       TMR1H+0 
;Ascenseur.c,81 :: 		TMR1L = 0x0C;
	MOVLW       12
	MOVWF       TMR1L+0 
;Ascenseur.c,82 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Ascenseur.c,83 :: 		TMR1IE_bit = 1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;Ascenseur.c,84 :: 		TMR1ON_bit = 1;
	BSF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;Ascenseur.c,85 :: 		}
L_end_init_timer1:
	RETURN      0
; end of _init_timer1

_main:

;Ascenseur.c,87 :: 		void main() {
;Ascenseur.c,88 :: 		ANSELA = 0x00;
	CLRF        ANSELA+0 
;Ascenseur.c,89 :: 		TRISA3_bit = 0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;Ascenseur.c,90 :: 		LATA3_bit = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,92 :: 		ANSELB = 0x00;
	CLRF        ANSELB+0 
;Ascenseur.c,93 :: 		TRISB6_bit = 1;
	BSF         TRISB6_bit+0, BitPos(TRISB6_bit+0) 
;Ascenseur.c,94 :: 		TRISB7_bit = 1;
	BSF         TRISB7_bit+0, BitPos(TRISB7_bit+0) 
;Ascenseur.c,95 :: 		INTCON2.RBPU = 1;
	BSF         INTCON2+0, 7 
;Ascenseur.c,97 :: 		ANSELC = 0x00;
	CLRF        ANSELC+0 
;Ascenseur.c,98 :: 		TRISC5_bit = 0;
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;Ascenseur.c,99 :: 		TRISC6_bit = 0;
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;Ascenseur.c,100 :: 		TRISC7_bit = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;Ascenseur.c,101 :: 		LATC5_bit = 0;
	BCF         LATC5_bit+0, BitPos(LATC5_bit+0) 
;Ascenseur.c,103 :: 		ANSELD = 0x00;
	CLRF        ANSELD+0 
;Ascenseur.c,104 :: 		TRISD4_bit = 1;
	BSF         TRISD4_bit+0, BitPos(TRISD4_bit+0) 
;Ascenseur.c,106 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Ascenseur.c,107 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main19:
	DECFSZ      R13, 1, 1
	BRA         L_main19
	DECFSZ      R12, 1, 1
	BRA         L_main19
	DECFSZ      R11, 1, 1
	BRA         L_main19
	NOP
;Ascenseur.c,109 :: 		T0CON = 0x07;
	MOVLW       7
	MOVWF       T0CON+0 
;Ascenseur.c,110 :: 		TMR0H = T0_RELOAD_H;
	MOVLW       194
	MOVWF       TMR0H+0 
;Ascenseur.c,111 :: 		TMR0L = T0_RELOAD_L;
	MOVLW       247
	MOVWF       TMR0L+0 
;Ascenseur.c,112 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Ascenseur.c,113 :: 		TMR0IE_bit = 1;
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;Ascenseur.c,115 :: 		init_timer1();
	CALL        _init_timer1+0, 0
;Ascenseur.c,117 :: 		PEIE_bit = 1;
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;Ascenseur.c,118 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,119 :: 		T0CON = 0x87;
	MOVLW       135
	MOVWF       T0CON+0 
;Ascenseur.c,121 :: 		UART1_Write_Text("<DATA,ET:0,DIR:0,PT:0,PRT:0,AL:0,URG:0,NB:0,PWM:0,TPS:0>\r\n");
	MOVLW       ?lstr2_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,123 :: 		while (1) {
L_main20:
;Ascenseur.c,125 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main24
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main24
L__main55:
;Ascenseur.c,126 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main25:
	DECFSZ      R13, 1, 1
	BRA         L_main25
	DECFSZ      R12, 1, 1
	BRA         L_main25
	NOP
	NOP
;Ascenseur.c,127 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main26
;Ascenseur.c,128 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,129 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,130 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,131 :: 		}
L_main26:
;Ascenseur.c,132 :: 		}
L_main24:
;Ascenseur.c,134 :: 		if (urgence_flag) {
	MOVF        _urgence_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main27
;Ascenseur.c,135 :: 		urgence_flag = 0;
	CLRF        _urgence_flag+0 
;Ascenseur.c,136 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,139 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L3+0 
;Ascenseur.c,140 :: 		while (acq_recu == 0) {
L_main28:
	MOVF        main_acq_recu_L3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main29
;Ascenseur.c,141 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main30:
	DECFSZ      R13, 1, 1
	BRA         L_main30
	DECFSZ      R12, 1, 1
	BRA         L_main30
	NOP
	NOP
;Ascenseur.c,142 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main31
;Ascenseur.c,143 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,144 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,145 :: 		}
L_main31:
;Ascenseur.c,146 :: 		if (BP_ACQ && !BP_URGENCE) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main34
	BTFSC       PORTB+0, 6 
	GOTO        L_main34
L__main54:
;Ascenseur.c,147 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main35:
	DECFSZ      R13, 1, 1
	BRA         L_main35
	DECFSZ      R12, 1, 1
	BRA         L_main35
	NOP
	NOP
;Ascenseur.c,148 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3+0 
;Ascenseur.c,149 :: 		}
L_main34:
;Ascenseur.c,150 :: 		}
	GOTO        L_main28
L_main29:
;Ascenseur.c,151 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main36:
	DECFSZ      R13, 1, 1
	BRA         L_main36
	DECFSZ      R12, 1, 1
	BRA         L_main36
	DECFSZ      R11, 1, 1
	BRA         L_main36
;Ascenseur.c,154 :: 		urg_active = 0;
	CLRF        _urg_active+0 
;Ascenseur.c,155 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,156 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,157 :: 		LED2 = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,158 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,159 :: 		}
L_main27:
;Ascenseur.c,161 :: 		if (al_flag) {
	MOVF        _al_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main37
;Ascenseur.c,162 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,163 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,166 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L3_L3+0 
;Ascenseur.c,167 :: 		while (acq_recu == 0) {
L_main38:
	MOVF        main_acq_recu_L3_L3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main39
;Ascenseur.c,168 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main40:
	DECFSZ      R13, 1, 1
	BRA         L_main40
	DECFSZ      R12, 1, 1
	BRA         L_main40
	NOP
	NOP
;Ascenseur.c,169 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main41
;Ascenseur.c,170 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,171 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,172 :: 		}
L_main41:
;Ascenseur.c,173 :: 		if (BP_ACQ) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main42
;Ascenseur.c,174 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main43:
	DECFSZ      R13, 1, 1
	BRA         L_main43
	DECFSZ      R12, 1, 1
	BRA         L_main43
	NOP
	NOP
;Ascenseur.c,175 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3_L3+0 
;Ascenseur.c,176 :: 		}
L_main42:
;Ascenseur.c,177 :: 		}
	GOTO        L_main38
L_main39:
;Ascenseur.c,178 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main44:
	DECFSZ      R13, 1, 1
	BRA         L_main44
	DECFSZ      R12, 1, 1
	BRA         L_main44
	DECFSZ      R11, 1, 1
	BRA         L_main44
;Ascenseur.c,181 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,182 :: 		LED2 = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,183 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,184 :: 		}
L_main37:
;Ascenseur.c,186 :: 		if (BP_ALARME && !al_active) {
	BTFSS       PORTB+0, 7 
	GOTO        L_main47
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main47
L__main53:
;Ascenseur.c,187 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main48:
	DECFSZ      R13, 1, 1
	BRA         L_main48
	DECFSZ      R12, 1, 1
	BRA         L_main48
	NOP
	NOP
;Ascenseur.c,188 :: 		if (BP_ALARME) {
	BTFSS       PORTB+0, 7 
	GOTO        L_main49
;Ascenseur.c,189 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,190 :: 		al_flag = 1;
	MOVLW       1
	MOVWF       _al_flag+0 
;Ascenseur.c,191 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,192 :: 		}
L_main49:
;Ascenseur.c,193 :: 		}
L_main47:
;Ascenseur.c,195 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main50
;Ascenseur.c,196 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,197 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,198 :: 		}
L_main50:
;Ascenseur.c,199 :: 		}
	GOTO        L_main20
;Ascenseur.c,200 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
