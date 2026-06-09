
_interrupt:

;Ascenseur.c,180 :: 		void interrupt() {
;Ascenseur.c,184 :: 		if (TMR0IE_bit && TMR0IF_bit) {
	BTFSS       TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
	GOTO        L_interrupt2
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt2
L__interrupt498:
;Ascenseur.c,185 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Ascenseur.c,186 :: 		TMR0H = T0_RELOAD_H;
	MOVLW       225
	MOVWF       TMR0H+0 
;Ascenseur.c,187 :: 		TMR0L = T0_RELOAD_L;
	MOVLW       124
	MOVWF       TMR0L+0 
;Ascenseur.c,188 :: 		timer0_flag = 1;
	MOVLW       1
	MOVWF       _timer0_flag+0 
;Ascenseur.c,189 :: 		timer0_count++;
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
;Ascenseur.c,190 :: 		}
L_interrupt2:
;Ascenseur.c,193 :: 		if (RBIE_bit && RBIF_bit) {
	BTFSS       RBIE_bit+0, BitPos(RBIE_bit+0) 
	GOTO        L_interrupt5
	BTFSS       RBIF_bit+0, BitPos(RBIF_bit+0) 
	GOTO        L_interrupt5
L__interrupt497:
;Ascenseur.c,194 :: 		unsigned char pb = PORTB;
	MOVF        PORTB+0, 0 
	MOVWF       interrupt_pb_L1+0 
;Ascenseur.c,195 :: 		RBIF_bit = 0;
	BCF         RBIF_bit+0, BitPos(RBIF_bit+0) 
;Ascenseur.c,198 :: 		if ((pb & 0x40) && !urg_active) {
	BTFSS       interrupt_pb_L1+0, 6 
	GOTO        L_interrupt8
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt8
L__interrupt496:
;Ascenseur.c,199 :: 		LATC0_bit = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;Ascenseur.c,200 :: 		LATC1_bit = 0;
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;Ascenseur.c,201 :: 		moteur_actif = 0;
	CLRF        _moteur_actif+0 
;Ascenseur.c,202 :: 		pwm_actuel = 0;
	CLRF        _pwm_actuel+0 
;Ascenseur.c,203 :: 		urg_active   = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,204 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,205 :: 		LED2         = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,206 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,207 :: 		}
L_interrupt8:
;Ascenseur.c,210 :: 		if ((pb & 0x80) && !al_active) {
	BTFSS       interrupt_pb_L1+0, 7 
	GOTO        L_interrupt11
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt11
L__interrupt495:
;Ascenseur.c,211 :: 		LATC0_bit = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;Ascenseur.c,212 :: 		LATC1_bit = 0;
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;Ascenseur.c,213 :: 		moteur_actif = 0;
	CLRF        _moteur_actif+0 
;Ascenseur.c,214 :: 		pwm_actuel = 0;
	CLRF        _pwm_actuel+0 
;Ascenseur.c,215 :: 		al_active    = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,216 :: 		al_flag      = 1;
	MOVLW       1
	MOVWF       _al_flag+0 
;Ascenseur.c,217 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,218 :: 		LED2         = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,219 :: 		}
L_interrupt11:
;Ascenseur.c,220 :: 		}
L_interrupt5:
;Ascenseur.c,223 :: 		if (RC1IE_bit && RC1IF_bit) {
	BTFSS       RC1IE_bit+0, BitPos(RC1IE_bit+0) 
	GOTO        L_interrupt14
	BTFSS       RC1IF_bit+0, BitPos(RC1IF_bit+0) 
	GOTO        L_interrupt14
L__interrupt494:
;Ascenseur.c,228 :: 		if (OERR1_bit) {
	BTFSS       OERR1_bit+0, BitPos(OERR1_bit+0) 
	GOTO        L_interrupt15
;Ascenseur.c,229 :: 		CREN1_bit = 0;
	BCF         CREN1_bit+0, BitPos(CREN1_bit+0) 
;Ascenseur.c,230 :: 		CREN1_bit = 1;
	BSF         CREN1_bit+0, BitPos(CREN1_bit+0) 
;Ascenseur.c,231 :: 		}
L_interrupt15:
;Ascenseur.c,233 :: 		c = RCREG1;
	MOVF        RCREG1+0, 0 
	MOVWF       interrupt_c_L0+0 
;Ascenseur.c,235 :: 		if (c == '<') {
	MOVF        interrupt_c_L0+0, 0 
	XORLW       60
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt16
;Ascenseur.c,236 :: 		rx_idx = 0;
	CLRF        _rx_idx+0 
;Ascenseur.c,237 :: 		}
L_interrupt16:
;Ascenseur.c,239 :: 		if (rx_idx < 48) {
	MOVLW       48
	SUBWF       _rx_idx+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt17
;Ascenseur.c,240 :: 		rx_buf[rx_idx++] = c;
	MOVLW       _rx_buf+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_rx_buf+0)
	MOVWF       FSR1L+1 
	MOVF        _rx_idx+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	MOVF        interrupt_c_L0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        _rx_idx+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _rx_idx+0 
;Ascenseur.c,241 :: 		}
L_interrupt17:
;Ascenseur.c,243 :: 		if (c == '>') {
	MOVF        interrupt_c_L0+0, 0 
	XORLW       62
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt18
;Ascenseur.c,244 :: 		if (rx_idx >= 5 && rx_buf[0] == '<') {
	MOVLW       5
	SUBWF       _rx_idx+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt21
	MOVF        _rx_buf+0, 0 
	XORLW       60
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt21
L__interrupt493:
;Ascenseur.c,245 :: 		nxt = (unsigned char)((cmd_qtail + 1) & (CMD_QSIZE - 1));
	MOVF        _cmd_qtail+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVLW       3
	ANDWF       R0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       interrupt_nxt_L1+0 
;Ascenseur.c,246 :: 		if (nxt != cmd_qhead) {
	MOVF        R1, 0 
	XORWF       _cmd_qhead+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt22
;Ascenseur.c,247 :: 		n = rx_idx;
	MOVF        _rx_idx+0, 0 
	MOVWF       interrupt_n_L1+0 
;Ascenseur.c,248 :: 		if (n > (CMD_QLEN - 2)) n = CMD_QLEN - 2;
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt551
	MOVF        interrupt_n_L1+0, 0 
	SUBLW       38
L__interrupt551:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt23
	MOVLW       38
	MOVWF       interrupt_n_L1+0 
L_interrupt23:
;Ascenseur.c,249 :: 		for (j = 0; j < n; j++)
	CLRF        interrupt_j_L1+0 
L_interrupt24:
	MOVF        interrupt_n_L1+0, 0 
	SUBWF       interrupt_j_L1+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt25
;Ascenseur.c,250 :: 		cmd_queue[cmd_qtail][j] = rx_buf[j];
	MOVLW       40
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _cmd_qtail+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _cmd_queue+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_cmd_queue+0)
	ADDWFC      R1, 1 
	MOVF        interrupt_j_L1+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1L+1 
	MOVLW       _rx_buf+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_rx_buf+0)
	MOVWF       FSR0L+1 
	MOVF        interrupt_j_L1+0, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Ascenseur.c,249 :: 		for (j = 0; j < n; j++)
	INCF        interrupt_j_L1+0, 1 
;Ascenseur.c,250 :: 		cmd_queue[cmd_qtail][j] = rx_buf[j];
	GOTO        L_interrupt24
L_interrupt25:
;Ascenseur.c,251 :: 		cmd_queue[cmd_qtail][n] = '\0';
	MOVLW       40
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _cmd_qtail+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _cmd_queue+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_cmd_queue+0)
	ADDWFC      R1, 1 
	MOVF        interrupt_n_L1+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;Ascenseur.c,252 :: 		cmd_qtail = nxt;
	MOVF        interrupt_nxt_L1+0, 0 
	MOVWF       _cmd_qtail+0 
;Ascenseur.c,253 :: 		}
L_interrupt22:
;Ascenseur.c,254 :: 		}
L_interrupt21:
;Ascenseur.c,255 :: 		rx_idx = 0;
	CLRF        _rx_idx+0 
;Ascenseur.c,256 :: 		}
L_interrupt18:
;Ascenseur.c,257 :: 		}
L_interrupt14:
;Ascenseur.c,258 :: 		}
L_end_interrupt:
L__interrupt550:
	RETFIE      1
; end of _interrupt

_eep_write_byte:

;Ascenseur.c,261 :: 		void eep_write_byte(unsigned char addr, unsigned char val) {
;Ascenseur.c,262 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Ascenseur.c,263 :: 		I2C1_Wr(EEPROM_W);
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,264 :: 		I2C1_Wr(addr);
	MOVF        FARG_eep_write_byte_addr+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,265 :: 		I2C1_Wr(val);
	MOVF        FARG_eep_write_byte_val+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,266 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Ascenseur.c,267 :: 		Delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_eep_write_byte27:
	DECFSZ      R13, 1, 1
	BRA         L_eep_write_byte27
	DECFSZ      R12, 1, 1
	BRA         L_eep_write_byte27
	NOP
;Ascenseur.c,268 :: 		}
L_end_eep_write_byte:
	RETURN      0
; end of _eep_write_byte

_eep_read_byte:

;Ascenseur.c,270 :: 		unsigned char eep_read_byte(unsigned char addr) {
;Ascenseur.c,272 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Ascenseur.c,273 :: 		I2C1_Wr(EEPROM_W);
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,274 :: 		I2C1_Wr(addr);
	MOVF        FARG_eep_read_byte_addr+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,275 :: 		I2C1_Repeated_Start();
	CALL        _I2C1_Repeated_Start+0, 0
;Ascenseur.c,276 :: 		I2C1_Wr(EEPROM_R);
	MOVLW       161
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,277 :: 		val = I2C1_Rd(0);
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       eep_read_byte_val_L0+0 
;Ascenseur.c,278 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Ascenseur.c,279 :: 		return val;
	MOVF        eep_read_byte_val_L0+0, 0 
	MOVWF       R0 
;Ascenseur.c,280 :: 		}
L_end_eep_read_byte:
	RETURN      0
; end of _eep_read_byte

_eep_write_word:

;Ascenseur.c,282 :: 		void eep_write_word(unsigned char addr, unsigned int val) {
;Ascenseur.c,283 :: 		eep_write_byte(addr,     (unsigned char)(val >> 8));
	MOVF        FARG_eep_write_word_addr+0, 0 
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        FARG_eep_write_word_val+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,284 :: 		eep_write_byte(addr + 1, (unsigned char)(val & 0xFF));
	MOVF        FARG_eep_write_word_addr+0, 0 
	ADDLW       1
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVLW       255
	ANDWF       FARG_eep_write_word_val+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,285 :: 		}
L_end_eep_write_word:
	RETURN      0
; end of _eep_write_word

_eep_read_word:

;Ascenseur.c,287 :: 		unsigned int eep_read_word(unsigned char addr) {
;Ascenseur.c,288 :: 		unsigned int hi = (unsigned int)eep_read_byte(addr);
	MOVF        FARG_eep_read_word_addr+0, 0 
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       eep_read_word_hi_L0+0 
	MOVLW       0
	MOVWF       eep_read_word_hi_L0+1 
;Ascenseur.c,289 :: 		unsigned int lo = (unsigned int)eep_read_byte(addr + 1);
	MOVF        FARG_eep_read_word_addr+0, 0 
	ADDLW       1
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
;Ascenseur.c,290 :: 		return (hi << 8) | lo;
	MOVF        eep_read_word_hi_L0+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R3, 0 
	IORWF       R0, 1 
	MOVF        R4, 0 
	IORWF       R1, 1 
;Ascenseur.c,291 :: 		}
L_end_eep_read_word:
	RETURN      0
; end of _eep_read_word

_recalc_pwm_max:

;Ascenseur.c,294 :: 		void recalc_pwm_max() {
;Ascenseur.c,295 :: 		pwm_max_eff = (unsigned char)((unsigned int)vitesse_max_pc * 255 / 100);
	MOVF        _vitesse_max_pc+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       255
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _pwm_max_eff+0 
;Ascenseur.c,296 :: 		if (pwm_max_eff < (unsigned char)(PWM_MIN + 20))
	MOVLW       100
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_recalc_pwm_max28
;Ascenseur.c,297 :: 		pwm_max_eff = (unsigned char)(PWM_MIN + 20);
	MOVLW       100
	MOVWF       _pwm_max_eff+0 
L_recalc_pwm_max28:
;Ascenseur.c,298 :: 		}
L_end_recalc_pwm_max:
	RETURN      0
; end of _recalc_pwm_max

_pop_cmd:

;Ascenseur.c,301 :: 		unsigned char pop_cmd(char *dest) {
;Ascenseur.c,303 :: 		if (cmd_qhead == cmd_qtail) return 0;
	MOVF        _cmd_qhead+0, 0 
	XORWF       _cmd_qtail+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_pop_cmd29
	CLRF        R0 
	GOTO        L_end_pop_cmd
L_pop_cmd29:
;Ascenseur.c,304 :: 		GIE_bit = 0;
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,305 :: 		for (i = 0; i < (CMD_QLEN - 1); i++)
	CLRF        pop_cmd_i_L0+0 
L_pop_cmd30:
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pop_cmd558
	MOVLW       39
	SUBWF       pop_cmd_i_L0+0, 0 
L__pop_cmd558:
	BTFSC       STATUS+0, 0 
	GOTO        L_pop_cmd31
;Ascenseur.c,306 :: 		dest[i] = cmd_queue[cmd_qhead][i];
	MOVF        pop_cmd_i_L0+0, 0 
	ADDWF       FARG_pop_cmd_dest+0, 0 
	MOVWF       FLOC__pop_cmd+0 
	MOVLW       0
	ADDWFC      FARG_pop_cmd_dest+1, 0 
	MOVWF       FLOC__pop_cmd+1 
	MOVLW       40
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _cmd_qhead+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _cmd_queue+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_cmd_queue+0)
	ADDWFC      R1, 1 
	MOVF        pop_cmd_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       FLOC__pop_cmd+0, FSR1L+0
	MOVFF       FLOC__pop_cmd+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Ascenseur.c,305 :: 		for (i = 0; i < (CMD_QLEN - 1); i++)
	INCF        pop_cmd_i_L0+0, 1 
;Ascenseur.c,306 :: 		dest[i] = cmd_queue[cmd_qhead][i];
	GOTO        L_pop_cmd30
L_pop_cmd31:
;Ascenseur.c,307 :: 		dest[CMD_QLEN - 1] = '\0';
	MOVLW       39
	ADDWF       FARG_pop_cmd_dest+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_pop_cmd_dest+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;Ascenseur.c,308 :: 		cmd_qhead = (unsigned char)((cmd_qhead + 1) & (CMD_QSIZE - 1));
	MOVF        _cmd_qhead+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVLW       3
	ANDWF       R0, 0 
	MOVWF       _cmd_qhead+0 
;Ascenseur.c,309 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,310 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
;Ascenseur.c,311 :: 		}
L_end_pop_cmd:
	RETURN      0
; end of _pop_cmd

_eeprom_charger:

;Ascenseur.c,314 :: 		void eeprom_charger() {
;Ascenseur.c,318 :: 		stored_traj = eep_read_word(0x00);
	CLRF        FARG_eep_read_word_addr+0 
	CALL        _eep_read_word+0, 0
	MOVF        R0, 0 
	MOVWF       eeprom_charger_stored_traj_L0+0 
	MOVF        R1, 0 
	MOVWF       eeprom_charger_stored_traj_L0+1 
;Ascenseur.c,319 :: 		last_etage  = eep_read_byte(0x02);
	MOVLW       2
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       _last_etage+0 
;Ascenseur.c,320 :: 		stored_vit  = eep_read_byte(0x03);
	MOVLW       3
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       eeprom_charger_stored_vit_L0+0 
;Ascenseur.c,322 :: 		if (stored_traj == 0xFFFF) {
	MOVF        eeprom_charger_stored_traj_L0+1, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L__eeprom_charger560
	MOVLW       255
	XORWF       eeprom_charger_stored_traj_L0+0, 0 
L__eeprom_charger560:
	BTFSS       STATUS+0, 2 
	GOTO        L_eeprom_charger33
;Ascenseur.c,323 :: 		nb_trajets = 0;
	CLRF        _nb_trajets+0 
	CLRF        _nb_trajets+1 
;Ascenseur.c,324 :: 		eep_write_word(0x00, 0);
	CLRF        FARG_eep_write_word_addr+0 
	CLRF        FARG_eep_write_word_val+0 
	CLRF        FARG_eep_write_word_val+1 
	CALL        _eep_write_word+0, 0
;Ascenseur.c,325 :: 		} else {
	GOTO        L_eeprom_charger34
L_eeprom_charger33:
;Ascenseur.c,326 :: 		nb_trajets = stored_traj;
	MOVF        eeprom_charger_stored_traj_L0+0, 0 
	MOVWF       _nb_trajets+0 
	MOVF        eeprom_charger_stored_traj_L0+1, 0 
	MOVWF       _nb_trajets+1 
;Ascenseur.c,327 :: 		}
L_eeprom_charger34:
;Ascenseur.c,329 :: 		if (last_etage == 0xFF) {
	MOVF        _last_etage+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_eeprom_charger35
;Ascenseur.c,330 :: 		last_etage = 0;
	CLRF        _last_etage+0 
;Ascenseur.c,331 :: 		eep_write_byte(0x02, 0);
	MOVLW       2
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,332 :: 		}
L_eeprom_charger35:
;Ascenseur.c,334 :: 		if (stored_vit == 0xFF || stored_vit == 0) {
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L__eeprom_charger499
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__eeprom_charger499
	GOTO        L_eeprom_charger38
L__eeprom_charger499:
;Ascenseur.c,335 :: 		vitesse_eeprom = 100;
	MOVLW       100
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,336 :: 		vitesse_max_pc  = 100;
	MOVLW       100
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,337 :: 		eep_write_byte(0x03, 100);
	MOVLW       3
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVLW       100
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,338 :: 		} else {
	GOTO        L_eeprom_charger39
L_eeprom_charger38:
;Ascenseur.c,339 :: 		vitesse_eeprom = stored_vit;
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,340 :: 		vitesse_max_pc  = stored_vit;
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,341 :: 		}
L_eeprom_charger39:
;Ascenseur.c,343 :: 		poids_max        = POIDS_MAX_DEF;
	MOVLW       118
	MOVWF       _poids_max+0 
	MOVLW       2
	MOVWF       _poids_max+1 
;Ascenseur.c,344 :: 		seuil_surge      = POIDS_MAX_DEF;
	MOVLW       118
	MOVWF       _seuil_surge+0 
	MOVLW       2
	MOVWF       _seuil_surge+1 
;Ascenseur.c,345 :: 		surcharge_active = 0;
	CLRF        _surcharge_active+0 
;Ascenseur.c,346 :: 		etat_surcharge   = 0;
	CLRF        _etat_surcharge+0 
;Ascenseur.c,348 :: 		recalc_pwm_max();
	CALL        _recalc_pwm_max+0, 0
;Ascenseur.c,349 :: 		}
L_end_eeprom_charger:
	RETURN      0
; end of _eeprom_charger

_eeprom_sauver_trajet:

;Ascenseur.c,352 :: 		void eeprom_sauver_trajet() {
;Ascenseur.c,353 :: 		nb_session++;
	INFSNZ      _nb_session+0, 1 
	INCF        _nb_session+1, 1 
;Ascenseur.c,354 :: 		nb_trajets++;
	INFSNZ      _nb_trajets+0, 1 
	INCF        _nb_trajets+1, 1 
;Ascenseur.c,355 :: 		last_etage = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _last_etage+0 
;Ascenseur.c,356 :: 		eep_write_word(0x00, nb_trajets);
	CLRF        FARG_eep_write_word_addr+0 
	MOVF        _nb_trajets+0, 0 
	MOVWF       FARG_eep_write_word_val+0 
	MOVF        _nb_trajets+1, 0 
	MOVWF       FARG_eep_write_word_val+1 
	CALL        _eep_write_word+0, 0
;Ascenseur.c,357 :: 		eep_write_byte(0x02, last_etage);
	MOVLW       2
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        _last_etage+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,358 :: 		}
L_end_eeprom_sauver_trajet:
	RETURN      0
; end of _eeprom_sauver_trajet

_eeprom_reset:

;Ascenseur.c,361 :: 		void eeprom_reset() {
;Ascenseur.c,362 :: 		nb_trajets = 0;
	CLRF        _nb_trajets+0 
	CLRF        _nb_trajets+1 
;Ascenseur.c,363 :: 		last_etage = 0;
	CLRF        _last_etage+0 
;Ascenseur.c,364 :: 		vitesse_eeprom = 100;
	MOVLW       100
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,365 :: 		vitesse_max_pc = 100;
	MOVLW       100
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,366 :: 		recalc_pwm_max();
	CALL        _recalc_pwm_max+0, 0
;Ascenseur.c,368 :: 		eep_write_byte(0x00, 0x00);
	CLRF        FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,369 :: 		eep_write_byte(0x01, 0x00);
	MOVLW       1
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,370 :: 		eep_write_byte(0x02, 0x00);
	MOVLW       2
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,371 :: 		eep_write_byte(0x03, 100);
	MOVLW       3
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVLW       100
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,372 :: 		eep_write_byte(0x04, 0x00);
	MOVLW       4
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,373 :: 		eep_write_byte(0x05, 0x00);
	MOVLW       5
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,374 :: 		}
L_end_eeprom_reset:
	RETURN      0
; end of _eeprom_reset

_set_pwm:

;Ascenseur.c,377 :: 		void set_pwm(unsigned char duty) {
;Ascenseur.c,378 :: 		PWM1_Set_Duty(duty);
	MOVF        FARG_set_pwm_duty+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,380 :: 		if (pwm_max_eff > 0) {
	MOVF        _pwm_max_eff+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_set_pwm40
;Ascenseur.c,381 :: 		if (duty >= pwm_max_eff)
	MOVF        _pwm_max_eff+0, 0 
	SUBWF       FARG_set_pwm_duty+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_set_pwm41
;Ascenseur.c,382 :: 		pwm_actuel = vitesse_max_pc;
	MOVF        _vitesse_max_pc+0, 0 
	MOVWF       _pwm_actuel+0 
	GOTO        L_set_pwm42
L_set_pwm41:
;Ascenseur.c,384 :: 		pwm_actuel = (unsigned char)((unsigned long)vitesse_max_pc * duty / pwm_max_eff);
	MOVF        _vitesse_max_pc+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
	MOVF        FARG_set_pwm_duty+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        _pwm_max_eff+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _pwm_actuel+0 
L_set_pwm42:
;Ascenseur.c,385 :: 		} else {
	GOTO        L_set_pwm43
L_set_pwm40:
;Ascenseur.c,386 :: 		pwm_actuel = 0;
	CLRF        _pwm_actuel+0 
;Ascenseur.c,387 :: 		}
L_set_pwm43:
;Ascenseur.c,388 :: 		}
L_end_set_pwm:
	RETURN      0
; end of _set_pwm

_uart_send_data:

;Ascenseur.c,391 :: 		void uart_send_data() {
;Ascenseur.c,395 :: 		if (suppress_data_count > 0) {
	MOVF        _suppress_data_count+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_uart_send_data44
;Ascenseur.c,396 :: 		suppress_data_count--;
	DECF        _suppress_data_count+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _suppress_data_count+0 
;Ascenseur.c,397 :: 		return;
	GOTO        L_end_uart_send_data
;Ascenseur.c,398 :: 		}
L_uart_send_data44:
;Ascenseur.c,400 :: 		if      (direction == 'U') dir_n = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data45
	MOVLW       1
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data46
L_uart_send_data45:
;Ascenseur.c,401 :: 		else if (direction == 'D') dir_n = 2;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data47
	MOVLW       2
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data48
L_uart_send_data47:
;Ascenseur.c,402 :: 		else                       dir_n = 0;
	CLRF        uart_send_data_dir_n_L0+0 
L_uart_send_data48:
L_uart_send_data46:
;Ascenseur.c,404 :: 		prt_n = mode_auto ? (ir_porte ? 1 : 0) : (porte_cmd ? 1 : 0);
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data49
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data51
	MOVLW       1
	MOVWF       ?FLOC___uart_send_dataT97+0 
	GOTO        L_uart_send_data52
L_uart_send_data51:
	CLRF        ?FLOC___uart_send_dataT97+0 
L_uart_send_data52:
	MOVF        ?FLOC___uart_send_dataT97+0, 0 
	MOVWF       ?FLOC___uart_send_dataT98+0 
	GOTO        L_uart_send_data50
L_uart_send_data49:
	MOVF        _porte_cmd+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data53
	MOVLW       1
	MOVWF       ?FLOC___uart_send_dataT99+0 
	GOTO        L_uart_send_data54
L_uart_send_data53:
	CLRF        ?FLOC___uart_send_dataT99+0 
L_uart_send_data54:
	MOVF        ?FLOC___uart_send_dataT99+0, 0 
	MOVWF       ?FLOC___uart_send_dataT98+0 
L_uart_send_data50:
;Ascenseur.c,406 :: 		sprintf(trame,
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_sprintf_wh+1 
;Ascenseur.c,407 :: 		"<DATA,ET:%d,DIR:%d,PT:%d,PRT:%d,AL:%d,URG:%d,NB:%d,PWM:%d,TPS:%d>\r\n",
	MOVLW       ?lstr_1_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,408 :: 		(int)etage_actuel, (int)dir_n, (int)poids_kg,
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
;Ascenseur.c,409 :: 		(int)prt_n,        (int)al_active, (int)urg_active,
	MOVF        ?FLOC___uart_send_dataT98+0, 0 
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
;Ascenseur.c,410 :: 		(int)nb_session,   (int)pwm_actuel, (int)temps_trajet);
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
;Ascenseur.c,412 :: 		UART1_Write_Text(trame);
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,413 :: 		}
L_end_uart_send_data:
	RETURN      0
; end of _uart_send_data

_uart_send_eeprom:

;Ascenseur.c,416 :: 		void uart_send_eeprom() {
;Ascenseur.c,418 :: 		suppress_data_count = 1;
	MOVLW       1
	MOVWF       _suppress_data_count+0 
;Ascenseur.c,419 :: 		sprintf(trame,
	MOVLW       uart_send_eeprom_trame_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(uart_send_eeprom_trame_L0+0)
	MOVWF       FARG_sprintf_wh+1 
;Ascenseur.c,420 :: 		"<EEP,TRAJ:%d,LAST:%d,VITESSE:%d>\r\n",
	MOVLW       ?lstr_2_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_2_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_2_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,421 :: 		(int)nb_trajets, (int)last_etage, (int)vitesse_eeprom);
	MOVF        _nb_trajets+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _nb_trajets+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _last_etage+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+8 
	MOVF        _vitesse_eeprom+0, 0 
	MOVWF       FARG_sprintf_wh+9 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+10 
	CALL        _sprintf+0, 0
;Ascenseur.c,422 :: 		UART1_Write_Text(trame);
	MOVLW       uart_send_eeprom_trame_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(uart_send_eeprom_trame_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,423 :: 		}
L_end_uart_send_eeprom:
	RETURN      0
; end of _uart_send_eeprom

_uart_ack_ok:

;Ascenseur.c,426 :: 		void uart_ack_ok()  { UART1_Write_Text("<ACK,OK>\r\n");  }
	MOVLW       ?lstr3_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
L_end_uart_ack_ok:
	RETURN      0
; end of _uart_ack_ok

_uart_ack_err:

;Ascenseur.c,427 :: 		void uart_ack_err() { UART1_Write_Text("<ACK,ERR>\r\n"); }
	MOVLW       ?lstr4_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
L_end_uart_ack_err:
	RETURN      0
; end of _uart_ack_err

_lire_capteurs:

;Ascenseur.c,430 :: 		void lire_capteurs() {
;Ascenseur.c,431 :: 		unsigned long somme = 0;
	CLRF        lire_capteurs_somme_L0+0 
	CLRF        lire_capteurs_somme_L0+1 
	CLRF        lire_capteurs_somme_L0+2 
	CLRF        lire_capteurs_somme_L0+3 
;Ascenseur.c,435 :: 		ir_porte = PORTA.F0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       _ir_porte+0 
;Ascenseur.c,437 :: 		ADC_Read(1);
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;Ascenseur.c,438 :: 		for (n = 0; n < 8; n++) {
	CLRF        lire_capteurs_n_L0+0 
L_lire_capteurs55:
	MOVLW       8
	SUBWF       lire_capteurs_n_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_lire_capteurs56
;Ascenseur.c,439 :: 		somme += ADC_Read(1);
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	ADDWF       lire_capteurs_somme_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      lire_capteurs_somme_L0+1, 1 
	MOVLW       0
	ADDWFC      lire_capteurs_somme_L0+2, 1 
	ADDWFC      lire_capteurs_somme_L0+3, 1 
;Ascenseur.c,438 :: 		for (n = 0; n < 8; n++) {
	INCF        lire_capteurs_n_L0+0, 1 
;Ascenseur.c,440 :: 		}
	GOTO        L_lire_capteurs55
L_lire_capteurs56:
;Ascenseur.c,441 :: 		raw_adc = (unsigned int)(somme >> 3);
	MOVLW       3
	MOVWF       R0 
	MOVF        lire_capteurs_somme_L0+0, 0 
	MOVWF       R1 
	MOVF        lire_capteurs_somme_L0+1, 0 
	MOVWF       R2 
	MOVF        lire_capteurs_somme_L0+2, 0 
	MOVWF       R3 
	MOVF        lire_capteurs_somme_L0+3, 0 
	MOVWF       R4 
	MOVF        R0, 0 
L__lire_capteurs569:
	BZ          L__lire_capteurs570
	RRCF        R4, 1 
	RRCF        R3, 1 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R4, 7 
	ADDLW       255
	GOTO        L__lire_capteurs569
L__lire_capteurs570:
	MOVF        R1, 0 
	MOVWF       lire_capteurs_raw_adc_L0+0 
	MOVF        R2, 0 
	MOVWF       lire_capteurs_raw_adc_L0+1 
;Ascenseur.c,443 :: 		if (raw_adc > POT_ADC_MAX) raw_adc = POT_ADC_MAX;
	MOVF        R2, 0 
	SUBLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__lire_capteurs571
	MOVF        R1, 0 
	SUBLW       132
L__lire_capteurs571:
	BTFSC       STATUS+0, 0 
	GOTO        L_lire_capteurs58
	MOVLW       132
	MOVWF       lire_capteurs_raw_adc_L0+0 
	MOVLW       3
	MOVWF       lire_capteurs_raw_adc_L0+1 
L_lire_capteurs58:
;Ascenseur.c,444 :: 		poids_kg = (unsigned int)((raw_adc * 900UL) / POT_ADC_MAX);
	MOVF        lire_capteurs_raw_adc_L0+0, 0 
	MOVWF       R0 
	MOVF        lire_capteurs_raw_adc_L0+1, 0 
	MOVWF       R1 
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
	MOVLW       132
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
;Ascenseur.c,445 :: 		}
L_end_lire_capteurs:
	RETURN      0
; end of _lire_capteurs

_maj_surcharge:

;Ascenseur.c,448 :: 		void maj_surcharge(unsigned char force_transition) {
;Ascenseur.c,449 :: 		surcharge_active = (poids_kg >= seuil_surge) ? 1 : 0;
	MOVF        _seuil_surge+1, 0 
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__maj_surcharge573
	MOVF        _seuil_surge+0, 0 
	SUBWF       _poids_kg+0, 0 
L__maj_surcharge573:
	BTFSS       STATUS+0, 0 
	GOTO        L_maj_surcharge59
	MOVLW       1
	MOVWF       ?FLOC___maj_surchargeT131+0 
	GOTO        L_maj_surcharge60
L_maj_surcharge59:
	CLRF        ?FLOC___maj_surchargeT131+0 
L_maj_surcharge60:
	MOVF        ?FLOC___maj_surchargeT131+0, 0 
	MOVWF       _surcharge_active+0 
;Ascenseur.c,450 :: 		if (force_transition) {
	MOVF        FARG_maj_surcharge_force_transition+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_maj_surcharge61
;Ascenseur.c,451 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,452 :: 		}
L_maj_surcharge61:
;Ascenseur.c,453 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,454 :: 		}
L_end_maj_surcharge:
	RETURN      0
; end of _maj_surcharge

_gerer_leds:

;Ascenseur.c,457 :: 		void gerer_leds() {
;Ascenseur.c,458 :: 		if (mode_auto) LED1 = ir_porte ? 1 : 0;
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_leds62
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_leds63
	MOVLW       1
	MOVWF       R0 
	GOTO        L_gerer_leds64
L_gerer_leds63:
	CLRF        R0 
L_gerer_leds64:
	BTFSC       R0, 0 
	GOTO        L__gerer_leds575
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L__gerer_leds576
L__gerer_leds575:
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
L__gerer_leds576:
	GOTO        L_gerer_leds65
L_gerer_leds62:
;Ascenseur.c,459 :: 		else           LED1 = porte_cmd ? 1 : 0;
	MOVF        _porte_cmd+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_leds66
	MOVLW       1
	MOVWF       R1 
	GOTO        L_gerer_leds67
L_gerer_leds66:
	CLRF        R1 
L_gerer_leds67:
	BTFSC       R1, 0 
	GOTO        L__gerer_leds577
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L__gerer_leds578
L__gerer_leds577:
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
L__gerer_leds578:
L_gerer_leds65:
;Ascenseur.c,461 :: 		LED2 = (surcharge_active || urg_active || al_active) ? 1 : 0;
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds500
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds500
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds500
	GOTO        L_gerer_leds70
L__gerer_leds500:
	MOVLW       1
	MOVWF       R2 
	GOTO        L_gerer_leds71
L_gerer_leds70:
	CLRF        R2 
L_gerer_leds71:
	BTFSC       R2, 0 
	GOTO        L__gerer_leds579
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
	GOTO        L__gerer_leds580
L__gerer_leds579:
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
L__gerer_leds580:
;Ascenseur.c,462 :: 		}
L_end_gerer_leds:
	RETURN      0
; end of _gerer_leds

_etat_porte_char:

;Ascenseur.c,465 :: 		char etat_porte_char() {
;Ascenseur.c,466 :: 		return (mode_auto ? ir_porte : porte_cmd) ? 'O' : 'F';
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_etat_porte_char72
	MOVF        _ir_porte+0, 0 
	MOVWF       R1 
	GOTO        L_etat_porte_char73
L_etat_porte_char72:
	MOVF        _porte_cmd+0, 0 
	MOVWF       R1 
L_etat_porte_char73:
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_etat_porte_char74
	MOVLW       79
	MOVWF       R2 
	GOTO        L_etat_porte_char75
L_etat_porte_char74:
	MOVLW       70
	MOVWF       R2 
L_etat_porte_char75:
	MOVF        R2, 0 
	MOVWF       R0 
;Ascenseur.c,467 :: 		}
L_end_etat_porte_char:
	RETURN      0
; end of _etat_porte_char

_lcd_build_surcharge_l2:

;Ascenseur.c,470 :: 		void lcd_build_surcharge_l2(char *buf) {
;Ascenseur.c,471 :: 		unsigned int v = poids_max;
	MOVF        _poids_max+0, 0 
	MOVWF       lcd_build_surcharge_l2_v_L0+0 
	MOVF        _poids_max+1, 0 
	MOVWF       lcd_build_surcharge_l2_v_L0+1 
;Ascenseur.c,473 :: 		buf[0]  = ' ';
	MOVFF       FARG_lcd_build_surcharge_l2_buf+0, FSR1L+0
	MOVFF       FARG_lcd_build_surcharge_l2_buf+1, FSR1H+0
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,474 :: 		buf[1]  = ' ';
	MOVLW       1
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,475 :: 		buf[2]  = 'M';
	MOVLW       2
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       77
	MOVWF       POSTINC1+0 
;Ascenseur.c,476 :: 		buf[3]  = 'A';
	MOVLW       3
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       65
	MOVWF       POSTINC1+0 
;Ascenseur.c,477 :: 		buf[4]  = 'X';
	MOVLW       4
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       88
	MOVWF       POSTINC1+0 
;Ascenseur.c,478 :: 		buf[5]  = ':';
	MOVLW       5
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       58
	MOVWF       POSTINC1+0 
;Ascenseur.c,479 :: 		buf[6]  = (v >= 100) ? ((char)('0' + (v / 100)))       : ' ';
	MOVLW       6
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+1 
	MOVLW       0
	SUBWF       lcd_build_surcharge_l2_v_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__lcd_build_surcharge_l2583
	MOVLW       100
	SUBWF       lcd_build_surcharge_l2_v_L0+0, 0 
L__lcd_build_surcharge_l2583:
	BTFSS       STATUS+0, 0 
	GOTO        L_lcd_build_surcharge_l276
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        lcd_build_surcharge_l2_v_L0+0, 0 
	MOVWF       R0 
	MOVF        lcd_build_surcharge_l2_v_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       ?FLOC___lcd_build_surcharge_l2T156+0 
	GOTO        L_lcd_build_surcharge_l277
L_lcd_build_surcharge_l276:
	MOVLW       32
	MOVWF       ?FLOC___lcd_build_surcharge_l2T156+0 
L_lcd_build_surcharge_l277:
	MOVFF       FLOC__lcd_build_surcharge_l2+0, FSR1L+0
	MOVFF       FLOC__lcd_build_surcharge_l2+1, FSR1H+0
	MOVF        ?FLOC___lcd_build_surcharge_l2T156+0, 0 
	MOVWF       POSTINC1+0 
;Ascenseur.c,480 :: 		buf[7]  = (v >= 10)  ? ((char)('0' + ((v / 10) % 10))) : ' ';
	MOVLW       7
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+1 
	MOVLW       0
	SUBWF       lcd_build_surcharge_l2_v_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__lcd_build_surcharge_l2584
	MOVLW       10
	SUBWF       lcd_build_surcharge_l2_v_L0+0, 0 
L__lcd_build_surcharge_l2584:
	BTFSS       STATUS+0, 0 
	GOTO        L_lcd_build_surcharge_l278
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        lcd_build_surcharge_l2_v_L0+0, 0 
	MOVWF       R0 
	MOVF        lcd_build_surcharge_l2_v_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       ?FLOC___lcd_build_surcharge_l2T164+0 
	GOTO        L_lcd_build_surcharge_l279
L_lcd_build_surcharge_l278:
	MOVLW       32
	MOVWF       ?FLOC___lcd_build_surcharge_l2T164+0 
L_lcd_build_surcharge_l279:
	MOVFF       FLOC__lcd_build_surcharge_l2+0, FSR1L+0
	MOVFF       FLOC__lcd_build_surcharge_l2+1, FSR1H+0
	MOVF        ?FLOC___lcd_build_surcharge_l2T164+0, 0 
	MOVWF       POSTINC1+0 
;Ascenseur.c,481 :: 		buf[8]  = (char)('0' + (v % 10));
	MOVLW       8
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        lcd_build_surcharge_l2_v_L0+0, 0 
	MOVWF       R0 
	MOVF        lcd_build_surcharge_l2_v_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__lcd_build_surcharge_l2+0, FSR1L+0
	MOVFF       FLOC__lcd_build_surcharge_l2+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Ascenseur.c,482 :: 		buf[9]  = ' ';
	MOVLW       9
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,483 :: 		buf[10] = 'k';
	MOVLW       10
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       107
	MOVWF       POSTINC1+0 
;Ascenseur.c,484 :: 		buf[11] = 'g';
	MOVLW       11
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       103
	MOVWF       POSTINC1+0 
;Ascenseur.c,485 :: 		buf[12] = ' ';
	MOVLW       12
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,486 :: 		buf[13] = ' ';
	MOVLW       13
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,487 :: 		buf[14] = ' ';
	MOVLW       14
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,488 :: 		buf[15] = ' ';
	MOVLW       15
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,489 :: 		buf[16] = '\0';
	MOVLW       16
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;Ascenseur.c,490 :: 		}
L_end_lcd_build_surcharge_l2:
	RETURN      0
; end of _lcd_build_surcharge_l2

_afficher_lcd:

;Ascenseur.c,493 :: 		void afficher_lcd() {
;Ascenseur.c,498 :: 		if (position_inconnue) {
	MOVF        _position_inconnue+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd80
;Ascenseur.c,499 :: 		Lcd_Out(1, 1, "POS INCONNUE!   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,500 :: 		Lcd_Out(2, 1, "Replacer manuel ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,501 :: 		return;
	GOTO        L_end_afficher_lcd
;Ascenseur.c,502 :: 		}
L_afficher_lcd80:
;Ascenseur.c,504 :: 		if (!urg_active && !al_active && surcharge_active) {
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd83
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd83
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd83
L__afficher_lcd501:
;Ascenseur.c,505 :: 		lcd_build_surcharge_l2(surcharge_l2);
	MOVLW       afficher_lcd_surcharge_l2_L0+0
	MOVWF       FARG_lcd_build_surcharge_l2_buf+0 
	MOVLW       hi_addr(afficher_lcd_surcharge_l2_L0+0)
	MOVWF       FARG_lcd_build_surcharge_l2_buf+1 
	CALL        _lcd_build_surcharge_l2+0, 0
;Ascenseur.c,506 :: 		Lcd_Out(1, 1, "  SURCHARGE!    ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,507 :: 		Lcd_Out(2, 1, surcharge_l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       afficher_lcd_surcharge_l2_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(afficher_lcd_surcharge_l2_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,508 :: 		return;
	GOTO        L_end_afficher_lcd
;Ascenseur.c,509 :: 		}
L_afficher_lcd83:
;Ascenseur.c,511 :: 		if (mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd84
;Ascenseur.c,512 :: 		mode_str[0]='A'; mode_str[1]='u'; mode_str[2]='t'; mode_str[3]='o'; mode_str[4]='\0';
	MOVLW       65
	MOVWF       afficher_lcd_mode_str_L0+0 
	MOVLW       117
	MOVWF       afficher_lcd_mode_str_L0+1 
	MOVLW       116
	MOVWF       afficher_lcd_mode_str_L0+2 
	MOVLW       111
	MOVWF       afficher_lcd_mode_str_L0+3 
	CLRF        afficher_lcd_mode_str_L0+4 
;Ascenseur.c,513 :: 		} else {
	GOTO        L_afficher_lcd85
L_afficher_lcd84:
;Ascenseur.c,514 :: 		mode_str[0]='M'; mode_str[1]='a'; mode_str[2]='n'; mode_str[3]='u'; mode_str[4]='\0';
	MOVLW       77
	MOVWF       afficher_lcd_mode_str_L0+0 
	MOVLW       97
	MOVWF       afficher_lcd_mode_str_L0+1 
	MOVLW       110
	MOVWF       afficher_lcd_mode_str_L0+2 
	MOVLW       117
	MOVWF       afficher_lcd_mode_str_L0+3 
	CLRF        afficher_lcd_mode_str_L0+4 
;Ascenseur.c,515 :: 		}
L_afficher_lcd85:
;Ascenseur.c,517 :: 		if (en_mouvement) {
	MOVF        _en_mouvement+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd86
;Ascenseur.c,518 :: 		if (direction == 'U') { dir_str[0]='U'; dir_str[1]='P'; dir_str[2]='\0'; }
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd87
	MOVLW       85
	MOVWF       afficher_lcd_dir_str_L0+0 
	MOVLW       80
	MOVWF       afficher_lcd_dir_str_L0+1 
	CLRF        afficher_lcd_dir_str_L0+2 
	GOTO        L_afficher_lcd88
L_afficher_lcd87:
;Ascenseur.c,519 :: 		else                  { dir_str[0]='D'; dir_str[1]='N'; dir_str[2]='\0'; }
	MOVLW       68
	MOVWF       afficher_lcd_dir_str_L0+0 
	MOVLW       78
	MOVWF       afficher_lcd_dir_str_L0+1 
	CLRF        afficher_lcd_dir_str_L0+2 
L_afficher_lcd88:
;Ascenseur.c,521 :: 		sprintf(l1, "ET:%u->%u %s %s ",
	MOVLW       _l1+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_8_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_8_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_8_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,522 :: 		(unsigned)etage_actuel, (unsigned)etage_cible, dir_str, mode_str);
	MOVF        _etage_actuel+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _etage_cible+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+8 
	MOVLW       afficher_lcd_dir_str_L0+0
	MOVWF       FARG_sprintf_wh+9 
	MOVLW       hi_addr(afficher_lcd_dir_str_L0+0)
	MOVWF       FARG_sprintf_wh+10 
	MOVLW       afficher_lcd_mode_str_L0+0
	MOVWF       FARG_sprintf_wh+11 
	MOVLW       hi_addr(afficher_lcd_mode_str_L0+0)
	MOVWF       FARG_sprintf_wh+12 
	CALL        _sprintf+0, 0
;Ascenseur.c,523 :: 		} else {
	GOTO        L_afficher_lcd89
L_afficher_lcd86:
;Ascenseur.c,524 :: 		sprintf(l1, "ET:%u STOP  %s ",
	MOVLW       _l1+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_9_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_9_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_9_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,525 :: 		(unsigned)etage_actuel, mode_str);
	MOVF        _etage_actuel+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       afficher_lcd_mode_str_L0+0
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       hi_addr(afficher_lcd_mode_str_L0+0)
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;Ascenseur.c,526 :: 		}
L_afficher_lcd89:
;Ascenseur.c,528 :: 		Lcd_Out(1, 1, l1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,529 :: 		sprintf(l2, "P:%3dkg IR:%c    ", (int)poids_kg, etat_porte_char());
	CALL        _etat_porte_char+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       _l2+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_10_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_10_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_10_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _poids_kg+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _poids_kg+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
;Ascenseur.c,530 :: 		Lcd_Out(2, 1, l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,531 :: 		}
L_end_afficher_lcd:
	RETURN      0
; end of _afficher_lcd

_lcd_transition:

;Ascenseur.c,534 :: 		void lcd_transition() {
;Ascenseur.c,535 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,536 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,537 :: 		}
L_end_lcd_transition:
	RETURN      0
; end of _lcd_transition

_lcd_update_transit:

;Ascenseur.c,540 :: 		void lcd_update_transit() {
;Ascenseur.c,544 :: 		if (direction == 'U') { dir_str[0]='U'; dir_str[1]='P'; dir_str[2]='\0'; }
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_update_transit90
	MOVLW       85
	MOVWF       lcd_update_transit_dir_str_L0+0 
	MOVLW       80
	MOVWF       lcd_update_transit_dir_str_L0+1 
	CLRF        lcd_update_transit_dir_str_L0+2 
	GOTO        L_lcd_update_transit91
L_lcd_update_transit90:
;Ascenseur.c,545 :: 		else                  { dir_str[0]='D'; dir_str[1]='N'; dir_str[2]='\0'; }
	MOVLW       68
	MOVWF       lcd_update_transit_dir_str_L0+0 
	MOVLW       78
	MOVWF       lcd_update_transit_dir_str_L0+1 
	CLRF        lcd_update_transit_dir_str_L0+2 
L_lcd_update_transit91:
;Ascenseur.c,547 :: 		if (mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_update_transit92
;Ascenseur.c,548 :: 		mode_str[0]='A'; mode_str[1]='u'; mode_str[2]='t'; mode_str[3]='o'; mode_str[4]='\0';
	MOVLW       65
	MOVWF       lcd_update_transit_mode_str_L0+0 
	MOVLW       117
	MOVWF       lcd_update_transit_mode_str_L0+1 
	MOVLW       116
	MOVWF       lcd_update_transit_mode_str_L0+2 
	MOVLW       111
	MOVWF       lcd_update_transit_mode_str_L0+3 
	CLRF        lcd_update_transit_mode_str_L0+4 
;Ascenseur.c,549 :: 		} else {
	GOTO        L_lcd_update_transit93
L_lcd_update_transit92:
;Ascenseur.c,550 :: 		mode_str[0]='M'; mode_str[1]='a'; mode_str[2]='n'; mode_str[3]='u'; mode_str[4]='\0';
	MOVLW       77
	MOVWF       lcd_update_transit_mode_str_L0+0 
	MOVLW       97
	MOVWF       lcd_update_transit_mode_str_L0+1 
	MOVLW       110
	MOVWF       lcd_update_transit_mode_str_L0+2 
	MOVLW       117
	MOVWF       lcd_update_transit_mode_str_L0+3 
	CLRF        lcd_update_transit_mode_str_L0+4 
;Ascenseur.c,551 :: 		}
L_lcd_update_transit93:
;Ascenseur.c,558 :: 		sprintf(l1, "ET:%u->%u %s %s ",
	MOVLW       _l1+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_11_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_11_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_11_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,559 :: 		(unsigned)etage_actuel, (unsigned)etage_cible, dir_str, mode_str);
	MOVF        _etage_actuel+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _etage_cible+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+8 
	MOVLW       lcd_update_transit_dir_str_L0+0
	MOVWF       FARG_sprintf_wh+9 
	MOVLW       hi_addr(lcd_update_transit_dir_str_L0+0)
	MOVWF       FARG_sprintf_wh+10 
	MOVLW       lcd_update_transit_mode_str_L0+0
	MOVWF       FARG_sprintf_wh+11 
	MOVLW       hi_addr(lcd_update_transit_mode_str_L0+0)
	MOVWF       FARG_sprintf_wh+12 
	CALL        _sprintf+0, 0
;Ascenseur.c,560 :: 		Lcd_Out(1, 1, l1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,562 :: 		sprintf(l2, "P:%3dkg IR:%c    ", (int)poids_kg, etat_porte_char());
	CALL        _etat_porte_char+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       _l2+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_12_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_12_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_12_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _poids_kg+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _poids_kg+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
;Ascenseur.c,563 :: 		Lcd_Out(2, 1, l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,568 :: 		}
L_end_lcd_update_transit:
	RETURN      0
; end of _lcd_update_transit

_appliquer_pmax:

;Ascenseur.c,571 :: 		void appliquer_pmax(unsigned int val) {
;Ascenseur.c,572 :: 		if (val < 1)   val = 1;
	MOVLW       0
	SUBWF       FARG_appliquer_pmax_val+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__appliquer_pmax589
	MOVLW       1
	SUBWF       FARG_appliquer_pmax_val+0, 0 
L__appliquer_pmax589:
	BTFSC       STATUS+0, 0 
	GOTO        L_appliquer_pmax94
	MOVLW       1
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVLW       0
	MOVWF       FARG_appliquer_pmax_val+1 
L_appliquer_pmax94:
;Ascenseur.c,573 :: 		if (val > 999) val = 999;
	MOVF        FARG_appliquer_pmax_val+1, 0 
	SUBLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__appliquer_pmax590
	MOVF        FARG_appliquer_pmax_val+0, 0 
	SUBLW       231
L__appliquer_pmax590:
	BTFSC       STATUS+0, 0 
	GOTO        L_appliquer_pmax95
	MOVLW       231
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVLW       3
	MOVWF       FARG_appliquer_pmax_val+1 
L_appliquer_pmax95:
;Ascenseur.c,575 :: 		poids_max  = val;
	MOVF        FARG_appliquer_pmax_val+0, 0 
	MOVWF       _poids_max+0 
	MOVF        FARG_appliquer_pmax_val+1, 0 
	MOVWF       _poids_max+1 
;Ascenseur.c,576 :: 		seuil_surge = val;
	MOVF        FARG_appliquer_pmax_val+0, 0 
	MOVWF       _seuil_surge+0 
	MOVF        FARG_appliquer_pmax_val+1, 0 
	MOVWF       _seuil_surge+1 
;Ascenseur.c,578 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,579 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,581 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,582 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,583 :: 		}
L_end_appliquer_pmax:
	RETURN      0
; end of _appliquer_pmax

_appliquer_spd:

;Ascenseur.c,586 :: 		void appliquer_spd(unsigned char val) {
;Ascenseur.c,587 :: 		if (val > 100) val = 100;
	MOVF        FARG_appliquer_spd_val+0, 0 
	SUBLW       100
	BTFSC       STATUS+0, 0 
	GOTO        L_appliquer_spd96
	MOVLW       100
	MOVWF       FARG_appliquer_spd_val+0 
L_appliquer_spd96:
;Ascenseur.c,588 :: 		if (val < 10)  val = 10;
	MOVLW       10
	SUBWF       FARG_appliquer_spd_val+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_appliquer_spd97
	MOVLW       10
	MOVWF       FARG_appliquer_spd_val+0 
L_appliquer_spd97:
;Ascenseur.c,590 :: 		vitesse_max_pc = val;
	MOVF        FARG_appliquer_spd_val+0, 0 
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,591 :: 		vitesse_eeprom = val;
	MOVF        FARG_appliquer_spd_val+0, 0 
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,592 :: 		recalc_pwm_max();
	CALL        _recalc_pwm_max+0, 0
;Ascenseur.c,593 :: 		eep_write_byte(0x03, vitesse_eeprom);
	MOVLW       3
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        _vitesse_eeprom+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,595 :: 		if (moteur_actif) set_pwm(pwm_max_eff);
	MOVF        _moteur_actif+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_appliquer_spd98
	MOVF        _pwm_max_eff+0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
L_appliquer_spd98:
;Ascenseur.c,597 :: 		suppress_data_count = 1;
	MOVLW       1
	MOVWF       _suppress_data_count+0 
;Ascenseur.c,598 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,599 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,600 :: 		}
L_end_appliquer_spd:
	RETURN      0
; end of _appliquer_spd

_attendre_ms:

;Ascenseur.c,603 :: 		void attendre_ms(unsigned int ms) {
;Ascenseur.c,604 :: 		unsigned int  elapsed = 0;
	CLRF        attendre_ms_elapsed_L0+0 
	CLRF        attendre_ms_elapsed_L0+1 
;Ascenseur.c,612 :: 		while (elapsed < ms) {
L_attendre_ms99:
	MOVF        FARG_attendre_ms_ms+1, 0 
	SUBWF       attendre_ms_elapsed_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms593
	MOVF        FARG_attendre_ms_ms+0, 0 
	SUBWF       attendre_ms_elapsed_L0+0, 0 
L__attendre_ms593:
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms100
;Ascenseur.c,614 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_attendre_ms103
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms103
L__attendre_ms513:
;Ascenseur.c,615 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_attendre_ms104:
	DECFSZ      R13, 1, 1
	BRA         L_attendre_ms104
	DECFSZ      R12, 1, 1
	BRA         L_attendre_ms104
	NOP
	NOP
;Ascenseur.c,616 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_attendre_ms105
;Ascenseur.c,617 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,618 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,619 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,620 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,621 :: 		}
L_attendre_ms105:
;Ascenseur.c,622 :: 		}
L_attendre_ms103:
;Ascenseur.c,624 :: 		if (urgence_flag || stop_demande) return;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms512
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms512
	GOTO        L_attendre_ms111
L__attendre_ms512:
	GOTO        L_end_attendre_ms
L_attendre_ms111:
;Ascenseur.c,627 :: 		if (pop_cmd(local_cmd)) {
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms112
;Ascenseur.c,629 :: 		if (strstr(local_cmd, "CMD,STOP")) {
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr13_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr13_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms113
;Ascenseur.c,630 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,631 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,632 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,633 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,634 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,635 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,636 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,638 :: 		} else if (strstr(local_cmd, "MOT:STP") || strstr(local_cmd, "MOT:STOP")) {
	GOTO        L_attendre_ms117
L_attendre_ms113:
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr14_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr14_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms511
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr15_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr15_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms511
	GOTO        L_attendre_ms120
L__attendre_ms511:
;Ascenseur.c,640 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,641 :: 		stop_demande = 1;
	MOVLW       1
	MOVWF       _stop_demande+0 
;Ascenseur.c,642 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,644 :: 		} else if (strstr(local_cmd, "AL:ON")) {
	GOTO        L_attendre_ms124
L_attendre_ms120:
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr16_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr16_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms125
;Ascenseur.c,645 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,646 :: 		al_flag = 1;
	MOVLW       1
	MOVWF       _al_flag+0 
;Ascenseur.c,647 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,648 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,650 :: 		} else if ((pp = strstr(local_cmd, "CALL:")) != 0) {
	GOTO        L_attendre_ms126
L_attendre_ms125:
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr17_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr17_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       attendre_ms_pp_L0+0 
	MOVF        R1, 0 
	MOVWF       attendre_ms_pp_L0+1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms594
	MOVLW       0
	XORWF       R0, 0 
L__attendre_ms594:
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms127
;Ascenseur.c,651 :: 		nc = (unsigned char)(*(pp + 5) - '0');
	MOVLW       5
	ADDWF       attendre_ms_pp_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      attendre_ms_pp_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       attendre_ms_nc_L0+0 
;Ascenseur.c,652 :: 		if (nc < NB_ETAGES && !al_active && !surcharge_active) {
	MOVLW       4
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms130
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms130
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms130
L__attendre_ms510:
;Ascenseur.c,653 :: 		if      (direction == 'U' && nc > etage_actuel) req[nc] = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms133
	MOVF        attendre_ms_nc_L0+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms133
L__attendre_ms509:
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        attendre_ms_nc_L0+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_attendre_ms134
L_attendre_ms133:
;Ascenseur.c,654 :: 		else if (direction == 'D' && nc < etage_actuel) req[nc] = 1;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms137
	MOVF        _etage_actuel+0, 0 
	SUBWF       attendre_ms_nc_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms137
L__attendre_ms508:
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        attendre_ms_nc_L0+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
L_attendre_ms137:
L_attendre_ms134:
;Ascenseur.c,655 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,656 :: 		} else {
	GOTO        L_attendre_ms138
L_attendre_ms130:
;Ascenseur.c,657 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,658 :: 		}
L_attendre_ms138:
;Ascenseur.c,660 :: 		} else if ((pp = strstr(local_cmd, "PMAX:")) != 0) {
	GOTO        L_attendre_ms139
L_attendre_ms127:
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr18_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr18_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       attendre_ms_pp_L0+0 
	MOVF        R1, 0 
	MOVWF       attendre_ms_pp_L0+1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms595
	MOVLW       0
	XORWF       R0, 0 
L__attendre_ms595:
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms140
;Ascenseur.c,661 :: 		pv = 0;
	CLRF        attendre_ms_pv_L0+0 
	CLRF        attendre_ms_pv_L0+1 
;Ascenseur.c,662 :: 		pp += 5;
	MOVLW       5
	ADDWF       attendre_ms_pp_L0+0, 1 
	MOVLW       0
	ADDWFC      attendre_ms_pp_L0+1, 1 
;Ascenseur.c,663 :: 		while (*pp >= '0' && *pp <= '9') {
L_attendre_ms141:
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_attendre_ms142
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_attendre_ms142
L__attendre_ms507:
;Ascenseur.c,664 :: 		pv = pv * 10 + (unsigned int)(*pp - '0');
	MOVF        attendre_ms_pv_L0+0, 0 
	MOVWF       R0 
	MOVF        attendre_ms_pv_L0+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       attendre_ms_pv_L0+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       attendre_ms_pv_L0+1 
;Ascenseur.c,665 :: 		pp++;
	INFSNZ      attendre_ms_pp_L0+0, 1 
	INCF        attendre_ms_pp_L0+1, 1 
;Ascenseur.c,666 :: 		}
	GOTO        L_attendre_ms141
L_attendre_ms142:
;Ascenseur.c,667 :: 		appliquer_pmax(pv);
	MOVF        attendre_ms_pv_L0+0, 0 
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVF        attendre_ms_pv_L0+1, 0 
	MOVWF       FARG_appliquer_pmax_val+1 
	CALL        _appliquer_pmax+0, 0
;Ascenseur.c,669 :: 		} else if ((pp = strstr(local_cmd, "SPD:")) != 0) {
	GOTO        L_attendre_ms145
L_attendre_ms140:
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr19_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr19_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       attendre_ms_pp_L0+0 
	MOVF        R1, 0 
	MOVWF       attendre_ms_pp_L0+1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms596
	MOVLW       0
	XORWF       R0, 0 
L__attendre_ms596:
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms146
;Ascenseur.c,670 :: 		sv = 0;
	CLRF        attendre_ms_sv_L0+0 
;Ascenseur.c,671 :: 		pp += 4;
	MOVLW       4
	ADDWF       attendre_ms_pp_L0+0, 1 
	MOVLW       0
	ADDWFC      attendre_ms_pp_L0+1, 1 
;Ascenseur.c,672 :: 		while (*pp >= '0' && *pp <= '9') {
L_attendre_ms147:
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_attendre_ms148
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_attendre_ms148
L__attendre_ms506:
;Ascenseur.c,673 :: 		sv = sv * 10 + (unsigned char)(*pp - '0');
	MOVLW       10
	MULWF       attendre_ms_sv_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       attendre_ms_sv_L0+0 
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       attendre_ms_sv_L0+0, 1 
;Ascenseur.c,674 :: 		pp++;
	INFSNZ      attendre_ms_pp_L0+0, 1 
	INCF        attendre_ms_pp_L0+1, 1 
;Ascenseur.c,675 :: 		}
	GOTO        L_attendre_ms147
L_attendre_ms148:
;Ascenseur.c,676 :: 		appliquer_spd(sv);
	MOVF        attendre_ms_sv_L0+0, 0 
	MOVWF       FARG_appliquer_spd_val+0 
	CALL        _appliquer_spd+0, 0
;Ascenseur.c,678 :: 		} else if (strstr(local_cmd, "GET:EEP")) {
	GOTO        L_attendre_ms151
L_attendre_ms146:
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr20_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr20_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms152
;Ascenseur.c,679 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,681 :: 		} else if (strstr(local_cmd, "EEP:RST") || strstr(local_cmd, "RST:EEP")) {
	GOTO        L_attendre_ms153
L_attendre_ms152:
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr21_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr21_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms505
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr22_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr22_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms505
	GOTO        L_attendre_ms156
L__attendre_ms505:
;Ascenseur.c,682 :: 		eeprom_reset();
	CALL        _eeprom_reset+0, 0
;Ascenseur.c,683 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,684 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,685 :: 		}
L_attendre_ms156:
L_attendre_ms153:
L_attendre_ms151:
L_attendre_ms145:
L_attendre_ms139:
L_attendre_ms126:
L_attendre_ms124:
L_attendre_ms117:
;Ascenseur.c,686 :: 		}
L_attendre_ms112:
;Ascenseur.c,688 :: 		if (urgence_flag || stop_demande) return;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms504
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms504
	GOTO        L_attendre_ms159
L__attendre_ms504:
	GOTO        L_end_attendre_ms
L_attendre_ms159:
;Ascenseur.c,691 :: 		for (b = 0; b < NB_ETAGES; b++) {
	CLRF        attendre_ms_b_L0+0 
L_attendre_ms160:
	MOVLW       4
	SUBWF       attendre_ms_b_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms161
;Ascenseur.c,692 :: 		if (PORTD & (1 << b)) {
	MOVF        attendre_ms_b_L0+0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__attendre_ms597:
	BZ          L__attendre_ms598
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__attendre_ms597
L__attendre_ms598:
	MOVF        PORTD+0, 0 
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms163
;Ascenseur.c,693 :: 		if      (direction == 'U' && b > etage_actuel) req[b] = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms166
	MOVF        attendre_ms_b_L0+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms166
L__attendre_ms503:
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        attendre_ms_b_L0+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_attendre_ms167
L_attendre_ms166:
;Ascenseur.c,694 :: 		else if (direction == 'D' && b < etage_actuel) req[b] = 1;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms170
	MOVF        _etage_actuel+0, 0 
	SUBWF       attendre_ms_b_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms170
L__attendre_ms502:
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        attendre_ms_b_L0+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
L_attendre_ms170:
L_attendre_ms167:
;Ascenseur.c,695 :: 		}
L_attendre_ms163:
;Ascenseur.c,691 :: 		for (b = 0; b < NB_ETAGES; b++) {
	INCF        attendre_ms_b_L0+0, 1 
;Ascenseur.c,696 :: 		}
	GOTO        L_attendre_ms160
L_attendre_ms161:
;Ascenseur.c,698 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms171
;Ascenseur.c,699 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,700 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,701 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,702 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,704 :: 		if (moteur_actif) lcd_update_transit();
	MOVF        _moteur_actif+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms172
	CALL        _lcd_update_transit+0, 0
	GOTO        L_attendre_ms173
L_attendre_ms172:
;Ascenseur.c,705 :: 		else              afficher_lcd();
	CALL        _afficher_lcd+0, 0
L_attendre_ms173:
;Ascenseur.c,706 :: 		}
L_attendre_ms171:
;Ascenseur.c,708 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_attendre_ms174:
	DECFSZ      R13, 1, 1
	BRA         L_attendre_ms174
	DECFSZ      R12, 1, 1
	BRA         L_attendre_ms174
	NOP
	NOP
;Ascenseur.c,709 :: 		elapsed += MS_LOOP_STEP;
	MOVLW       20
	ADDWF       attendre_ms_elapsed_L0+0, 1 
	MOVLW       0
	ADDWFC      attendre_ms_elapsed_L0+1, 1 
;Ascenseur.c,710 :: 		}
	GOTO        L_attendre_ms99
L_attendre_ms100:
;Ascenseur.c,711 :: 		}
L_end_attendre_ms:
	RETURN      0
; end of _attendre_ms

_rampe_accel:

;Ascenseur.c,714 :: 		void rampe_accel() {
;Ascenseur.c,718 :: 		for (i = 0; i <= PWM_PALIERS; i++) {
	CLRF        rampe_accel_i_L0+0 
L_rampe_accel175:
	MOVF        rampe_accel_i_L0+0, 0 
	SUBLW       6
	BTFSS       STATUS+0, 0 
	GOTO        L_rampe_accel176
;Ascenseur.c,719 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_accel180
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_rampe_accel180
L__rampe_accel515:
;Ascenseur.c,720 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_accel181:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_accel181
	DECFSZ      R12, 1, 1
	BRA         L_rampe_accel181
	NOP
	NOP
;Ascenseur.c,721 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_accel182
;Ascenseur.c,722 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,723 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,724 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,725 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,726 :: 		}
L_rampe_accel182:
;Ascenseur.c,727 :: 		}
L_rampe_accel180:
;Ascenseur.c,729 :: 		if (urgence_flag || stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_accel514
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_accel514
	GOTO        L_rampe_accel188
L__rampe_accel514:
;Ascenseur.c,730 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,731 :: 		return;
	GOTO        L_end_rampe_accel
;Ascenseur.c,732 :: 		}
L_rampe_accel188:
;Ascenseur.c,734 :: 		pwm = PWM_MIN + ((unsigned int)(pwm_max_eff - PWM_MIN) * i) / PWM_PALIERS;
	MOVLW       80
	SUBWF       _pwm_max_eff+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
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
;Ascenseur.c,735 :: 		set_pwm((unsigned char)pwm);
	MOVF        R0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,736 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,737 :: 		Delay_ms(MS_PALIER);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_accel192:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_accel192
	DECFSZ      R12, 1, 1
	BRA         L_rampe_accel192
	NOP
	NOP
;Ascenseur.c,718 :: 		for (i = 0; i <= PWM_PALIERS; i++) {
	INCF        rampe_accel_i_L0+0, 1 
;Ascenseur.c,738 :: 		}
	GOTO        L_rampe_accel175
L_rampe_accel176:
;Ascenseur.c,739 :: 		}
L_end_rampe_accel:
	RETURN      0
; end of _rampe_accel

_rampe_decel:

;Ascenseur.c,742 :: 		void rampe_decel() {
;Ascenseur.c,746 :: 		for (i = PWM_PALIERS; i > 0; i--) {
	MOVLW       6
	MOVWF       rampe_decel_i_L0+0 
L_rampe_decel193:
	MOVF        rampe_decel_i_L0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_rampe_decel194
;Ascenseur.c,747 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_decel198
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_rampe_decel198
L__rampe_decel517:
;Ascenseur.c,748 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_decel199:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_decel199
	DECFSZ      R12, 1, 1
	BRA         L_rampe_decel199
	NOP
	NOP
;Ascenseur.c,749 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_decel200
;Ascenseur.c,750 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,751 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,752 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,753 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,754 :: 		}
L_rampe_decel200:
;Ascenseur.c,755 :: 		}
L_rampe_decel198:
;Ascenseur.c,757 :: 		if (urgence_flag || stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_decel516
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_decel516
	GOTO        L_rampe_decel206
L__rampe_decel516:
;Ascenseur.c,758 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,759 :: 		return;
	GOTO        L_end_rampe_decel
;Ascenseur.c,760 :: 		}
L_rampe_decel206:
;Ascenseur.c,762 :: 		pwm = PWM_MIN + ((unsigned int)(pwm_max_eff - PWM_MIN) * (i - 1)) / PWM_PALIERS;
	MOVLW       80
	SUBWF       _pwm_max_eff+0, 0 
	MOVWF       R4 
	CLRF        R5 
	MOVLW       0
	SUBWFB      R5, 1 
	DECF        rampe_decel_i_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
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
;Ascenseur.c,763 :: 		set_pwm((unsigned char)pwm);
	MOVF        R0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,764 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,765 :: 		Delay_ms(MS_PALIER);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_decel210:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_decel210
	DECFSZ      R12, 1, 1
	BRA         L_rampe_decel210
	NOP
	NOP
;Ascenseur.c,746 :: 		for (i = PWM_PALIERS; i > 0; i--) {
	DECF        rampe_decel_i_L0+0, 1 
;Ascenseur.c,766 :: 		}
	GOTO        L_rampe_decel193
L_rampe_decel194:
;Ascenseur.c,768 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,769 :: 		}
L_end_rampe_decel:
	RETURN      0
; end of _rampe_decel

_demarrer_moteur:

;Ascenseur.c,772 :: 		void demarrer_moteur(char sens) {
;Ascenseur.c,773 :: 		if (sens == 'U') MOTEUR_MONTER();
	MOVF        FARG_demarrer_moteur_sens+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_demarrer_moteur214
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	MOVLW       1
	MOVWF       _moteur_actif+0 
	GOTO        L_demarrer_moteur218
L_demarrer_moteur214:
;Ascenseur.c,774 :: 		else             MOTEUR_DESCENDRE();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	MOVLW       1
	MOVWF       _moteur_actif+0 
L_demarrer_moteur218:
;Ascenseur.c,776 :: 		set_pwm(PWM_MIN);
	MOVLW       80
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,777 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;Ascenseur.c,778 :: 		rampe_accel();
	CALL        _rampe_accel+0, 0
;Ascenseur.c,779 :: 		}
L_end_demarrer_moteur:
	RETURN      0
; end of _demarrer_moteur

_scanner_req:

;Ascenseur.c,782 :: 		void scanner_req() {
;Ascenseur.c,783 :: 		if (PORTD.F0) req[0] = 1;
	BTFSS       PORTD+0, 0 
	GOTO        L_scanner_req222
	MOVLW       1
	MOVWF       _req+0 
L_scanner_req222:
;Ascenseur.c,784 :: 		if (PORTD.F1) req[1] = 1;
	BTFSS       PORTD+0, 1 
	GOTO        L_scanner_req223
	MOVLW       1
	MOVWF       _req+1 
L_scanner_req223:
;Ascenseur.c,785 :: 		if (PORTD.F2) req[2] = 1;
	BTFSS       PORTD+0, 2 
	GOTO        L_scanner_req224
	MOVLW       1
	MOVWF       _req+2 
L_scanner_req224:
;Ascenseur.c,786 :: 		if (PORTD.F3) req[3] = 1;
	BTFSS       PORTD+0, 3 
	GOTO        L_scanner_req225
	MOVLW       1
	MOVWF       _req+3 
L_scanner_req225:
;Ascenseur.c,787 :: 		}
L_end_scanner_req:
	RETURN      0
; end of _scanner_req

_vider_req:

;Ascenseur.c,790 :: 		void vider_req() {
;Ascenseur.c,792 :: 		for (i = 0; i < NB_ETAGES; i++) req[i] = 0;
	CLRF        R1 
L_vider_req226:
	MOVLW       4
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_vider_req227
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        R1, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
	INCF        R1, 1 
	GOTO        L_vider_req226
L_vider_req227:
;Ascenseur.c,793 :: 		}
L_end_vider_req:
	RETURN      0
; end of _vider_req

_prochain_req:

;Ascenseur.c,796 :: 		unsigned char prochain_req() {
;Ascenseur.c,800 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,802 :: 		if (direction == 'U') {
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req229
;Ascenseur.c,803 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       R4 
L_prochain_req230:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req231
;Ascenseur.c,804 :: 		if (req[i]) { req[i] = 0; return i; }
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
	GOTO        L_prochain_req233
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
L_prochain_req233:
;Ascenseur.c,803 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	INCF        R4, 1 
;Ascenseur.c,804 :: 		if (req[i]) { req[i] = 0; return i; }
	GOTO        L_prochain_req230
L_prochain_req231:
;Ascenseur.c,806 :: 		for (i = 0; i < etage_actuel; i++)
	CLRF        R4 
L_prochain_req234:
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req235
;Ascenseur.c,807 :: 		if (req[i]) { req[i] = 0; return i; }
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
	GOTO        L_prochain_req237
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
L_prochain_req237:
;Ascenseur.c,806 :: 		for (i = 0; i < etage_actuel; i++)
	INCF        R4, 1 
;Ascenseur.c,807 :: 		if (req[i]) { req[i] = 0; return i; }
	GOTO        L_prochain_req234
L_prochain_req235:
;Ascenseur.c,809 :: 		} else if (direction == 'D') {
	GOTO        L_prochain_req238
L_prochain_req229:
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req239
;Ascenseur.c,810 :: 		for (i = etage_actuel; i > 0; i--)
	MOVF        _etage_actuel+0, 0 
	MOVWF       R4 
L_prochain_req240:
	MOVF        R4, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req241
;Ascenseur.c,811 :: 		if (req[i - 1]) { req[i - 1] = 0; return i - 1; }
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
	GOTO        L_prochain_req243
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
L_prochain_req243:
;Ascenseur.c,810 :: 		for (i = etage_actuel; i > 0; i--)
	DECF        R4, 1 
;Ascenseur.c,811 :: 		if (req[i - 1]) { req[i - 1] = 0; return i - 1; }
	GOTO        L_prochain_req240
L_prochain_req241:
;Ascenseur.c,813 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       R4 
L_prochain_req244:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req245
;Ascenseur.c,814 :: 		if (req[i]) { req[i] = 0; return i; }
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
	GOTO        L_prochain_req247
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
L_prochain_req247:
;Ascenseur.c,813 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	INCF        R4, 1 
;Ascenseur.c,814 :: 		if (req[i]) { req[i] = 0; return i; }
	GOTO        L_prochain_req244
L_prochain_req245:
;Ascenseur.c,816 :: 		} else {
	GOTO        L_prochain_req248
L_prochain_req239:
;Ascenseur.c,817 :: 		nearest = 0xFF;
	MOVLW       255
	MOVWF       R5 
;Ascenseur.c,818 :: 		min_d = 10;
	MOVLW       10
	MOVWF       R8 
	MOVLW       0
	MOVWF       R9 
;Ascenseur.c,820 :: 		for (i = 0; i < NB_ETAGES; i++) {
	CLRF        R4 
L_prochain_req249:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req250
;Ascenseur.c,821 :: 		if (!req[i]) continue;
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
	GOTO        L_prochain_req252
	GOTO        L_prochain_req251
L_prochain_req252:
;Ascenseur.c,823 :: 		d = (i >= etage_actuel) ? (unsigned int)(i - etage_actuel)
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_prochain_req253
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
;Ascenseur.c,824 :: 		: (unsigned int)(etage_actuel - i);
	GOTO        L_prochain_req254
L_prochain_req253:
	MOVF        R4, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
L_prochain_req254:
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
;Ascenseur.c,826 :: 		if (d < min_d) {
	MOVF        R9, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__prochain_req605
	MOVF        R8, 0 
	SUBWF       R2, 0 
L__prochain_req605:
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req255
;Ascenseur.c,827 :: 		min_d = d;
	MOVF        R6, 0 
	MOVWF       R8 
	MOVF        R7, 0 
	MOVWF       R9 
;Ascenseur.c,828 :: 		nearest = i;
	MOVF        R4, 0 
	MOVWF       R5 
;Ascenseur.c,829 :: 		}
L_prochain_req255:
;Ascenseur.c,830 :: 		}
L_prochain_req251:
;Ascenseur.c,820 :: 		for (i = 0; i < NB_ETAGES; i++) {
	INCF        R4, 1 
;Ascenseur.c,830 :: 		}
	GOTO        L_prochain_req249
L_prochain_req250:
;Ascenseur.c,832 :: 		if (nearest != 0xFF) {
	MOVF        R5, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_prochain_req256
;Ascenseur.c,833 :: 		req[nearest] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        R5, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,834 :: 		return nearest;
	MOVF        R5, 0 
	MOVWF       R0 
	GOTO        L_end_prochain_req
;Ascenseur.c,835 :: 		}
L_prochain_req256:
;Ascenseur.c,836 :: 		}
L_prochain_req248:
L_prochain_req238:
;Ascenseur.c,838 :: 		return 0xFF;
	MOVLW       255
	MOVWF       R0 
;Ascenseur.c,839 :: 		}
L_end_prochain_req:
	RETURN      0
; end of _prochain_req

_deplacer_vers:

;Ascenseur.c,842 :: 		void deplacer_vers(unsigned char cible) {
;Ascenseur.c,847 :: 		if (cible == etage_actuel || urgence_flag) return;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	XORWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__deplacer_vers530
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers530
	GOTO        L_deplacer_vers259
L__deplacer_vers530:
	GOTO        L_end_deplacer_vers
L_deplacer_vers259:
;Ascenseur.c,849 :: 		stop_demande = 0;
	CLRF        _stop_demande+0 
;Ascenseur.c,851 :: 		sens = (cible > etage_actuel) ? 'U' : 'D';
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers260
	MOVLW       85
	MOVWF       ?FLOC___deplacer_versT463+0 
	GOTO        L_deplacer_vers261
L_deplacer_vers260:
	MOVLW       68
	MOVWF       ?FLOC___deplacer_versT463+0 
L_deplacer_vers261:
	MOVF        ?FLOC___deplacer_versT463+0, 0 
	MOVWF       deplacer_vers_sens_L0+0 
;Ascenseur.c,852 :: 		direction = sens;
	MOVF        ?FLOC___deplacer_versT463+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,853 :: 		etage_cible = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,854 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,856 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,857 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,858 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,859 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,860 :: 		temps_debut = timer0_count;
	MOVF        _timer0_count+0, 0 
	MOVWF       deplacer_vers_temps_debut_L0+0 
	MOVF        _timer0_count+1, 0 
	MOVWF       deplacer_vers_temps_debut_L0+1 
;Ascenseur.c,862 :: 		attendre_ms(MS_FERMETURE);
	MOVLW       50
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       0
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,863 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers529
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers529
	GOTO        L_deplacer_vers264
L__deplacer_vers529:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers264:
;Ascenseur.c,865 :: 		nb_et = (cible > etage_actuel) ? (cible - etage_actuel) : (etage_actuel - cible);
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers265
	MOVF        _etage_actuel+0, 0 
	SUBWF       FARG_deplacer_vers_cible+0, 0 
	MOVWF       ?FLOC___deplacer_versT467+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT467+1 
	GOTO        L_deplacer_vers266
L_deplacer_vers265:
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       ?FLOC___deplacer_versT467+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT467+1 
L_deplacer_vers266:
	MOVF        ?FLOC___deplacer_versT467+0, 0 
	MOVWF       deplacer_vers_nb_et_L0+0 
;Ascenseur.c,867 :: 		demarrer_moteur(sens);
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       FARG_demarrer_moteur_sens+0 
	CALL        _demarrer_moteur+0, 0
;Ascenseur.c,868 :: 		lcd_update_transit();
	CALL        _lcd_update_transit+0, 0
;Ascenseur.c,870 :: 		for (i = 0; i < nb_et; i++) {
	CLRF        deplacer_vers_i_L0+0 
L_deplacer_vers267:
	MOVF        deplacer_vers_nb_et_L0+0, 0 
	SUBWF       deplacer_vers_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers268
;Ascenseur.c,871 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers528
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers528
	GOTO        L_deplacer_vers272
L__deplacer_vers528:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers272:
;Ascenseur.c,873 :: 		est_dernier = (i == nb_et - 1);
	DECF        deplacer_vers_nb_et_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers607
	MOVF        R0, 0 
	XORWF       deplacer_vers_i_L0+0, 0 
L__deplacer_vers607:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       deplacer_vers_est_dernier_L0+0 
;Ascenseur.c,874 :: 		set_pwm(pwm_max_eff);
	MOVF        _pwm_max_eff+0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,876 :: 		if (!est_dernier) {
	MOVF        deplacer_vers_est_dernier_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers273
;Ascenseur.c,877 :: 		entre_etages = 1;
	MOVLW       1
	MOVWF       _entre_etages+0 
;Ascenseur.c,878 :: 		attendre_ms(MS_CROISIERE);
	MOVLW       244
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,879 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers527
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers527
	GOTO        L_deplacer_vers276
L__deplacer_vers527:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers276:
;Ascenseur.c,880 :: 		entre_etages = 0;
	CLRF        _entre_etages+0 
;Ascenseur.c,882 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers277
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers278
L_deplacer_vers277:
;Ascenseur.c,883 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers278:
;Ascenseur.c,885 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,886 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,887 :: 		lcd_update_transit();
	CALL        _lcd_update_transit+0, 0
;Ascenseur.c,888 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,890 :: 		if (req[etage_actuel]) {
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
	GOTO        L_deplacer_vers279
;Ascenseur.c,891 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,892 :: 		rampe_decel();
	CALL        _rampe_decel+0, 0
;Ascenseur.c,893 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers526
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers526
	GOTO        L_deplacer_vers282
L__deplacer_vers526:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers282:
;Ascenseur.c,895 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,896 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,897 :: 		etage_cible = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,898 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,899 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,900 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,901 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,903 :: 		attendre_ms(MS_ARRET_INTERMED);
	MOVLW       244
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,904 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers525
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers525
	GOTO        L_deplacer_vers285
L__deplacer_vers525:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers285:
;Ascenseur.c,906 :: 		direction = sens;
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,907 :: 		etage_cible = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,908 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,909 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,910 :: 		attendre_ms(MS_FERMETURE);
	MOVLW       50
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       0
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,911 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers524
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers524
	GOTO        L_deplacer_vers288
L__deplacer_vers524:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers288:
;Ascenseur.c,912 :: 		demarrer_moteur(sens);
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       FARG_demarrer_moteur_sens+0 
	CALL        _demarrer_moteur+0, 0
;Ascenseur.c,913 :: 		lcd_update_transit();
	CALL        _lcd_update_transit+0, 0
;Ascenseur.c,914 :: 		}
L_deplacer_vers279:
;Ascenseur.c,916 :: 		} else {
	GOTO        L_deplacer_vers289
L_deplacer_vers273:
;Ascenseur.c,917 :: 		entre_etages = 1;
	MOVLW       1
	MOVWF       _entre_etages+0 
;Ascenseur.c,918 :: 		if (nb_et == 1) attendre_ms(MS_CROISIERE_1ET);
	MOVF        deplacer_vers_nb_et_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers290
	MOVLW       124
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
	GOTO        L_deplacer_vers291
L_deplacer_vers290:
;Ascenseur.c,919 :: 		else            attendre_ms(MS_CROISIERE);
	MOVLW       244
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
L_deplacer_vers291:
;Ascenseur.c,921 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers523
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers523
	GOTO        L_deplacer_vers294
L__deplacer_vers523:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers294:
;Ascenseur.c,922 :: 		entre_etages = 0;
	CLRF        _entre_etages+0 
;Ascenseur.c,924 :: 		rampe_decel();
	CALL        _rampe_decel+0, 0
;Ascenseur.c,925 :: 		if (urgence_flag || stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers522
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers522
	GOTO        L_deplacer_vers297
L__deplacer_vers522:
;Ascenseur.c,926 :: 		position_inconnue = 1;
	MOVLW       1
	MOVWF       _position_inconnue+0 
;Ascenseur.c,927 :: 		goto fin_deplacement;
	GOTO        ___deplacer_vers_fin_deplacement
;Ascenseur.c,928 :: 		}
L_deplacer_vers297:
;Ascenseur.c,930 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers298
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers299
L_deplacer_vers298:
;Ascenseur.c,931 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers299:
;Ascenseur.c,932 :: 		}
L_deplacer_vers289:
;Ascenseur.c,870 :: 		for (i = 0; i < nb_et; i++) {
	INCF        deplacer_vers_i_L0+0, 1 
;Ascenseur.c,933 :: 		}
	GOTO        L_deplacer_vers267
L_deplacer_vers268:
;Ascenseur.c,935 :: 		fin_deplacement:
___deplacer_vers_fin_deplacement:
;Ascenseur.c,936 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,938 :: 		if ((urgence_flag || stop_demande) && entre_etages) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers521
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers521
	GOTO        L_deplacer_vers307
L__deplacer_vers521:
	MOVF        _entre_etages+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_deplacer_vers307
L__deplacer_vers520:
;Ascenseur.c,939 :: 		position_inconnue = 1;
	MOVLW       1
	MOVWF       _position_inconnue+0 
;Ascenseur.c,940 :: 		entre_etages = 0;
	CLRF        _entre_etages+0 
;Ascenseur.c,941 :: 		}
L_deplacer_vers307:
;Ascenseur.c,943 :: 		temps_trajet = timer0_count - temps_debut;
	MOVF        deplacer_vers_temps_debut_L0+0, 0 
	SUBWF       _timer0_count+0, 0 
	MOVWF       _temps_trajet+0 
	MOVF        deplacer_vers_temps_debut_L0+1, 0 
	SUBWFB      _timer0_count+1, 0 
	MOVWF       _temps_trajet+1 
;Ascenseur.c,944 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,945 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,946 :: 		etage_cible = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,947 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,949 :: 		if (!urgence_flag && !stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers310
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers310
L__deplacer_vers519:
;Ascenseur.c,950 :: 		position_inconnue = 0;
	CLRF        _position_inconnue+0 
;Ascenseur.c,951 :: 		}
L_deplacer_vers310:
;Ascenseur.c,953 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,954 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,955 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,956 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,958 :: 		if (!urgence_flag && !stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers313
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers313
L__deplacer_vers518:
;Ascenseur.c,959 :: 		eeprom_sauver_trajet();
	CALL        _eeprom_sauver_trajet+0, 0
;Ascenseur.c,960 :: 		attendre_ms(MS_OUVERTURE);
	MOVLW       100
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       0
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,961 :: 		}
L_deplacer_vers313:
;Ascenseur.c,963 :: 		stop_demande = 0;
	CLRF        _stop_demande+0 
;Ascenseur.c,964 :: 		}
L_end_deplacer_vers:
	RETURN      0
; end of _deplacer_vers

_parser_cmd:

;Ascenseur.c,967 :: 		void parser_cmd(char *buf) {
;Ascenseur.c,973 :: 		p = strstr(buf, "CALL:");
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr23_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr23_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       parser_cmd_p_L0+0 
	MOVF        R1, 0 
	MOVWF       parser_cmd_p_L0+1 
;Ascenseur.c,974 :: 		if (p) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd314
;Ascenseur.c,975 :: 		cible = (unsigned char)(*(p + 5) - '0');
	MOVLW       5
	ADDWF       parser_cmd_p_L0+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      parser_cmd_p_L0+1, 0 
	MOVWF       FSR0L+1 
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       parser_cmd_cible_L0+0 
;Ascenseur.c,976 :: 		if (cible < NB_ETAGES && mode_auto && !al_active && !surcharge_active) {
	MOVLW       4
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd317
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd317
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd317
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd317
L__parser_cmd542:
;Ascenseur.c,977 :: 		req[cible] = 1;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        parser_cmd_cible_L0+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
;Ascenseur.c,978 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,979 :: 		} else {
	GOTO        L_parser_cmd318
L_parser_cmd317:
;Ascenseur.c,980 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,981 :: 		}
L_parser_cmd318:
;Ascenseur.c,982 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,983 :: 		}
L_parser_cmd314:
;Ascenseur.c,985 :: 		if (strstr(buf, "CMD,STOP")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr24_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr24_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd319
;Ascenseur.c,986 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,987 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,988 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,989 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,990 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,991 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,992 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,993 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,994 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,995 :: 		}
L_parser_cmd319:
;Ascenseur.c,997 :: 		if (strstr(buf, "CMD,ACK")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr25_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr25_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd323
;Ascenseur.c,998 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_parser_cmd324
;Ascenseur.c,999 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1000 :: 		} else if (urg_active) {
	GOTO        L_parser_cmd325
L_parser_cmd324:
	MOVF        _urg_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd326
;Ascenseur.c,1001 :: 		urg_active = 0;
	CLRF        _urg_active+0 
;Ascenseur.c,1002 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1003 :: 		urgence_flag = 0;
	CLRF        _urgence_flag+0 
;Ascenseur.c,1004 :: 		position_inconnue = 0;
	CLRF        _position_inconnue+0 
;Ascenseur.c,1005 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1006 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1007 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1008 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1009 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1010 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1011 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1012 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1013 :: 		} else if (surcharge_active) {
	GOTO        L_parser_cmd327
L_parser_cmd326:
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd328
;Ascenseur.c,1014 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1015 :: 		} else {
	GOTO        L_parser_cmd329
L_parser_cmd328:
;Ascenseur.c,1016 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1017 :: 		}
L_parser_cmd329:
L_parser_cmd327:
L_parser_cmd325:
;Ascenseur.c,1018 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1019 :: 		}
L_parser_cmd323:
;Ascenseur.c,1021 :: 		if (strstr(buf, "MODE:AUTO")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr26_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr26_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd330
;Ascenseur.c,1022 :: 		mode_auto = 1;
	MOVLW       1
	MOVWF       _mode_auto+0 
;Ascenseur.c,1023 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1024 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1025 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1026 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1027 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1028 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1029 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1030 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1031 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1032 :: 		}
L_parser_cmd330:
;Ascenseur.c,1034 :: 		if (strstr(buf, "MODE:MAN")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr27_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr27_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd331
;Ascenseur.c,1035 :: 		mode_auto = 0;
	CLRF        _mode_auto+0 
;Ascenseur.c,1036 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1037 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1038 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1039 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1040 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1041 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1042 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1043 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1044 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1045 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1046 :: 		}
L_parser_cmd331:
;Ascenseur.c,1048 :: 		if (strstr(buf, "GET:EEP")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr28_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr28_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd335
;Ascenseur.c,1049 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,1050 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1051 :: 		}
L_parser_cmd335:
;Ascenseur.c,1053 :: 		if (strstr(buf, "EEP:RST") || strstr(buf, "RST:EEP")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr29_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr29_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd541
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr30_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr30_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd541
	GOTO        L_parser_cmd338
L__parser_cmd541:
;Ascenseur.c,1054 :: 		eeprom_reset();
	CALL        _eeprom_reset+0, 0
;Ascenseur.c,1055 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1056 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,1057 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1058 :: 		}
L_parser_cmd338:
;Ascenseur.c,1061 :: 		char *pP = strstr(buf, "PMAX:");
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr31_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr31_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       parser_cmd_pP_L1+0 
	MOVF        R1, 0 
	MOVWF       parser_cmd_pP_L1+1 
;Ascenseur.c,1062 :: 		char *pS = strstr(buf, "SPD:");
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr32_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr32_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       parser_cmd_pS_L1+0 
	MOVF        R1, 0 
	MOVWF       parser_cmd_pS_L1+1 
;Ascenseur.c,1063 :: 		if (pP && pS) {
	MOVF        parser_cmd_pP_L1+0, 0 
	IORWF       parser_cmd_pP_L1+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd341
	MOVF        parser_cmd_pS_L1+0, 0 
	IORWF       parser_cmd_pS_L1+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd341
L__parser_cmd540:
;Ascenseur.c,1064 :: 		pv = 0;
	CLRF        parser_cmd_pv_L0+0 
	CLRF        parser_cmd_pv_L0+1 
;Ascenseur.c,1065 :: 		pP += 5;
	MOVLW       5
	ADDWF       parser_cmd_pP_L1+0, 1 
	MOVLW       0
	ADDWFC      parser_cmd_pP_L1+1, 1 
;Ascenseur.c,1066 :: 		while (*pP >= '0' && *pP <= '9') {
L_parser_cmd342:
	MOVFF       parser_cmd_pP_L1+0, FSR0L+0
	MOVFF       parser_cmd_pP_L1+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd343
	MOVFF       parser_cmd_pP_L1+0, FSR0L+0
	MOVFF       parser_cmd_pP_L1+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd343
L__parser_cmd539:
;Ascenseur.c,1067 :: 		pv = pv * 10 + (unsigned int)(*pP - '0');
	MOVF        parser_cmd_pv_L0+0, 0 
	MOVWF       R0 
	MOVF        parser_cmd_pv_L0+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVFF       parser_cmd_pP_L1+0, FSR0L+0
	MOVFF       parser_cmd_pP_L1+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       parser_cmd_pv_L0+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       parser_cmd_pv_L0+1 
;Ascenseur.c,1068 :: 		pP++;
	INFSNZ      parser_cmd_pP_L1+0, 1 
	INCF        parser_cmd_pP_L1+1, 1 
;Ascenseur.c,1069 :: 		}
	GOTO        L_parser_cmd342
L_parser_cmd343:
;Ascenseur.c,1070 :: 		sv = 0;
	CLRF        parser_cmd_sv_L0+0 
;Ascenseur.c,1071 :: 		pS += 4;
	MOVLW       4
	ADDWF       parser_cmd_pS_L1+0, 1 
	MOVLW       0
	ADDWFC      parser_cmd_pS_L1+1, 1 
;Ascenseur.c,1072 :: 		while (*pS >= '0' && *pS <= '9') {
L_parser_cmd346:
	MOVFF       parser_cmd_pS_L1+0, FSR0L+0
	MOVFF       parser_cmd_pS_L1+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd347
	MOVFF       parser_cmd_pS_L1+0, FSR0L+0
	MOVFF       parser_cmd_pS_L1+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd347
L__parser_cmd538:
;Ascenseur.c,1073 :: 		sv = sv * 10 + (unsigned char)(*pS - '0');
	MOVLW       10
	MULWF       parser_cmd_sv_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       parser_cmd_sv_L0+0 
	MOVFF       parser_cmd_pS_L1+0, FSR0L+0
	MOVFF       parser_cmd_pS_L1+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       parser_cmd_sv_L0+0, 1 
;Ascenseur.c,1074 :: 		pS++;
	INFSNZ      parser_cmd_pS_L1+0, 1 
	INCF        parser_cmd_pS_L1+1, 1 
;Ascenseur.c,1075 :: 		}
	GOTO        L_parser_cmd346
L_parser_cmd347:
;Ascenseur.c,1077 :: 		if (pv < 1)   pv = 1;
	MOVLW       0
	SUBWF       parser_cmd_pv_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd609
	MOVLW       1
	SUBWF       parser_cmd_pv_L0+0, 0 
L__parser_cmd609:
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd350
	MOVLW       1
	MOVWF       parser_cmd_pv_L0+0 
	MOVLW       0
	MOVWF       parser_cmd_pv_L0+1 
L_parser_cmd350:
;Ascenseur.c,1078 :: 		if (pv > 999) pv = 999;
	MOVF        parser_cmd_pv_L0+1, 0 
	SUBLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd610
	MOVF        parser_cmd_pv_L0+0, 0 
	SUBLW       231
L__parser_cmd610:
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd351
	MOVLW       231
	MOVWF       parser_cmd_pv_L0+0 
	MOVLW       3
	MOVWF       parser_cmd_pv_L0+1 
L_parser_cmd351:
;Ascenseur.c,1079 :: 		poids_max   = pv;
	MOVF        parser_cmd_pv_L0+0, 0 
	MOVWF       _poids_max+0 
	MOVF        parser_cmd_pv_L0+1, 0 
	MOVWF       _poids_max+1 
;Ascenseur.c,1080 :: 		seuil_surge = pv;
	MOVF        parser_cmd_pv_L0+0, 0 
	MOVWF       _seuil_surge+0 
	MOVF        parser_cmd_pv_L0+1, 0 
	MOVWF       _seuil_surge+1 
;Ascenseur.c,1082 :: 		if (sv > 100) sv = 100;
	MOVF        parser_cmd_sv_L0+0, 0 
	SUBLW       100
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd352
	MOVLW       100
	MOVWF       parser_cmd_sv_L0+0 
L_parser_cmd352:
;Ascenseur.c,1083 :: 		if (sv < 10)  sv = 10;
	MOVLW       10
	SUBWF       parser_cmd_sv_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd353
	MOVLW       10
	MOVWF       parser_cmd_sv_L0+0 
L_parser_cmd353:
;Ascenseur.c,1084 :: 		vitesse_max_pc = sv;
	MOVF        parser_cmd_sv_L0+0, 0 
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,1085 :: 		vitesse_eeprom = sv;
	MOVF        parser_cmd_sv_L0+0, 0 
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,1086 :: 		recalc_pwm_max();
	CALL        _recalc_pwm_max+0, 0
;Ascenseur.c,1087 :: 		eep_write_byte(0x03, vitesse_eeprom);
	MOVLW       3
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        _vitesse_eeprom+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,1088 :: 		if (moteur_actif) set_pwm(pwm_max_eff);
	MOVF        _moteur_actif+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd354
	MOVF        _pwm_max_eff+0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
L_parser_cmd354:
;Ascenseur.c,1090 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1091 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1092 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1093 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1094 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1095 :: 		}
L_parser_cmd341:
;Ascenseur.c,1098 :: 		p = strstr(buf, "PMAX:");
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr33_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr33_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       parser_cmd_p_L0+0 
	MOVF        R1, 0 
	MOVWF       parser_cmd_p_L0+1 
;Ascenseur.c,1099 :: 		if (p) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd355
;Ascenseur.c,1100 :: 		pv = 0;
	CLRF        parser_cmd_pv_L0+0 
	CLRF        parser_cmd_pv_L0+1 
;Ascenseur.c,1101 :: 		p += 5;
	MOVLW       5
	ADDWF       parser_cmd_p_L0+0, 1 
	MOVLW       0
	ADDWFC      parser_cmd_p_L0+1, 1 
;Ascenseur.c,1102 :: 		while (*p >= '0' && *p <= '9') {
L_parser_cmd356:
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd357
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd357
L__parser_cmd537:
;Ascenseur.c,1103 :: 		pv = pv * 10 + (unsigned int)(*p - '0');
	MOVF        parser_cmd_pv_L0+0, 0 
	MOVWF       R0 
	MOVF        parser_cmd_pv_L0+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       parser_cmd_pv_L0+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       parser_cmd_pv_L0+1 
;Ascenseur.c,1104 :: 		p++;
	INFSNZ      parser_cmd_p_L0+0, 1 
	INCF        parser_cmd_p_L0+1, 1 
;Ascenseur.c,1105 :: 		}
	GOTO        L_parser_cmd356
L_parser_cmd357:
;Ascenseur.c,1106 :: 		appliquer_pmax(pv);
	MOVF        parser_cmd_pv_L0+0, 0 
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVF        parser_cmd_pv_L0+1, 0 
	MOVWF       FARG_appliquer_pmax_val+1 
	CALL        _appliquer_pmax+0, 0
;Ascenseur.c,1107 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1108 :: 		}
L_parser_cmd355:
;Ascenseur.c,1110 :: 		p = strstr(buf, "SPD:");
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr34_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr34_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       parser_cmd_p_L0+0 
	MOVF        R1, 0 
	MOVWF       parser_cmd_p_L0+1 
;Ascenseur.c,1111 :: 		if (p) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd360
;Ascenseur.c,1112 :: 		sv = 0;
	CLRF        parser_cmd_sv_L0+0 
;Ascenseur.c,1113 :: 		p += 4;
	MOVLW       4
	ADDWF       parser_cmd_p_L0+0, 1 
	MOVLW       0
	ADDWFC      parser_cmd_p_L0+1, 1 
;Ascenseur.c,1114 :: 		while (*p >= '0' && *p <= '9') {
L_parser_cmd361:
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd362
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd362
L__parser_cmd536:
;Ascenseur.c,1115 :: 		sv = sv * 10 + (unsigned char)(*p - '0');
	MOVLW       10
	MULWF       parser_cmd_sv_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       parser_cmd_sv_L0+0 
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       parser_cmd_sv_L0+0, 1 
;Ascenseur.c,1116 :: 		p++;
	INFSNZ      parser_cmd_p_L0+0, 1 
	INCF        parser_cmd_p_L0+1, 1 
;Ascenseur.c,1117 :: 		}
	GOTO        L_parser_cmd361
L_parser_cmd362:
;Ascenseur.c,1118 :: 		appliquer_spd(sv);
	MOVF        parser_cmd_sv_L0+0, 0 
	MOVWF       FARG_appliquer_spd_val+0 
	CALL        _appliquer_spd+0, 0
;Ascenseur.c,1119 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1120 :: 		}
L_parser_cmd360:
;Ascenseur.c,1122 :: 		if (strstr(buf, "DOOR:O")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr35_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr35_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd365
;Ascenseur.c,1123 :: 		if (!mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd366
;Ascenseur.c,1124 :: 		porte_cmd = 1;
	MOVLW       1
	MOVWF       _porte_cmd+0 
;Ascenseur.c,1125 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,1126 :: 		if (!moteur_actif) lcd_transition();
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd367
	CALL        _lcd_transition+0, 0
L_parser_cmd367:
;Ascenseur.c,1127 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1128 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1129 :: 		} else {
	GOTO        L_parser_cmd368
L_parser_cmd366:
;Ascenseur.c,1130 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1131 :: 		}
L_parser_cmd368:
;Ascenseur.c,1132 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1133 :: 		}
L_parser_cmd365:
;Ascenseur.c,1135 :: 		if (strstr(buf, "DOOR:F")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr36_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr36_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd369
;Ascenseur.c,1136 :: 		if (!mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd370
;Ascenseur.c,1137 :: 		porte_cmd = 0;
	CLRF        _porte_cmd+0 
;Ascenseur.c,1138 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,1139 :: 		if (!moteur_actif) lcd_transition();
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd371
	CALL        _lcd_transition+0, 0
L_parser_cmd371:
;Ascenseur.c,1140 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1141 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1142 :: 		} else {
	GOTO        L_parser_cmd372
L_parser_cmd370:
;Ascenseur.c,1143 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1144 :: 		}
L_parser_cmd372:
;Ascenseur.c,1145 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1146 :: 		}
L_parser_cmd369:
;Ascenseur.c,1148 :: 		if (strstr(buf, "MOT:UP")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr37_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr37_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd373
;Ascenseur.c,1149 :: 		if (!mode_auto && !urg_active && !al_active && !surcharge_active) {
	MOVF        _mode_auto+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd376
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd376
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd376
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd376
L__parser_cmd535:
;Ascenseur.c,1150 :: 		if (moteur_actif || en_mouvement) {
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd534
	MOVF        _en_mouvement+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd534
	GOTO        L_parser_cmd379
L__parser_cmd534:
;Ascenseur.c,1151 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1152 :: 		} else if (etage_actuel >= NB_ETAGES - 1) {
	GOTO        L_parser_cmd380
L_parser_cmd379:
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd611
	MOVLW       3
	SUBWF       _etage_actuel+0, 0 
L__parser_cmd611:
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd381
;Ascenseur.c,1153 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1154 :: 		} else {
	GOTO        L_parser_cmd382
L_parser_cmd381:
;Ascenseur.c,1155 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1156 :: 		deplacer_vers(etage_actuel + 1);
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,1157 :: 		}
L_parser_cmd382:
L_parser_cmd380:
;Ascenseur.c,1158 :: 		} else {
	GOTO        L_parser_cmd383
L_parser_cmd376:
;Ascenseur.c,1159 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1160 :: 		}
L_parser_cmd383:
;Ascenseur.c,1161 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1162 :: 		}
L_parser_cmd373:
;Ascenseur.c,1164 :: 		if (strstr(buf, "MOT:DWN")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr38_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr38_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd384
;Ascenseur.c,1165 :: 		if (!mode_auto && !urg_active && !al_active && !surcharge_active) {
	MOVF        _mode_auto+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd387
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd387
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd387
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd387
L__parser_cmd533:
;Ascenseur.c,1166 :: 		if (moteur_actif || en_mouvement) {
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd532
	MOVF        _en_mouvement+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd532
	GOTO        L_parser_cmd390
L__parser_cmd532:
;Ascenseur.c,1167 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1168 :: 		} else if (etage_actuel == 0) {
	GOTO        L_parser_cmd391
L_parser_cmd390:
	MOVF        _etage_actuel+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd392
;Ascenseur.c,1169 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1170 :: 		} else {
	GOTO        L_parser_cmd393
L_parser_cmd392:
;Ascenseur.c,1171 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1172 :: 		deplacer_vers(etage_actuel - 1);
	DECF        _etage_actuel+0, 0 
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,1173 :: 		}
L_parser_cmd393:
L_parser_cmd391:
;Ascenseur.c,1174 :: 		} else {
	GOTO        L_parser_cmd394
L_parser_cmd387:
;Ascenseur.c,1175 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1176 :: 		}
L_parser_cmd394:
;Ascenseur.c,1177 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1178 :: 		}
L_parser_cmd384:
;Ascenseur.c,1180 :: 		if (strstr(buf, "MOT:STP") || strstr(buf, "MOT:STOP")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr39_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr39_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd531
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr40_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr40_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd531
	GOTO        L_parser_cmd397
L__parser_cmd531:
;Ascenseur.c,1181 :: 		if (!mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd398
;Ascenseur.c,1182 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1183 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1184 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1185 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1186 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1187 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1188 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1189 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1190 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1191 :: 		} else {
	GOTO        L_parser_cmd402
L_parser_cmd398:
;Ascenseur.c,1192 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1193 :: 		}
L_parser_cmd402:
;Ascenseur.c,1194 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1195 :: 		}
L_parser_cmd397:
;Ascenseur.c,1197 :: 		if (strstr(buf, "AL:ON")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr41_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr41_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd403
;Ascenseur.c,1198 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,1199 :: 		al_flag = 1;
	MOVLW       1
	MOVWF       _al_flag+0 
;Ascenseur.c,1200 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1201 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1202 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1203 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1204 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1205 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1206 :: 		}
L_parser_cmd403:
;Ascenseur.c,1208 :: 		if (strstr(buf, "RST:AL")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr42_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr42_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd407
;Ascenseur.c,1209 :: 		if (!urg_active) {
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd408
;Ascenseur.c,1210 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1211 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1212 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1213 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1214 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1215 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1216 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1217 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1218 :: 		} else {
	GOTO        L_parser_cmd409
L_parser_cmd408:
;Ascenseur.c,1219 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1220 :: 		}
L_parser_cmd409:
;Ascenseur.c,1221 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1222 :: 		}
L_parser_cmd407:
;Ascenseur.c,1224 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1225 :: 		}
L_end_parser_cmd:
	RETURN      0
; end of _parser_cmd

_main:

;Ascenseur.c,1228 :: 		void main() {
;Ascenseur.c,1235 :: 		PWM1_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;Ascenseur.c,1236 :: 		PWM1_Set_Duty(0);
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,1237 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;Ascenseur.c,1240 :: 		ANSELA = 0x02;
	MOVLW       2
	MOVWF       ANSELA+0 
;Ascenseur.c,1241 :: 		TRISA0_bit = 1;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Ascenseur.c,1242 :: 		TRISA1_bit = 1;
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,1243 :: 		TRISA2_bit = 0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;Ascenseur.c,1244 :: 		TRISA3_bit = 0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;Ascenseur.c,1245 :: 		LATA2_bit = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;Ascenseur.c,1246 :: 		LATA3_bit = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1249 :: 		ANSELB = 0x00;
	CLRF        ANSELB+0 
;Ascenseur.c,1250 :: 		TRISB6_bit = 1;
	BSF         TRISB6_bit+0, BitPos(TRISB6_bit+0) 
;Ascenseur.c,1251 :: 		TRISB7_bit = 1;
	BSF         TRISB7_bit+0, BitPos(TRISB7_bit+0) 
;Ascenseur.c,1252 :: 		INTCON2.RBPU = 1;
	BSF         INTCON2+0, 7 
;Ascenseur.c,1255 :: 		ANSELC = 0x00;
	CLRF        ANSELC+0 
;Ascenseur.c,1256 :: 		TRISC0_bit = 0;
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;Ascenseur.c,1257 :: 		TRISC1_bit = 0;
	BCF         TRISC1_bit+0, BitPos(TRISC1_bit+0) 
;Ascenseur.c,1258 :: 		TRISC2_bit = 0;
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;Ascenseur.c,1259 :: 		TRISC3_bit = 0;
	BCF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;Ascenseur.c,1260 :: 		TRISC4_bit = 1;
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;Ascenseur.c,1261 :: 		TRISC6_bit = 0;
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;Ascenseur.c,1262 :: 		TRISC7_bit = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;Ascenseur.c,1263 :: 		LATC0_bit = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;Ascenseur.c,1264 :: 		LATC1_bit = 0;
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;Ascenseur.c,1267 :: 		ANSELD = 0x00;
	CLRF        ANSELD+0 
;Ascenseur.c,1268 :: 		TRISD = 0xFF;
	MOVLW       255
	MOVWF       TRISD+0 
;Ascenseur.c,1271 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;Ascenseur.c,1272 :: 		ANSELA = 0x02;
	MOVLW       2
	MOVWF       ANSELA+0 
;Ascenseur.c,1273 :: 		TRISA0_bit = 1;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Ascenseur.c,1274 :: 		TRISA1_bit = 1;
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,1277 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Ascenseur.c,1278 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main410:
	DECFSZ      R13, 1, 1
	BRA         L_main410
	DECFSZ      R12, 1, 1
	BRA         L_main410
	DECFSZ      R11, 1, 1
	BRA         L_main410
	NOP
;Ascenseur.c,1281 :: 		I2C1_Init(100000);
	MOVLW       20
	MOVWF       SSP1ADD+0 
	CALL        _I2C1_Init+0, 0
;Ascenseur.c,1282 :: 		Delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_main411:
	DECFSZ      R13, 1, 1
	BRA         L_main411
	DECFSZ      R12, 1, 1
	BRA         L_main411
	NOP
;Ascenseur.c,1285 :: 		eeprom_charger();
	CALL        _eeprom_charger+0, 0
;Ascenseur.c,1287 :: 		T0CON = 0x07;
	MOVLW       7
	MOVWF       T0CON+0 
;Ascenseur.c,1288 :: 		TMR0H = T0_RELOAD_H;
	MOVLW       225
	MOVWF       TMR0H+0 
;Ascenseur.c,1289 :: 		TMR0L = T0_RELOAD_L;
	MOVLW       124
	MOVWF       TMR0L+0 
;Ascenseur.c,1290 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Ascenseur.c,1291 :: 		TMR0IE_bit = 1;
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;Ascenseur.c,1294 :: 		RBIF_bit = 0;
	BCF         RBIF_bit+0, BitPos(RBIF_bit+0) 
;Ascenseur.c,1295 :: 		RBIE_bit = 1;
	BSF         RBIE_bit+0, BitPos(RBIE_bit+0) 
;Ascenseur.c,1298 :: 		RC1IE_bit = 1;
	BSF         RC1IE_bit+0, BitPos(RC1IE_bit+0) 
;Ascenseur.c,1299 :: 		PEIE_bit = 1;
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;Ascenseur.c,1300 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,1301 :: 		T0CON = 0x87;
	MOVLW       135
	MOVWF       T0CON+0 
;Ascenseur.c,1304 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;Ascenseur.c,1305 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1306 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1307 :: 		Lcd_Out(1, 1, " ASCENSEUR 4ET  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr43_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr43_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1308 :: 		Lcd_Out(2, 1, "  Pret  - ET:0  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr44_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr44_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1309 :: 		Delay_ms(1500);
	MOVLW       16
	MOVWF       R11, 0
	MOVLW       57
	MOVWF       R12, 0
	MOVLW       13
	MOVWF       R13, 0
L_main412:
	DECFSZ      R13, 1, 1
	BRA         L_main412
	DECFSZ      R12, 1, 1
	BRA         L_main412
	DECFSZ      R11, 1, 1
	BRA         L_main412
	NOP
	NOP
;Ascenseur.c,1310 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1312 :: 		UART1_Write_Text("<DATA,ET:0,DIR:0,PT:0,PRT:0,AL:0,URG:0,NB:0,PWM:0,TPS:0>\r\n");
	MOVLW       ?lstr45_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr45_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,1314 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1315 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1316 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1319 :: 		while (1) {
L_main413:
;Ascenseur.c,1321 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main417
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main417
L__main548:
;Ascenseur.c,1322 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main418:
	DECFSZ      R13, 1, 1
	BRA         L_main418
	DECFSZ      R12, 1, 1
	BRA         L_main418
	NOP
	NOP
;Ascenseur.c,1323 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main419
;Ascenseur.c,1324 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1325 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1326 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1327 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,1328 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1329 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,1330 :: 		}
L_main419:
;Ascenseur.c,1331 :: 		}
L_main417:
;Ascenseur.c,1334 :: 		if (urgence_flag) {
	MOVF        _urgence_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main423
;Ascenseur.c,1335 :: 		urgence_flag = 0;
	CLRF        _urgence_flag+0 
;Ascenseur.c,1336 :: 		etat_surcharge = 0;
	CLRF        _etat_surcharge+0 
;Ascenseur.c,1337 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1338 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1339 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1340 :: 		vider_req();
	CALL        _vider_req+0, 0
;Ascenseur.c,1342 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1343 :: 		Lcd_Out(1, 1, " ARRET URGENCE  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr46_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr46_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1344 :: 		if (position_inconnue) Lcd_Out(2, 1, "POS?-ACQ:BP/PC  ");
	MOVF        _position_inconnue+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main427
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr47_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr47_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_main428
L_main427:
;Ascenseur.c,1345 :: 		else                   Lcd_Out(2, 1, "ACQ : BP ou PC  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr48_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr48_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_main428:
;Ascenseur.c,1347 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1348 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1349 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1352 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L3+0 
;Ascenseur.c,1353 :: 		while (acq_recu == 0) {
L_main429:
	MOVF        main_acq_recu_L3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main430
;Ascenseur.c,1354 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main431:
	DECFSZ      R13, 1, 1
	BRA         L_main431
	DECFSZ      R12, 1, 1
	BRA         L_main431
	NOP
	NOP
;Ascenseur.c,1355 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main432
;Ascenseur.c,1356 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1357 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1358 :: 		}
L_main432:
;Ascenseur.c,1360 :: 		if (BP_ACQ && !BP_URGENCE) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main435
	BTFSC       PORTB+0, 6 
	GOTO        L_main435
L__main547:
;Ascenseur.c,1361 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main436:
	DECFSZ      R13, 1, 1
	BRA         L_main436
	DECFSZ      R12, 1, 1
	BRA         L_main436
	NOP
	NOP
;Ascenseur.c,1362 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3+0 
;Ascenseur.c,1363 :: 		}
L_main435:
;Ascenseur.c,1365 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main437
;Ascenseur.c,1366 :: 		if (strstr(cmd, "CMD,ACK") && !BP_URGENCE)
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr49_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr49_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main440
	BTFSC       PORTB+0, 6 
	GOTO        L_main440
L__main546:
;Ascenseur.c,1367 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3+0 
L_main440:
;Ascenseur.c,1368 :: 		}
L_main437:
;Ascenseur.c,1369 :: 		}
	GOTO        L_main429
L_main430:
;Ascenseur.c,1370 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main441:
	DECFSZ      R13, 1, 1
	BRA         L_main441
	DECFSZ      R12, 1, 1
	BRA         L_main441
	DECFSZ      R11, 1, 1
	BRA         L_main441
;Ascenseur.c,1373 :: 		urg_active = 0;
	CLRF        _urg_active+0 
;Ascenseur.c,1374 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1375 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1376 :: 		position_inconnue = 0;
	CLRF        _position_inconnue+0 
;Ascenseur.c,1377 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1378 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1379 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1381 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1382 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1383 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1384 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1385 :: 		}
L_main423:
;Ascenseur.c,1388 :: 		if (al_flag) {
	MOVF        _al_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main442
;Ascenseur.c,1389 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1390 :: 		vider_req();
	CALL        _vider_req+0, 0
;Ascenseur.c,1392 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1393 :: 		Lcd_Out(1, 1, "   ALARME !!!   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr50_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr50_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1394 :: 		Lcd_Out(2, 1, "ACQ : BP ou PC  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr51_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr51_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1395 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1398 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L3_L3+0 
;Ascenseur.c,1399 :: 		while (acq_recu == 0) {
L_main443:
	MOVF        main_acq_recu_L3_L3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main444
;Ascenseur.c,1400 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main445:
	DECFSZ      R13, 1, 1
	BRA         L_main445
	DECFSZ      R12, 1, 1
	BRA         L_main445
	NOP
	NOP
;Ascenseur.c,1401 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main446
;Ascenseur.c,1402 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1403 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1404 :: 		}
L_main446:
;Ascenseur.c,1405 :: 		if (BP_ACQ) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main447
;Ascenseur.c,1406 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main448:
	DECFSZ      R13, 1, 1
	BRA         L_main448
	DECFSZ      R12, 1, 1
	BRA         L_main448
	NOP
	NOP
;Ascenseur.c,1407 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3_L3+0 
;Ascenseur.c,1408 :: 		}
L_main447:
;Ascenseur.c,1409 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main449
;Ascenseur.c,1410 :: 		if (strstr(cmd, "RST:AL"))
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr52_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr52_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main450
;Ascenseur.c,1411 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3_L3+0 
L_main450:
;Ascenseur.c,1412 :: 		}
L_main449:
;Ascenseur.c,1413 :: 		}
	GOTO        L_main443
L_main444:
;Ascenseur.c,1414 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main451:
	DECFSZ      R13, 1, 1
	BRA         L_main451
	DECFSZ      R12, 1, 1
	BRA         L_main451
	DECFSZ      R11, 1, 1
	BRA         L_main451
;Ascenseur.c,1417 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1418 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1419 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1420 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1421 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1422 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1423 :: 		}
L_main442:
;Ascenseur.c,1425 :: 		if (BP_ALARME && !al_active) {
	BTFSS       PORTB+0, 7 
	GOTO        L_main454
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main454
L__main545:
;Ascenseur.c,1426 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main455:
	DECFSZ      R13, 1, 1
	BRA         L_main455
	DECFSZ      R12, 1, 1
	BRA         L_main455
	NOP
	NOP
;Ascenseur.c,1427 :: 		if (BP_ALARME) {
	BTFSS       PORTB+0, 7 
	GOTO        L_main456
;Ascenseur.c,1428 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,1429 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1430 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1431 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1432 :: 		vider_req();
	CALL        _vider_req+0, 0
;Ascenseur.c,1434 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1435 :: 		Lcd_Out(1, 1, "   ALARME !!!   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr53_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr53_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1436 :: 		Lcd_Out(2, 1, "ACQ : BP ou PC  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr54_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr54_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1437 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1440 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L4+0 
;Ascenseur.c,1441 :: 		while (acq_recu == 0) {
L_main460:
	MOVF        main_acq_recu_L4+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main461
;Ascenseur.c,1442 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main462:
	DECFSZ      R13, 1, 1
	BRA         L_main462
	DECFSZ      R12, 1, 1
	BRA         L_main462
	NOP
	NOP
;Ascenseur.c,1443 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main463
;Ascenseur.c,1444 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1445 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1446 :: 		}
L_main463:
;Ascenseur.c,1447 :: 		if (BP_ACQ) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main464
;Ascenseur.c,1448 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main465:
	DECFSZ      R13, 1, 1
	BRA         L_main465
	DECFSZ      R12, 1, 1
	BRA         L_main465
	NOP
	NOP
;Ascenseur.c,1449 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L4+0 
;Ascenseur.c,1450 :: 		}
L_main464:
;Ascenseur.c,1451 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main466
;Ascenseur.c,1452 :: 		if (strstr(cmd, "RST:AL"))
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr55_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr55_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main467
;Ascenseur.c,1453 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L4+0 
L_main467:
;Ascenseur.c,1454 :: 		}
L_main466:
;Ascenseur.c,1455 :: 		}
	GOTO        L_main460
L_main461:
;Ascenseur.c,1456 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main468:
	DECFSZ      R13, 1, 1
	BRA         L_main468
	DECFSZ      R12, 1, 1
	BRA         L_main468
	DECFSZ      R11, 1, 1
	BRA         L_main468
;Ascenseur.c,1459 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1460 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1461 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1462 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1463 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1464 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1465 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1466 :: 		}
L_main456:
;Ascenseur.c,1467 :: 		}
L_main454:
;Ascenseur.c,1469 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1470 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1472 :: 		while (pop_cmd(cmd)) {
L_main469:
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main470
;Ascenseur.c,1473 :: 		parser_cmd(cmd);
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_parser_cmd_buf+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_parser_cmd_buf+1 
	CALL        _parser_cmd+0, 0
;Ascenseur.c,1474 :: 		}
	GOTO        L_main469
L_main470:
;Ascenseur.c,1476 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,1478 :: 		if (!urg_active && !al_active) {
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main473
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main473
L__main544:
;Ascenseur.c,1479 :: 		surge_now = surcharge_active ? 1 : 0;
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main474
	MOVLW       1
	MOVWF       ?FLOC___mainT666+0 
	GOTO        L_main475
L_main474:
	CLRF        ?FLOC___mainT666+0 
L_main475:
	MOVF        ?FLOC___mainT666+0, 0 
	MOVWF       main_surge_now_L0+0 
;Ascenseur.c,1480 :: 		if (surge_now != etat_surcharge) {
	MOVF        ?FLOC___mainT666+0, 0 
	XORWF       _etat_surcharge+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main476
;Ascenseur.c,1481 :: 		etat_surcharge = surge_now;
	MOVF        main_surge_now_L0+0, 0 
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1482 :: 		if (!moteur_actif) lcd_transition();
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main477
	CALL        _lcd_transition+0, 0
L_main477:
;Ascenseur.c,1483 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1484 :: 		}
L_main476:
;Ascenseur.c,1485 :: 		}
L_main473:
;Ascenseur.c,1487 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main478
;Ascenseur.c,1488 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1489 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1490 :: 		if (moteur_actif) lcd_update_transit();
	MOVF        _moteur_actif+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main479
	CALL        _lcd_update_transit+0, 0
	GOTO        L_main480
L_main479:
;Ascenseur.c,1491 :: 		else              afficher_lcd();
	CALL        _afficher_lcd+0, 0
L_main480:
;Ascenseur.c,1492 :: 		}
L_main478:
;Ascenseur.c,1495 :: 		if (mode_auto && !urg_active && !al_active && !position_inconnue) {
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main483
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main483
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main483
	MOVF        _position_inconnue+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main483
L__main543:
;Ascenseur.c,1496 :: 		if (!surcharge_active) {
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main484
;Ascenseur.c,1497 :: 		scanner_req();
	CALL        _scanner_req+0, 0
;Ascenseur.c,1498 :: 		prochain = prochain_req();
	CALL        _prochain_req+0, 0
	MOVF        R0, 0 
	MOVWF       main_prochain_L0+0 
;Ascenseur.c,1500 :: 		if (prochain != 0xFF) {
	MOVF        R0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_main485
;Ascenseur.c,1501 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1502 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1504 :: 		if (ir_porte == 1) {
	MOVF        _ir_porte+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main486
;Ascenseur.c,1505 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1506 :: 		Lcd_Out(1, 1, "PORTE OUVERTE!  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr56_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr56_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1507 :: 		Lcd_Out(2, 1, "Veuillez fermer ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr57_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr57_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1508 :: 		Delay_ms(2000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main487:
	DECFSZ      R13, 1, 1
	BRA         L_main487
	DECFSZ      R12, 1, 1
	BRA         L_main487
	DECFSZ      R11, 1, 1
	BRA         L_main487
	NOP
;Ascenseur.c,1509 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1510 :: 		}
	GOTO        L_main488
L_main486:
;Ascenseur.c,1511 :: 		else if (surcharge_active) {
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main489
;Ascenseur.c,1512 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1513 :: 		}
	GOTO        L_main490
L_main489:
;Ascenseur.c,1515 :: 		deplacer_vers(prochain);
	MOVF        main_prochain_L0+0, 0 
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,1516 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1517 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1518 :: 		}
L_main490:
L_main488:
;Ascenseur.c,1519 :: 		}
L_main485:
;Ascenseur.c,1520 :: 		}
L_main484:
;Ascenseur.c,1521 :: 		}
L_main483:
;Ascenseur.c,1523 :: 		if (!moteur_actif) afficher_lcd();
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main491
	CALL        _afficher_lcd+0, 0
L_main491:
;Ascenseur.c,1524 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main492:
	DECFSZ      R13, 1, 1
	BRA         L_main492
	DECFSZ      R12, 1, 1
	BRA         L_main492
	NOP
	NOP
;Ascenseur.c,1525 :: 		}
	GOTO        L_main413
;Ascenseur.c,1526 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
