
_interrupt:

;Ascenseur.c,161 :: 		void interrupt() {
;Ascenseur.c,164 :: 		if (TMR0IE_bit && TMR0IF_bit) {
	BTFSS       TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
	GOTO        L_interrupt2
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt2
L__interrupt492:
;Ascenseur.c,165 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Ascenseur.c,166 :: 		TMR0H = T0_RELOAD_H;
	MOVLW       194
	MOVWF       TMR0H+0 
;Ascenseur.c,167 :: 		TMR0L = T0_RELOAD_L;
	MOVLW       247
	MOVWF       TMR0L+0 
;Ascenseur.c,168 :: 		timer0_flag = 1;
	MOVLW       1
	MOVWF       _timer0_flag+0 
;Ascenseur.c,169 :: 		timer0_count++;
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
;Ascenseur.c,170 :: 		}
L_interrupt2:
;Ascenseur.c,172 :: 		if (TMR1IE_bit && TMR1IF_bit) {
	BTFSS       TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
	GOTO        L_interrupt5
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt5
L__interrupt491:
;Ascenseur.c,173 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Ascenseur.c,174 :: 		TMR1H = 0xFE;
	MOVLW       254
	MOVWF       TMR1H+0 
;Ascenseur.c,175 :: 		TMR1L = 0x0C;
	MOVLW       12
	MOVWF       TMR1L+0 
;Ascenseur.c,176 :: 		if (al_active) BUZZER = ~BUZZER;
	MOVF        _al_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt6
	BTG         LATC5_bit+0, BitPos(LATC5_bit+0) 
	GOTO        L_interrupt7
L_interrupt6:
;Ascenseur.c,177 :: 		else           BUZZER = 0;
	BCF         LATC5_bit+0, BitPos(LATC5_bit+0) 
L_interrupt7:
;Ascenseur.c,178 :: 		}
L_interrupt5:
;Ascenseur.c,180 :: 		if (RC1IE_bit && RC1IF_bit) {
	BTFSS       RC1IE_bit+0, BitPos(RC1IE_bit+0) 
	GOTO        L_interrupt10
	BTFSS       RC1IF_bit+0, BitPos(RC1IF_bit+0) 
	GOTO        L_interrupt10
L__interrupt490:
;Ascenseur.c,185 :: 		if (OERR1_bit) {
	BTFSS       OERR1_bit+0, BitPos(OERR1_bit+0) 
	GOTO        L_interrupt11
;Ascenseur.c,186 :: 		CREN1_bit = 0;
	BCF         CREN1_bit+0, BitPos(CREN1_bit+0) 
;Ascenseur.c,187 :: 		CREN1_bit = 1;
	BSF         CREN1_bit+0, BitPos(CREN1_bit+0) 
;Ascenseur.c,188 :: 		}
L_interrupt11:
;Ascenseur.c,190 :: 		c = RCREG1;
	MOVF        RCREG1+0, 0 
	MOVWF       interrupt_c_L0+0 
;Ascenseur.c,192 :: 		if (c == '<') {
	MOVF        interrupt_c_L0+0, 0 
	XORLW       60
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt12
;Ascenseur.c,193 :: 		rx_idx = 0;
	CLRF        _rx_idx+0 
;Ascenseur.c,194 :: 		}
L_interrupt12:
;Ascenseur.c,196 :: 		if (rx_idx < 48) {
	MOVLW       48
	SUBWF       _rx_idx+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt13
;Ascenseur.c,197 :: 		rx_buf[rx_idx++] = c;
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
;Ascenseur.c,198 :: 		}
L_interrupt13:
;Ascenseur.c,200 :: 		if (c == '>') {
	MOVF        interrupt_c_L0+0, 0 
	XORLW       62
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
;Ascenseur.c,201 :: 		if (rx_idx >= 5 && rx_buf[0] == '<') {
	MOVLW       5
	SUBWF       _rx_idx+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt17
	MOVF        _rx_buf+0, 0 
	XORLW       60
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt17
L__interrupt489:
;Ascenseur.c,202 :: 		nxt = (unsigned char)((cmd_qtail + 1) & (CMD_QSIZE - 1));
	MOVF        _cmd_qtail+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVLW       3
	ANDWF       R0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       interrupt_nxt_L1+0 
;Ascenseur.c,203 :: 		if (nxt != cmd_qhead) {
	MOVF        R1, 0 
	XORWF       _cmd_qhead+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt18
;Ascenseur.c,204 :: 		n = rx_idx;
	MOVF        _rx_idx+0, 0 
	MOVWF       interrupt_n_L1+0 
;Ascenseur.c,205 :: 		if (n > (CMD_QLEN - 2)) n = CMD_QLEN - 2;
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt545
	MOVF        interrupt_n_L1+0, 0 
	SUBLW       38
L__interrupt545:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt19
	MOVLW       38
	MOVWF       interrupt_n_L1+0 
L_interrupt19:
;Ascenseur.c,206 :: 		for (j = 0; j < n; j++)
	CLRF        interrupt_j_L1+0 
L_interrupt20:
	MOVF        interrupt_n_L1+0, 0 
	SUBWF       interrupt_j_L1+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt21
;Ascenseur.c,207 :: 		cmd_queue[cmd_qtail][j] = rx_buf[j];
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
;Ascenseur.c,206 :: 		for (j = 0; j < n; j++)
	INCF        interrupt_j_L1+0, 1 
;Ascenseur.c,207 :: 		cmd_queue[cmd_qtail][j] = rx_buf[j];
	GOTO        L_interrupt20
L_interrupt21:
;Ascenseur.c,208 :: 		cmd_queue[cmd_qtail][n] = '\0';
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
;Ascenseur.c,209 :: 		cmd_qtail = nxt;
	MOVF        interrupt_nxt_L1+0, 0 
	MOVWF       _cmd_qtail+0 
;Ascenseur.c,210 :: 		}
L_interrupt18:
;Ascenseur.c,211 :: 		}
L_interrupt17:
;Ascenseur.c,212 :: 		rx_idx = 0;
	CLRF        _rx_idx+0 
;Ascenseur.c,213 :: 		}
L_interrupt14:
;Ascenseur.c,214 :: 		}
L_interrupt10:
;Ascenseur.c,215 :: 		}
L_end_interrupt:
L__interrupt544:
	RETFIE      1
; end of _interrupt

_eep_write_byte:

;Ascenseur.c,217 :: 		void eep_write_byte(unsigned char addr, unsigned char val) {
;Ascenseur.c,218 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Ascenseur.c,219 :: 		I2C1_Wr(EEPROM_W);
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,220 :: 		I2C1_Wr(addr);
	MOVF        FARG_eep_write_byte_addr+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,221 :: 		I2C1_Wr(val);
	MOVF        FARG_eep_write_byte_val+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,222 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Ascenseur.c,223 :: 		Delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_eep_write_byte23:
	DECFSZ      R13, 1, 1
	BRA         L_eep_write_byte23
	DECFSZ      R12, 1, 1
	BRA         L_eep_write_byte23
	NOP
;Ascenseur.c,224 :: 		}
L_end_eep_write_byte:
	RETURN      0
; end of _eep_write_byte

_eep_read_byte:

;Ascenseur.c,226 :: 		unsigned char eep_read_byte(unsigned char addr) {
;Ascenseur.c,228 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Ascenseur.c,229 :: 		I2C1_Wr(EEPROM_W);
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,230 :: 		I2C1_Wr(addr);
	MOVF        FARG_eep_read_byte_addr+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,231 :: 		I2C1_Repeated_Start();
	CALL        _I2C1_Repeated_Start+0, 0
;Ascenseur.c,232 :: 		I2C1_Wr(EEPROM_R);
	MOVLW       161
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,233 :: 		val = I2C1_Rd(0);
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       eep_read_byte_val_L0+0 
;Ascenseur.c,234 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Ascenseur.c,235 :: 		return val;
	MOVF        eep_read_byte_val_L0+0, 0 
	MOVWF       R0 
;Ascenseur.c,236 :: 		}
L_end_eep_read_byte:
	RETURN      0
; end of _eep_read_byte

_eep_write_word:

;Ascenseur.c,238 :: 		void eep_write_word(unsigned char addr, unsigned int val) {
;Ascenseur.c,239 :: 		eep_write_byte(addr,     (unsigned char)(val >> 8));
	MOVF        FARG_eep_write_word_addr+0, 0 
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        FARG_eep_write_word_val+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,240 :: 		eep_write_byte(addr + 1, (unsigned char)(val & 0xFF));
	MOVF        FARG_eep_write_word_addr+0, 0 
	ADDLW       1
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVLW       255
	ANDWF       FARG_eep_write_word_val+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,241 :: 		}
L_end_eep_write_word:
	RETURN      0
; end of _eep_write_word

_eep_read_word:

;Ascenseur.c,243 :: 		unsigned int eep_read_word(unsigned char addr) {
;Ascenseur.c,244 :: 		unsigned int hi = (unsigned int)eep_read_byte(addr);
	MOVF        FARG_eep_read_word_addr+0, 0 
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       eep_read_word_hi_L0+0 
	MOVLW       0
	MOVWF       eep_read_word_hi_L0+1 
;Ascenseur.c,245 :: 		unsigned int lo = (unsigned int)eep_read_byte(addr + 1);
	MOVF        FARG_eep_read_word_addr+0, 0 
	ADDLW       1
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
;Ascenseur.c,246 :: 		return (hi << 8) | lo;
	MOVF        eep_read_word_hi_L0+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R3, 0 
	IORWF       R0, 1 
	MOVF        R4, 0 
	IORWF       R1, 1 
;Ascenseur.c,247 :: 		}
L_end_eep_read_word:
	RETURN      0
; end of _eep_read_word

_recalc_pwm_max:

;Ascenseur.c,249 :: 		void recalc_pwm_max() {
;Ascenseur.c,250 :: 		pwm_max_eff = (unsigned char)((unsigned int)vitesse_max_pc * 255 / 100);
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
;Ascenseur.c,251 :: 		if (pwm_max_eff < (unsigned char)(PWM_MIN + 20))
	MOVLW       100
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_recalc_pwm_max24
;Ascenseur.c,252 :: 		pwm_max_eff = (unsigned char)(PWM_MIN + 20);
	MOVLW       100
	MOVWF       _pwm_max_eff+0 
L_recalc_pwm_max24:
;Ascenseur.c,253 :: 		}
L_end_recalc_pwm_max:
	RETURN      0
; end of _recalc_pwm_max

_pop_cmd:

;Ascenseur.c,255 :: 		unsigned char pop_cmd(char *dest) {
;Ascenseur.c,257 :: 		if (cmd_qhead == cmd_qtail) return 0;
	MOVF        _cmd_qhead+0, 0 
	XORWF       _cmd_qtail+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_pop_cmd25
	CLRF        R0 
	GOTO        L_end_pop_cmd
L_pop_cmd25:
;Ascenseur.c,258 :: 		GIE_bit = 0;
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,259 :: 		for (i = 0; i < (CMD_QLEN - 1); i++)
	CLRF        pop_cmd_i_L0+0 
L_pop_cmd26:
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pop_cmd552
	MOVLW       39
	SUBWF       pop_cmd_i_L0+0, 0 
L__pop_cmd552:
	BTFSC       STATUS+0, 0 
	GOTO        L_pop_cmd27
;Ascenseur.c,260 :: 		dest[i] = cmd_queue[cmd_qhead][i];
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
;Ascenseur.c,259 :: 		for (i = 0; i < (CMD_QLEN - 1); i++)
	INCF        pop_cmd_i_L0+0, 1 
;Ascenseur.c,260 :: 		dest[i] = cmd_queue[cmd_qhead][i];
	GOTO        L_pop_cmd26
L_pop_cmd27:
;Ascenseur.c,261 :: 		dest[CMD_QLEN - 1] = '\0';
	MOVLW       39
	ADDWF       FARG_pop_cmd_dest+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_pop_cmd_dest+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;Ascenseur.c,262 :: 		cmd_qhead = (unsigned char)((cmd_qhead + 1) & (CMD_QSIZE - 1));
	MOVF        _cmd_qhead+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVLW       3
	ANDWF       R0, 0 
	MOVWF       _cmd_qhead+0 
;Ascenseur.c,263 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,264 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
;Ascenseur.c,265 :: 		}
L_end_pop_cmd:
	RETURN      0
; end of _pop_cmd

_eeprom_charger:

;Ascenseur.c,267 :: 		void eeprom_charger() {
;Ascenseur.c,271 :: 		stored_traj = eep_read_word(0x00);
	CLRF        FARG_eep_read_word_addr+0 
	CALL        _eep_read_word+0, 0
	MOVF        R0, 0 
	MOVWF       eeprom_charger_stored_traj_L0+0 
	MOVF        R1, 0 
	MOVWF       eeprom_charger_stored_traj_L0+1 
;Ascenseur.c,272 :: 		last_etage  = eep_read_byte(0x02);
	MOVLW       2
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       _last_etage+0 
;Ascenseur.c,273 :: 		stored_vit  = eep_read_byte(0x03);
	MOVLW       3
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       eeprom_charger_stored_vit_L0+0 
;Ascenseur.c,275 :: 		if (stored_traj == 0xFFFF) {
	MOVF        eeprom_charger_stored_traj_L0+1, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L__eeprom_charger554
	MOVLW       255
	XORWF       eeprom_charger_stored_traj_L0+0, 0 
L__eeprom_charger554:
	BTFSS       STATUS+0, 2 
	GOTO        L_eeprom_charger29
;Ascenseur.c,276 :: 		nb_trajets = 0;
	CLRF        _nb_trajets+0 
	CLRF        _nb_trajets+1 
;Ascenseur.c,277 :: 		eep_write_word(0x00, 0);
	CLRF        FARG_eep_write_word_addr+0 
	CLRF        FARG_eep_write_word_val+0 
	CLRF        FARG_eep_write_word_val+1 
	CALL        _eep_write_word+0, 0
;Ascenseur.c,278 :: 		} else {
	GOTO        L_eeprom_charger30
L_eeprom_charger29:
;Ascenseur.c,279 :: 		nb_trajets = stored_traj;
	MOVF        eeprom_charger_stored_traj_L0+0, 0 
	MOVWF       _nb_trajets+0 
	MOVF        eeprom_charger_stored_traj_L0+1, 0 
	MOVWF       _nb_trajets+1 
;Ascenseur.c,280 :: 		}
L_eeprom_charger30:
;Ascenseur.c,282 :: 		if (last_etage == 0xFF) {
	MOVF        _last_etage+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_eeprom_charger31
;Ascenseur.c,283 :: 		last_etage = 0;
	CLRF        _last_etage+0 
;Ascenseur.c,284 :: 		eep_write_byte(0x02, 0);
	MOVLW       2
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,285 :: 		}
L_eeprom_charger31:
;Ascenseur.c,287 :: 		if (stored_vit == 0xFF || stored_vit == 0) {
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L__eeprom_charger493
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__eeprom_charger493
	GOTO        L_eeprom_charger34
L__eeprom_charger493:
;Ascenseur.c,288 :: 		vitesse_eeprom = 100;
	MOVLW       100
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,289 :: 		vitesse_max_pc  = 100;
	MOVLW       100
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,290 :: 		eep_write_byte(0x03, 100);
	MOVLW       3
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVLW       100
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,291 :: 		} else {
	GOTO        L_eeprom_charger35
L_eeprom_charger34:
;Ascenseur.c,292 :: 		vitesse_eeprom = stored_vit;
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,293 :: 		vitesse_max_pc  = stored_vit;
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,294 :: 		}
L_eeprom_charger35:
;Ascenseur.c,296 :: 		poids_max        = POIDS_MAX_DEF;
	MOVLW       118
	MOVWF       _poids_max+0 
	MOVLW       2
	MOVWF       _poids_max+1 
;Ascenseur.c,297 :: 		seuil_surge      = POIDS_MAX_DEF;
	MOVLW       118
	MOVWF       _seuil_surge+0 
	MOVLW       2
	MOVWF       _seuil_surge+1 
;Ascenseur.c,298 :: 		surcharge_active = 0;
	CLRF        _surcharge_active+0 
;Ascenseur.c,299 :: 		etat_surcharge   = 0;
	CLRF        _etat_surcharge+0 
;Ascenseur.c,301 :: 		recalc_pwm_max();
	CALL        _recalc_pwm_max+0, 0
;Ascenseur.c,302 :: 		}
L_end_eeprom_charger:
	RETURN      0
; end of _eeprom_charger

_eeprom_sauver_trajet:

;Ascenseur.c,304 :: 		void eeprom_sauver_trajet() {
;Ascenseur.c,305 :: 		nb_session++;
	INFSNZ      _nb_session+0, 1 
	INCF        _nb_session+1, 1 
;Ascenseur.c,306 :: 		nb_trajets++;
	INFSNZ      _nb_trajets+0, 1 
	INCF        _nb_trajets+1, 1 
;Ascenseur.c,307 :: 		last_etage = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _last_etage+0 
;Ascenseur.c,308 :: 		eep_write_word(0x00, nb_trajets);
	CLRF        FARG_eep_write_word_addr+0 
	MOVF        _nb_trajets+0, 0 
	MOVWF       FARG_eep_write_word_val+0 
	MOVF        _nb_trajets+1, 0 
	MOVWF       FARG_eep_write_word_val+1 
	CALL        _eep_write_word+0, 0
;Ascenseur.c,309 :: 		eep_write_byte(0x02, last_etage);
	MOVLW       2
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        _last_etage+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,310 :: 		}
L_end_eeprom_sauver_trajet:
	RETURN      0
; end of _eeprom_sauver_trajet

_eeprom_reset:

;Ascenseur.c,312 :: 		void eeprom_reset() {
;Ascenseur.c,313 :: 		nb_trajets = 0;
	CLRF        _nb_trajets+0 
	CLRF        _nb_trajets+1 
;Ascenseur.c,314 :: 		last_etage = 0;
	CLRF        _last_etage+0 
;Ascenseur.c,315 :: 		vitesse_eeprom = 100;
	MOVLW       100
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,316 :: 		vitesse_max_pc = 100;
	MOVLW       100
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,317 :: 		recalc_pwm_max();
	CALL        _recalc_pwm_max+0, 0
;Ascenseur.c,319 :: 		eep_write_byte(0x00, 0x00);
	CLRF        FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,320 :: 		eep_write_byte(0x01, 0x00);
	MOVLW       1
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,321 :: 		eep_write_byte(0x02, 0x00);
	MOVLW       2
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,322 :: 		eep_write_byte(0x03, 100);
	MOVLW       3
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVLW       100
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,323 :: 		eep_write_byte(0x04, 0x00);
	MOVLW       4
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,324 :: 		eep_write_byte(0x05, 0x00);
	MOVLW       5
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,325 :: 		}
L_end_eeprom_reset:
	RETURN      0
; end of _eeprom_reset

_set_pwm:

;Ascenseur.c,327 :: 		void set_pwm(unsigned char duty) {
;Ascenseur.c,328 :: 		PWM1_Set_Duty(duty);
	MOVF        FARG_set_pwm_duty+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,330 :: 		if (pwm_max_eff > 0) {
	MOVF        _pwm_max_eff+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_set_pwm36
;Ascenseur.c,331 :: 		if (duty >= pwm_max_eff)
	MOVF        _pwm_max_eff+0, 0 
	SUBWF       FARG_set_pwm_duty+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_set_pwm37
;Ascenseur.c,332 :: 		pwm_actuel = vitesse_max_pc;
	MOVF        _vitesse_max_pc+0, 0 
	MOVWF       _pwm_actuel+0 
	GOTO        L_set_pwm38
L_set_pwm37:
;Ascenseur.c,334 :: 		pwm_actuel = (unsigned char)((unsigned long)vitesse_max_pc * duty / pwm_max_eff);
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
L_set_pwm38:
;Ascenseur.c,335 :: 		} else {
	GOTO        L_set_pwm39
L_set_pwm36:
;Ascenseur.c,336 :: 		pwm_actuel = 0;
	CLRF        _pwm_actuel+0 
;Ascenseur.c,337 :: 		}
L_set_pwm39:
;Ascenseur.c,338 :: 		}
L_end_set_pwm:
	RETURN      0
; end of _set_pwm

_uart_send_data:

;Ascenseur.c,340 :: 		void uart_send_data() {
;Ascenseur.c,344 :: 		if (suppress_data_count > 0) {
	MOVF        _suppress_data_count+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_uart_send_data40
;Ascenseur.c,345 :: 		suppress_data_count--;
	DECF        _suppress_data_count+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _suppress_data_count+0 
;Ascenseur.c,346 :: 		return;
	GOTO        L_end_uart_send_data
;Ascenseur.c,347 :: 		}
L_uart_send_data40:
;Ascenseur.c,349 :: 		if      (direction == 'U') dir_n = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data41
	MOVLW       1
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data42
L_uart_send_data41:
;Ascenseur.c,350 :: 		else if (direction == 'D') dir_n = 2;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data43
	MOVLW       2
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data44
L_uart_send_data43:
;Ascenseur.c,351 :: 		else                       dir_n = 0;
	CLRF        uart_send_data_dir_n_L0+0 
L_uart_send_data44:
L_uart_send_data42:
;Ascenseur.c,353 :: 		prt_n = mode_auto ? (ir_porte ? 1 : 0) : (porte_cmd ? 1 : 0);
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data45
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data47
	MOVLW       1
	MOVWF       ?FLOC___uart_send_dataT92+0 
	GOTO        L_uart_send_data48
L_uart_send_data47:
	CLRF        ?FLOC___uart_send_dataT92+0 
L_uart_send_data48:
	MOVF        ?FLOC___uart_send_dataT92+0, 0 
	MOVWF       ?FLOC___uart_send_dataT93+0 
	GOTO        L_uart_send_data46
L_uart_send_data45:
	MOVF        _porte_cmd+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data49
	MOVLW       1
	MOVWF       ?FLOC___uart_send_dataT94+0 
	GOTO        L_uart_send_data50
L_uart_send_data49:
	CLRF        ?FLOC___uart_send_dataT94+0 
L_uart_send_data50:
	MOVF        ?FLOC___uart_send_dataT94+0, 0 
	MOVWF       ?FLOC___uart_send_dataT93+0 
L_uart_send_data46:
;Ascenseur.c,355 :: 		sprintf(trame,
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_sprintf_wh+1 
;Ascenseur.c,356 :: 		"<DATA,ET:%d,DIR:%d,PT:%d,PRT:%d,AL:%d,URG:%d,NB:%d,PWM:%d,TPS:%d>\r\n",
	MOVLW       ?lstr_1_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,357 :: 		(int)etage_actuel, (int)dir_n, (int)poids_kg,
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
;Ascenseur.c,358 :: 		(int)prt_n,        (int)al_active, (int)urg_active,
	MOVF        ?FLOC___uart_send_dataT93+0, 0 
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
;Ascenseur.c,359 :: 		(int)nb_session,   (int)pwm_actuel, (int)temps_trajet);
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
;Ascenseur.c,361 :: 		UART1_Write_Text(trame);
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,362 :: 		}
L_end_uart_send_data:
	RETURN      0
; end of _uart_send_data

_uart_send_eeprom:

;Ascenseur.c,364 :: 		void uart_send_eeprom() {
;Ascenseur.c,366 :: 		suppress_data_count = 1;
	MOVLW       1
	MOVWF       _suppress_data_count+0 
;Ascenseur.c,367 :: 		sprintf(trame,
	MOVLW       uart_send_eeprom_trame_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(uart_send_eeprom_trame_L0+0)
	MOVWF       FARG_sprintf_wh+1 
;Ascenseur.c,368 :: 		"<EEP,TRAJ:%d,LAST:%d,VITESSE:%d>\r\n",
	MOVLW       ?lstr_2_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_2_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_2_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,369 :: 		(int)nb_trajets, (int)last_etage, (int)vitesse_eeprom);
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
;Ascenseur.c,370 :: 		UART1_Write_Text(trame);
	MOVLW       uart_send_eeprom_trame_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(uart_send_eeprom_trame_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,371 :: 		}
L_end_uart_send_eeprom:
	RETURN      0
; end of _uart_send_eeprom

_uart_ack_ok:

;Ascenseur.c,373 :: 		void uart_ack_ok()  { UART1_Write_Text("<ACK,OK>\r\n");  }
	MOVLW       ?lstr3_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
L_end_uart_ack_ok:
	RETURN      0
; end of _uart_ack_ok

_uart_ack_err:

;Ascenseur.c,374 :: 		void uart_ack_err() { UART1_Write_Text("<ACK,ERR>\r\n"); }
	MOVLW       ?lstr4_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
L_end_uart_ack_err:
	RETURN      0
; end of _uart_ack_err

_lire_capteurs:

;Ascenseur.c,376 :: 		void lire_capteurs() {
;Ascenseur.c,377 :: 		unsigned long somme = 0;
	CLRF        lire_capteurs_somme_L0+0 
	CLRF        lire_capteurs_somme_L0+1 
	CLRF        lire_capteurs_somme_L0+2 
	CLRF        lire_capteurs_somme_L0+3 
;Ascenseur.c,381 :: 		ir_porte = PORTA.F0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       _ir_porte+0 
;Ascenseur.c,383 :: 		ADC_Read(1);
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;Ascenseur.c,384 :: 		for (n = 0; n < 8; n++) {
	CLRF        lire_capteurs_n_L0+0 
L_lire_capteurs51:
	MOVLW       8
	SUBWF       lire_capteurs_n_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_lire_capteurs52
;Ascenseur.c,385 :: 		somme += ADC_Read(1);
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
;Ascenseur.c,384 :: 		for (n = 0; n < 8; n++) {
	INCF        lire_capteurs_n_L0+0, 1 
;Ascenseur.c,386 :: 		}
	GOTO        L_lire_capteurs51
L_lire_capteurs52:
;Ascenseur.c,387 :: 		raw_adc = (unsigned int)(somme >> 3);
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
L__lire_capteurs563:
	BZ          L__lire_capteurs564
	RRCF        R4, 1 
	RRCF        R3, 1 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R4, 7 
	ADDLW       255
	GOTO        L__lire_capteurs563
L__lire_capteurs564:
	MOVF        R1, 0 
	MOVWF       lire_capteurs_raw_adc_L0+0 
	MOVF        R2, 0 
	MOVWF       lire_capteurs_raw_adc_L0+1 
;Ascenseur.c,389 :: 		if (raw_adc > POT_ADC_MAX) raw_adc = POT_ADC_MAX;
	MOVF        R2, 0 
	SUBLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__lire_capteurs565
	MOVF        R1, 0 
	SUBLW       132
L__lire_capteurs565:
	BTFSC       STATUS+0, 0 
	GOTO        L_lire_capteurs54
	MOVLW       132
	MOVWF       lire_capteurs_raw_adc_L0+0 
	MOVLW       3
	MOVWF       lire_capteurs_raw_adc_L0+1 
L_lire_capteurs54:
;Ascenseur.c,390 :: 		poids_kg = (unsigned int)((raw_adc * 900UL) / POT_ADC_MAX);
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
;Ascenseur.c,391 :: 		}
L_end_lire_capteurs:
	RETURN      0
; end of _lire_capteurs

_maj_surcharge:

;Ascenseur.c,393 :: 		void maj_surcharge(unsigned char force_transition) {
;Ascenseur.c,394 :: 		surcharge_active = (poids_kg >= seuil_surge) ? 1 : 0;
	MOVF        _seuil_surge+1, 0 
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__maj_surcharge567
	MOVF        _seuil_surge+0, 0 
	SUBWF       _poids_kg+0, 0 
L__maj_surcharge567:
	BTFSS       STATUS+0, 0 
	GOTO        L_maj_surcharge55
	MOVLW       1
	MOVWF       ?FLOC___maj_surchargeT126+0 
	GOTO        L_maj_surcharge56
L_maj_surcharge55:
	CLRF        ?FLOC___maj_surchargeT126+0 
L_maj_surcharge56:
	MOVF        ?FLOC___maj_surchargeT126+0, 0 
	MOVWF       _surcharge_active+0 
;Ascenseur.c,395 :: 		if (force_transition) {
	MOVF        FARG_maj_surcharge_force_transition+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_maj_surcharge57
;Ascenseur.c,396 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,397 :: 		}
L_maj_surcharge57:
;Ascenseur.c,398 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,399 :: 		}
L_end_maj_surcharge:
	RETURN      0
; end of _maj_surcharge

_gerer_leds:

;Ascenseur.c,401 :: 		void gerer_leds() {
;Ascenseur.c,402 :: 		if (mode_auto) LED1 = ir_porte ? 1 : 0;
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_leds58
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_leds59
	MOVLW       1
	MOVWF       R0 
	GOTO        L_gerer_leds60
L_gerer_leds59:
	CLRF        R0 
L_gerer_leds60:
	BTFSC       R0, 0 
	GOTO        L__gerer_leds569
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L__gerer_leds570
L__gerer_leds569:
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
L__gerer_leds570:
	GOTO        L_gerer_leds61
L_gerer_leds58:
;Ascenseur.c,403 :: 		else           LED1 = porte_cmd ? 1 : 0;
	MOVF        _porte_cmd+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_gerer_leds62
	MOVLW       1
	MOVWF       R1 
	GOTO        L_gerer_leds63
L_gerer_leds62:
	CLRF        R1 
L_gerer_leds63:
	BTFSC       R1, 0 
	GOTO        L__gerer_leds571
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L__gerer_leds572
L__gerer_leds571:
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
L__gerer_leds572:
L_gerer_leds61:
;Ascenseur.c,405 :: 		LED2 = (surcharge_active || urg_active || al_active) ? 1 : 0;
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds494
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds494
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds494
	GOTO        L_gerer_leds66
L__gerer_leds494:
	MOVLW       1
	MOVWF       R2 
	GOTO        L_gerer_leds67
L_gerer_leds66:
	CLRF        R2 
L_gerer_leds67:
	BTFSC       R2, 0 
	GOTO        L__gerer_leds573
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
	GOTO        L__gerer_leds574
L__gerer_leds573:
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
L__gerer_leds574:
;Ascenseur.c,406 :: 		}
L_end_gerer_leds:
	RETURN      0
; end of _gerer_leds

_etat_porte_char:

;Ascenseur.c,408 :: 		char etat_porte_char() {
;Ascenseur.c,409 :: 		return (mode_auto ? ir_porte : porte_cmd) ? 'O' : 'F';
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_etat_porte_char68
	MOVF        _ir_porte+0, 0 
	MOVWF       R1 
	GOTO        L_etat_porte_char69
L_etat_porte_char68:
	MOVF        _porte_cmd+0, 0 
	MOVWF       R1 
L_etat_porte_char69:
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_etat_porte_char70
	MOVLW       79
	MOVWF       R2 
	GOTO        L_etat_porte_char71
L_etat_porte_char70:
	MOVLW       70
	MOVWF       R2 
L_etat_porte_char71:
	MOVF        R2, 0 
	MOVWF       R0 
;Ascenseur.c,410 :: 		}
L_end_etat_porte_char:
	RETURN      0
; end of _etat_porte_char

_lcd_build_surcharge_l2:

;Ascenseur.c,412 :: 		void lcd_build_surcharge_l2(char *buf) {
;Ascenseur.c,413 :: 		unsigned int v = poids_max;
	MOVF        _poids_max+0, 0 
	MOVWF       lcd_build_surcharge_l2_v_L0+0 
	MOVF        _poids_max+1, 0 
	MOVWF       lcd_build_surcharge_l2_v_L0+1 
;Ascenseur.c,415 :: 		buf[0]  = ' ';
	MOVFF       FARG_lcd_build_surcharge_l2_buf+0, FSR1L+0
	MOVFF       FARG_lcd_build_surcharge_l2_buf+1, FSR1H+0
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,416 :: 		buf[1]  = ' ';
	MOVLW       1
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,417 :: 		buf[2]  = 'M';
	MOVLW       2
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       77
	MOVWF       POSTINC1+0 
;Ascenseur.c,418 :: 		buf[3]  = 'A';
	MOVLW       3
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       65
	MOVWF       POSTINC1+0 
;Ascenseur.c,419 :: 		buf[4]  = 'X';
	MOVLW       4
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       88
	MOVWF       POSTINC1+0 
;Ascenseur.c,420 :: 		buf[5]  = ':';
	MOVLW       5
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       58
	MOVWF       POSTINC1+0 
;Ascenseur.c,421 :: 		buf[6]  = (v >= 100) ? ((char)('0' + (v / 100)))       : ' ';
	MOVLW       6
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+1 
	MOVLW       0
	SUBWF       lcd_build_surcharge_l2_v_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__lcd_build_surcharge_l2577
	MOVLW       100
	SUBWF       lcd_build_surcharge_l2_v_L0+0, 0 
L__lcd_build_surcharge_l2577:
	BTFSS       STATUS+0, 0 
	GOTO        L_lcd_build_surcharge_l272
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
	MOVWF       ?FLOC___lcd_build_surcharge_l2T151+0 
	GOTO        L_lcd_build_surcharge_l273
L_lcd_build_surcharge_l272:
	MOVLW       32
	MOVWF       ?FLOC___lcd_build_surcharge_l2T151+0 
L_lcd_build_surcharge_l273:
	MOVFF       FLOC__lcd_build_surcharge_l2+0, FSR1L+0
	MOVFF       FLOC__lcd_build_surcharge_l2+1, FSR1H+0
	MOVF        ?FLOC___lcd_build_surcharge_l2T151+0, 0 
	MOVWF       POSTINC1+0 
;Ascenseur.c,422 :: 		buf[7]  = (v >= 10)  ? ((char)('0' + ((v / 10) % 10))) : ' ';
	MOVLW       7
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+1 
	MOVLW       0
	SUBWF       lcd_build_surcharge_l2_v_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__lcd_build_surcharge_l2578
	MOVLW       10
	SUBWF       lcd_build_surcharge_l2_v_L0+0, 0 
L__lcd_build_surcharge_l2578:
	BTFSS       STATUS+0, 0 
	GOTO        L_lcd_build_surcharge_l274
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
	MOVWF       ?FLOC___lcd_build_surcharge_l2T159+0 
	GOTO        L_lcd_build_surcharge_l275
L_lcd_build_surcharge_l274:
	MOVLW       32
	MOVWF       ?FLOC___lcd_build_surcharge_l2T159+0 
L_lcd_build_surcharge_l275:
	MOVFF       FLOC__lcd_build_surcharge_l2+0, FSR1L+0
	MOVFF       FLOC__lcd_build_surcharge_l2+1, FSR1H+0
	MOVF        ?FLOC___lcd_build_surcharge_l2T159+0, 0 
	MOVWF       POSTINC1+0 
;Ascenseur.c,423 :: 		buf[8]  = (char)('0' + (v % 10));
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
;Ascenseur.c,424 :: 		buf[9]  = ' ';
	MOVLW       9
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,425 :: 		buf[10] = 'k';
	MOVLW       10
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       107
	MOVWF       POSTINC1+0 
;Ascenseur.c,426 :: 		buf[11] = 'g';
	MOVLW       11
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       103
	MOVWF       POSTINC1+0 
;Ascenseur.c,427 :: 		buf[12] = ' ';
	MOVLW       12
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,428 :: 		buf[13] = ' ';
	MOVLW       13
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,429 :: 		buf[14] = ' ';
	MOVLW       14
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,430 :: 		buf[15] = ' ';
	MOVLW       15
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,431 :: 		buf[16] = '\0';
	MOVLW       16
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;Ascenseur.c,432 :: 		}
L_end_lcd_build_surcharge_l2:
	RETURN      0
; end of _lcd_build_surcharge_l2

_afficher_lcd:

;Ascenseur.c,434 :: 		void afficher_lcd() {
;Ascenseur.c,439 :: 		if (position_inconnue) {
	MOVF        _position_inconnue+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd76
;Ascenseur.c,440 :: 		Lcd_Out(1, 1, "POS INCONNUE!   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,441 :: 		Lcd_Out(2, 1, "Replacer manuel ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,442 :: 		return;
	GOTO        L_end_afficher_lcd
;Ascenseur.c,443 :: 		}
L_afficher_lcd76:
;Ascenseur.c,445 :: 		if (!urg_active && !al_active && surcharge_active) {
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd79
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd79
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd79
L__afficher_lcd495:
;Ascenseur.c,446 :: 		lcd_build_surcharge_l2(surcharge_l2);
	MOVLW       afficher_lcd_surcharge_l2_L0+0
	MOVWF       FARG_lcd_build_surcharge_l2_buf+0 
	MOVLW       hi_addr(afficher_lcd_surcharge_l2_L0+0)
	MOVWF       FARG_lcd_build_surcharge_l2_buf+1 
	CALL        _lcd_build_surcharge_l2+0, 0
;Ascenseur.c,447 :: 		Lcd_Out(1, 1, "  SURCHARGE!    ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,448 :: 		Lcd_Out(2, 1, surcharge_l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       afficher_lcd_surcharge_l2_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(afficher_lcd_surcharge_l2_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,449 :: 		return;
	GOTO        L_end_afficher_lcd
;Ascenseur.c,450 :: 		}
L_afficher_lcd79:
;Ascenseur.c,452 :: 		if (mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd80
;Ascenseur.c,453 :: 		mode_str[0]='A'; mode_str[1]='u'; mode_str[2]='t'; mode_str[3]='o'; mode_str[4]='\0';
	MOVLW       65
	MOVWF       afficher_lcd_mode_str_L0+0 
	MOVLW       117
	MOVWF       afficher_lcd_mode_str_L0+1 
	MOVLW       116
	MOVWF       afficher_lcd_mode_str_L0+2 
	MOVLW       111
	MOVWF       afficher_lcd_mode_str_L0+3 
	CLRF        afficher_lcd_mode_str_L0+4 
;Ascenseur.c,454 :: 		} else {
	GOTO        L_afficher_lcd81
L_afficher_lcd80:
;Ascenseur.c,455 :: 		mode_str[0]='M'; mode_str[1]='a'; mode_str[2]='n'; mode_str[3]='u'; mode_str[4]='\0';
	MOVLW       77
	MOVWF       afficher_lcd_mode_str_L0+0 
	MOVLW       97
	MOVWF       afficher_lcd_mode_str_L0+1 
	MOVLW       110
	MOVWF       afficher_lcd_mode_str_L0+2 
	MOVLW       117
	MOVWF       afficher_lcd_mode_str_L0+3 
	CLRF        afficher_lcd_mode_str_L0+4 
;Ascenseur.c,456 :: 		}
L_afficher_lcd81:
;Ascenseur.c,458 :: 		if (en_mouvement) {
	MOVF        _en_mouvement+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd82
;Ascenseur.c,459 :: 		if (direction == 'U') { dir_str[0]='U'; dir_str[1]='P'; dir_str[2]='\0'; }
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd83
	MOVLW       85
	MOVWF       afficher_lcd_dir_str_L0+0 
	MOVLW       80
	MOVWF       afficher_lcd_dir_str_L0+1 
	CLRF        afficher_lcd_dir_str_L0+2 
	GOTO        L_afficher_lcd84
L_afficher_lcd83:
;Ascenseur.c,460 :: 		else                  { dir_str[0]='D'; dir_str[1]='N'; dir_str[2]='\0'; }
	MOVLW       68
	MOVWF       afficher_lcd_dir_str_L0+0 
	MOVLW       78
	MOVWF       afficher_lcd_dir_str_L0+1 
	CLRF        afficher_lcd_dir_str_L0+2 
L_afficher_lcd84:
;Ascenseur.c,462 :: 		sprintf(l1, "ET:%u->%u %s %s ",
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
;Ascenseur.c,463 :: 		(unsigned)etage_actuel, (unsigned)etage_cible, dir_str, mode_str);
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
;Ascenseur.c,464 :: 		} else {
	GOTO        L_afficher_lcd85
L_afficher_lcd82:
;Ascenseur.c,465 :: 		sprintf(l1, "ET:%u STOP  %s ",
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
;Ascenseur.c,466 :: 		(unsigned)etage_actuel, mode_str);
	MOVF        _etage_actuel+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       afficher_lcd_mode_str_L0+0
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       hi_addr(afficher_lcd_mode_str_L0+0)
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;Ascenseur.c,467 :: 		}
L_afficher_lcd85:
;Ascenseur.c,469 :: 		Lcd_Out(1, 1, l1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,470 :: 		sprintf(l2, "P:%3dkg IR:%c    ", (int)poids_kg, etat_porte_char());
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
;Ascenseur.c,471 :: 		Lcd_Out(2, 1, l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,472 :: 		}
L_end_afficher_lcd:
	RETURN      0
; end of _afficher_lcd

_lcd_transition:

;Ascenseur.c,474 :: 		void lcd_transition() {
;Ascenseur.c,475 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,476 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,477 :: 		}
L_end_lcd_transition:
	RETURN      0
; end of _lcd_transition

_lcd_update_transit:

;Ascenseur.c,479 :: 		void lcd_update_transit() {
;Ascenseur.c,483 :: 		if (direction == 'U') { dir_str[0]='U'; dir_str[1]='P'; dir_str[2]='\0'; }
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_update_transit86
	MOVLW       85
	MOVWF       lcd_update_transit_dir_str_L0+0 
	MOVLW       80
	MOVWF       lcd_update_transit_dir_str_L0+1 
	CLRF        lcd_update_transit_dir_str_L0+2 
	GOTO        L_lcd_update_transit87
L_lcd_update_transit86:
;Ascenseur.c,484 :: 		else                  { dir_str[0]='D'; dir_str[1]='N'; dir_str[2]='\0'; }
	MOVLW       68
	MOVWF       lcd_update_transit_dir_str_L0+0 
	MOVLW       78
	MOVWF       lcd_update_transit_dir_str_L0+1 
	CLRF        lcd_update_transit_dir_str_L0+2 
L_lcd_update_transit87:
;Ascenseur.c,486 :: 		if (mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_update_transit88
;Ascenseur.c,487 :: 		mode_str[0]='A'; mode_str[1]='u'; mode_str[2]='t'; mode_str[3]='o'; mode_str[4]='\0';
	MOVLW       65
	MOVWF       lcd_update_transit_mode_str_L0+0 
	MOVLW       117
	MOVWF       lcd_update_transit_mode_str_L0+1 
	MOVLW       116
	MOVWF       lcd_update_transit_mode_str_L0+2 
	MOVLW       111
	MOVWF       lcd_update_transit_mode_str_L0+3 
	CLRF        lcd_update_transit_mode_str_L0+4 
;Ascenseur.c,488 :: 		} else {
	GOTO        L_lcd_update_transit89
L_lcd_update_transit88:
;Ascenseur.c,489 :: 		mode_str[0]='M'; mode_str[1]='a'; mode_str[2]='n'; mode_str[3]='u'; mode_str[4]='\0';
	MOVLW       77
	MOVWF       lcd_update_transit_mode_str_L0+0 
	MOVLW       97
	MOVWF       lcd_update_transit_mode_str_L0+1 
	MOVLW       110
	MOVWF       lcd_update_transit_mode_str_L0+2 
	MOVLW       117
	MOVWF       lcd_update_transit_mode_str_L0+3 
	CLRF        lcd_update_transit_mode_str_L0+4 
;Ascenseur.c,490 :: 		}
L_lcd_update_transit89:
;Ascenseur.c,497 :: 		sprintf(l1, "ET:%u->%u %s %s ",
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
;Ascenseur.c,498 :: 		(unsigned)etage_actuel, (unsigned)etage_cible, dir_str, mode_str);
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
;Ascenseur.c,499 :: 		Lcd_Out(1, 1, l1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,501 :: 		sprintf(l2, "P:%3dkg IR:%c    ", (int)poids_kg, etat_porte_char());
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
;Ascenseur.c,502 :: 		Lcd_Out(2, 1, l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,507 :: 		}
L_end_lcd_update_transit:
	RETURN      0
; end of _lcd_update_transit

_appliquer_pmax:

;Ascenseur.c,509 :: 		void appliquer_pmax(unsigned int val) {
;Ascenseur.c,510 :: 		if (val < 1)   val = 1;
	MOVLW       0
	SUBWF       FARG_appliquer_pmax_val+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__appliquer_pmax583
	MOVLW       1
	SUBWF       FARG_appliquer_pmax_val+0, 0 
L__appliquer_pmax583:
	BTFSC       STATUS+0, 0 
	GOTO        L_appliquer_pmax90
	MOVLW       1
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVLW       0
	MOVWF       FARG_appliquer_pmax_val+1 
L_appliquer_pmax90:
;Ascenseur.c,511 :: 		if (val > 999) val = 999;
	MOVF        FARG_appliquer_pmax_val+1, 0 
	SUBLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__appliquer_pmax584
	MOVF        FARG_appliquer_pmax_val+0, 0 
	SUBLW       231
L__appliquer_pmax584:
	BTFSC       STATUS+0, 0 
	GOTO        L_appliquer_pmax91
	MOVLW       231
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVLW       3
	MOVWF       FARG_appliquer_pmax_val+1 
L_appliquer_pmax91:
;Ascenseur.c,513 :: 		poids_max  = val;
	MOVF        FARG_appliquer_pmax_val+0, 0 
	MOVWF       _poids_max+0 
	MOVF        FARG_appliquer_pmax_val+1, 0 
	MOVWF       _poids_max+1 
;Ascenseur.c,514 :: 		seuil_surge = val;
	MOVF        FARG_appliquer_pmax_val+0, 0 
	MOVWF       _seuil_surge+0 
	MOVF        FARG_appliquer_pmax_val+1, 0 
	MOVWF       _seuil_surge+1 
;Ascenseur.c,516 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,517 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,519 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,520 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,521 :: 		}
L_end_appliquer_pmax:
	RETURN      0
; end of _appliquer_pmax

_appliquer_spd:

;Ascenseur.c,523 :: 		void appliquer_spd(unsigned char val) {
;Ascenseur.c,524 :: 		if (val > 100) val = 100;
	MOVF        FARG_appliquer_spd_val+0, 0 
	SUBLW       100
	BTFSC       STATUS+0, 0 
	GOTO        L_appliquer_spd92
	MOVLW       100
	MOVWF       FARG_appliquer_spd_val+0 
L_appliquer_spd92:
;Ascenseur.c,525 :: 		if (val < 10)  val = 10;
	MOVLW       10
	SUBWF       FARG_appliquer_spd_val+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_appliquer_spd93
	MOVLW       10
	MOVWF       FARG_appliquer_spd_val+0 
L_appliquer_spd93:
;Ascenseur.c,527 :: 		vitesse_max_pc = val;
	MOVF        FARG_appliquer_spd_val+0, 0 
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,528 :: 		vitesse_eeprom = val;
	MOVF        FARG_appliquer_spd_val+0, 0 
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,529 :: 		recalc_pwm_max();
	CALL        _recalc_pwm_max+0, 0
;Ascenseur.c,530 :: 		eep_write_byte(0x03, vitesse_eeprom);
	MOVLW       3
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        _vitesse_eeprom+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,532 :: 		if (moteur_actif) set_pwm(pwm_max_eff);
	MOVF        _moteur_actif+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_appliquer_spd94
	MOVF        _pwm_max_eff+0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
L_appliquer_spd94:
;Ascenseur.c,534 :: 		suppress_data_count = 1;
	MOVLW       1
	MOVWF       _suppress_data_count+0 
;Ascenseur.c,535 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,536 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,537 :: 		}
L_end_appliquer_spd:
	RETURN      0
; end of _appliquer_spd

_attendre_ms:

;Ascenseur.c,539 :: 		void attendre_ms(unsigned int ms) {
;Ascenseur.c,540 :: 		unsigned int  elapsed = 0;
	CLRF        attendre_ms_elapsed_L0+0 
	CLRF        attendre_ms_elapsed_L0+1 
;Ascenseur.c,548 :: 		while (elapsed < ms) {
L_attendre_ms95:
	MOVF        FARG_attendre_ms_ms+1, 0 
	SUBWF       attendre_ms_elapsed_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms587
	MOVF        FARG_attendre_ms_ms+0, 0 
	SUBWF       attendre_ms_elapsed_L0+0, 0 
L__attendre_ms587:
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms96
;Ascenseur.c,550 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_attendre_ms99
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms99
L__attendre_ms507:
;Ascenseur.c,551 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_attendre_ms100:
	DECFSZ      R13, 1, 1
	BRA         L_attendre_ms100
	DECFSZ      R12, 1, 1
	BRA         L_attendre_ms100
	NOP
	NOP
;Ascenseur.c,552 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_attendre_ms101
;Ascenseur.c,553 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,554 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,555 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,556 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,557 :: 		}
L_attendre_ms101:
;Ascenseur.c,558 :: 		}
L_attendre_ms99:
;Ascenseur.c,560 :: 		if (urgence_flag || stop_demande) return;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms506
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms506
	GOTO        L_attendre_ms107
L__attendre_ms506:
	GOTO        L_end_attendre_ms
L_attendre_ms107:
;Ascenseur.c,562 :: 		if (pop_cmd(local_cmd)) {
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms108
;Ascenseur.c,564 :: 		if (strstr(local_cmd, "CMD,STOP")) {
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
	GOTO        L_attendre_ms109
;Ascenseur.c,565 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,566 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,567 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,568 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,569 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,570 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,571 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,573 :: 		} else if (strstr(local_cmd, "MOT:STP") || strstr(local_cmd, "MOT:STOP")) {
	GOTO        L_attendre_ms113
L_attendre_ms109:
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
	GOTO        L__attendre_ms505
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
	GOTO        L__attendre_ms505
	GOTO        L_attendre_ms116
L__attendre_ms505:
;Ascenseur.c,575 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,576 :: 		stop_demande = 1;
	MOVLW       1
	MOVWF       _stop_demande+0 
;Ascenseur.c,577 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,579 :: 		} else if (strstr(local_cmd, "AL:ON")) {
	GOTO        L_attendre_ms120
L_attendre_ms116:
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
	GOTO        L_attendre_ms121
;Ascenseur.c,580 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,581 :: 		al_flag = 1;
	MOVLW       1
	MOVWF       _al_flag+0 
;Ascenseur.c,582 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,583 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,585 :: 		} else if ((pp = strstr(local_cmd, "CALL:")) != 0) {
	GOTO        L_attendre_ms122
L_attendre_ms121:
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
	GOTO        L__attendre_ms588
	MOVLW       0
	XORWF       R0, 0 
L__attendre_ms588:
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms123
;Ascenseur.c,586 :: 		nc = (unsigned char)(*(pp + 5) - '0');
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
;Ascenseur.c,587 :: 		if (nc < NB_ETAGES && !al_active && !surcharge_active) {
	MOVLW       4
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms126
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms126
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms126
L__attendre_ms504:
;Ascenseur.c,588 :: 		if      (direction == 'U' && nc > etage_actuel) req[nc] = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms129
	MOVF        attendre_ms_nc_L0+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms129
L__attendre_ms503:
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
	GOTO        L_attendre_ms130
L_attendre_ms129:
;Ascenseur.c,589 :: 		else if (direction == 'D' && nc < etage_actuel) req[nc] = 1;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms133
	MOVF        _etage_actuel+0, 0 
	SUBWF       attendre_ms_nc_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms133
L__attendre_ms502:
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
L_attendre_ms133:
L_attendre_ms130:
;Ascenseur.c,590 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,591 :: 		} else {
	GOTO        L_attendre_ms134
L_attendre_ms126:
;Ascenseur.c,592 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,593 :: 		}
L_attendre_ms134:
;Ascenseur.c,595 :: 		} else if ((pp = strstr(local_cmd, "PMAX:")) != 0) {
	GOTO        L_attendre_ms135
L_attendre_ms123:
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
	GOTO        L__attendre_ms589
	MOVLW       0
	XORWF       R0, 0 
L__attendre_ms589:
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms136
;Ascenseur.c,596 :: 		pv = 0;
	CLRF        attendre_ms_pv_L0+0 
	CLRF        attendre_ms_pv_L0+1 
;Ascenseur.c,597 :: 		pp += 5;
	MOVLW       5
	ADDWF       attendre_ms_pp_L0+0, 1 
	MOVLW       0
	ADDWFC      attendre_ms_pp_L0+1, 1 
;Ascenseur.c,598 :: 		while (*pp >= '0' && *pp <= '9') {
L_attendre_ms137:
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_attendre_ms138
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_attendre_ms138
L__attendre_ms501:
;Ascenseur.c,599 :: 		pv = pv * 10 + (unsigned int)(*pp - '0');
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
;Ascenseur.c,600 :: 		pp++;
	INFSNZ      attendre_ms_pp_L0+0, 1 
	INCF        attendre_ms_pp_L0+1, 1 
;Ascenseur.c,601 :: 		}
	GOTO        L_attendre_ms137
L_attendre_ms138:
;Ascenseur.c,602 :: 		appliquer_pmax(pv);
	MOVF        attendre_ms_pv_L0+0, 0 
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVF        attendre_ms_pv_L0+1, 0 
	MOVWF       FARG_appliquer_pmax_val+1 
	CALL        _appliquer_pmax+0, 0
;Ascenseur.c,604 :: 		} else if ((pp = strstr(local_cmd, "SPD:")) != 0) {
	GOTO        L_attendre_ms141
L_attendre_ms136:
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
	GOTO        L__attendre_ms590
	MOVLW       0
	XORWF       R0, 0 
L__attendre_ms590:
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms142
;Ascenseur.c,605 :: 		sv = 0;
	CLRF        attendre_ms_sv_L0+0 
;Ascenseur.c,606 :: 		pp += 4;
	MOVLW       4
	ADDWF       attendre_ms_pp_L0+0, 1 
	MOVLW       0
	ADDWFC      attendre_ms_pp_L0+1, 1 
;Ascenseur.c,607 :: 		while (*pp >= '0' && *pp <= '9') {
L_attendre_ms143:
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_attendre_ms144
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_attendre_ms144
L__attendre_ms500:
;Ascenseur.c,608 :: 		sv = sv * 10 + (unsigned char)(*pp - '0');
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
;Ascenseur.c,609 :: 		pp++;
	INFSNZ      attendre_ms_pp_L0+0, 1 
	INCF        attendre_ms_pp_L0+1, 1 
;Ascenseur.c,610 :: 		}
	GOTO        L_attendre_ms143
L_attendre_ms144:
;Ascenseur.c,611 :: 		appliquer_spd(sv);
	MOVF        attendre_ms_sv_L0+0, 0 
	MOVWF       FARG_appliquer_spd_val+0 
	CALL        _appliquer_spd+0, 0
;Ascenseur.c,613 :: 		} else if (strstr(local_cmd, "GET:EEP")) {
	GOTO        L_attendre_ms147
L_attendre_ms142:
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
	GOTO        L_attendre_ms148
;Ascenseur.c,614 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,616 :: 		} else if (strstr(local_cmd, "EEP:RST") || strstr(local_cmd, "RST:EEP")) {
	GOTO        L_attendre_ms149
L_attendre_ms148:
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
	GOTO        L__attendre_ms499
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
	GOTO        L__attendre_ms499
	GOTO        L_attendre_ms152
L__attendre_ms499:
;Ascenseur.c,617 :: 		eeprom_reset();
	CALL        _eeprom_reset+0, 0
;Ascenseur.c,618 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,619 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,620 :: 		}
L_attendre_ms152:
L_attendre_ms149:
L_attendre_ms147:
L_attendre_ms141:
L_attendre_ms135:
L_attendre_ms122:
L_attendre_ms120:
L_attendre_ms113:
;Ascenseur.c,621 :: 		}
L_attendre_ms108:
;Ascenseur.c,623 :: 		if (urgence_flag || stop_demande) return;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms498
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms498
	GOTO        L_attendre_ms155
L__attendre_ms498:
	GOTO        L_end_attendre_ms
L_attendre_ms155:
;Ascenseur.c,625 :: 		for (b = 0; b < NB_ETAGES; b++) {
	CLRF        attendre_ms_b_L0+0 
L_attendre_ms156:
	MOVLW       4
	SUBWF       attendre_ms_b_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms157
;Ascenseur.c,626 :: 		if (PORTD & (1 << b)) {
	MOVF        attendre_ms_b_L0+0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__attendre_ms591:
	BZ          L__attendre_ms592
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__attendre_ms591
L__attendre_ms592:
	MOVF        PORTD+0, 0 
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms159
;Ascenseur.c,627 :: 		if      (direction == 'U' && b > etage_actuel) req[b] = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms162
	MOVF        attendre_ms_b_L0+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms162
L__attendre_ms497:
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
	GOTO        L_attendre_ms163
L_attendre_ms162:
;Ascenseur.c,628 :: 		else if (direction == 'D' && b < etage_actuel) req[b] = 1;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms166
	MOVF        _etage_actuel+0, 0 
	SUBWF       attendre_ms_b_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms166
L__attendre_ms496:
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
L_attendre_ms166:
L_attendre_ms163:
;Ascenseur.c,629 :: 		}
L_attendre_ms159:
;Ascenseur.c,625 :: 		for (b = 0; b < NB_ETAGES; b++) {
	INCF        attendre_ms_b_L0+0, 1 
;Ascenseur.c,630 :: 		}
	GOTO        L_attendre_ms156
L_attendre_ms157:
;Ascenseur.c,632 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms167
;Ascenseur.c,633 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,634 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,635 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,636 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,638 :: 		if (moteur_actif) lcd_update_transit();
	MOVF        _moteur_actif+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms168
	CALL        _lcd_update_transit+0, 0
	GOTO        L_attendre_ms169
L_attendre_ms168:
;Ascenseur.c,639 :: 		else              afficher_lcd();
	CALL        _afficher_lcd+0, 0
L_attendre_ms169:
;Ascenseur.c,640 :: 		}
L_attendre_ms167:
;Ascenseur.c,642 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_attendre_ms170:
	DECFSZ      R13, 1, 1
	BRA         L_attendre_ms170
	DECFSZ      R12, 1, 1
	BRA         L_attendre_ms170
	NOP
	NOP
;Ascenseur.c,643 :: 		elapsed += MS_LOOP_STEP;
	MOVLW       20
	ADDWF       attendre_ms_elapsed_L0+0, 1 
	MOVLW       0
	ADDWFC      attendre_ms_elapsed_L0+1, 1 
;Ascenseur.c,644 :: 		}
	GOTO        L_attendre_ms95
L_attendre_ms96:
;Ascenseur.c,645 :: 		}
L_end_attendre_ms:
	RETURN      0
; end of _attendre_ms

_rampe_accel:

;Ascenseur.c,647 :: 		void rampe_accel() {
;Ascenseur.c,651 :: 		for (i = 0; i <= PWM_PALIERS; i++) {
	CLRF        rampe_accel_i_L0+0 
L_rampe_accel171:
	MOVF        rampe_accel_i_L0+0, 0 
	SUBLW       6
	BTFSS       STATUS+0, 0 
	GOTO        L_rampe_accel172
;Ascenseur.c,652 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_accel176
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_rampe_accel176
L__rampe_accel509:
;Ascenseur.c,653 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_accel177:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_accel177
	DECFSZ      R12, 1, 1
	BRA         L_rampe_accel177
	NOP
	NOP
;Ascenseur.c,654 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_accel178
;Ascenseur.c,655 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,656 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,657 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,658 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,659 :: 		}
L_rampe_accel178:
;Ascenseur.c,660 :: 		}
L_rampe_accel176:
;Ascenseur.c,662 :: 		if (urgence_flag || stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_accel508
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_accel508
	GOTO        L_rampe_accel184
L__rampe_accel508:
;Ascenseur.c,663 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,664 :: 		return;
	GOTO        L_end_rampe_accel
;Ascenseur.c,665 :: 		}
L_rampe_accel184:
;Ascenseur.c,667 :: 		pwm = PWM_MIN + ((unsigned int)(pwm_max_eff - PWM_MIN) * i) / PWM_PALIERS;
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
;Ascenseur.c,668 :: 		set_pwm((unsigned char)pwm);
	MOVF        R0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,669 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,670 :: 		Delay_ms(MS_PALIER);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_accel188:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_accel188
	DECFSZ      R12, 1, 1
	BRA         L_rampe_accel188
	NOP
	NOP
;Ascenseur.c,651 :: 		for (i = 0; i <= PWM_PALIERS; i++) {
	INCF        rampe_accel_i_L0+0, 1 
;Ascenseur.c,671 :: 		}
	GOTO        L_rampe_accel171
L_rampe_accel172:
;Ascenseur.c,672 :: 		}
L_end_rampe_accel:
	RETURN      0
; end of _rampe_accel

_rampe_decel:

;Ascenseur.c,674 :: 		void rampe_decel() {
;Ascenseur.c,678 :: 		for (i = PWM_PALIERS; i > 0; i--) {
	MOVLW       6
	MOVWF       rampe_decel_i_L0+0 
L_rampe_decel189:
	MOVF        rampe_decel_i_L0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_rampe_decel190
;Ascenseur.c,679 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_decel194
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_rampe_decel194
L__rampe_decel511:
;Ascenseur.c,680 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_decel195:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_decel195
	DECFSZ      R12, 1, 1
	BRA         L_rampe_decel195
	NOP
	NOP
;Ascenseur.c,681 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_decel196
;Ascenseur.c,682 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,683 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,684 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,685 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,686 :: 		}
L_rampe_decel196:
;Ascenseur.c,687 :: 		}
L_rampe_decel194:
;Ascenseur.c,689 :: 		if (urgence_flag || stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_decel510
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_decel510
	GOTO        L_rampe_decel202
L__rampe_decel510:
;Ascenseur.c,690 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,691 :: 		return;
	GOTO        L_end_rampe_decel
;Ascenseur.c,692 :: 		}
L_rampe_decel202:
;Ascenseur.c,694 :: 		pwm = PWM_MIN + ((unsigned int)(pwm_max_eff - PWM_MIN) * (i - 1)) / PWM_PALIERS;
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
;Ascenseur.c,695 :: 		set_pwm((unsigned char)pwm);
	MOVF        R0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,696 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,697 :: 		Delay_ms(MS_PALIER);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_decel206:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_decel206
	DECFSZ      R12, 1, 1
	BRA         L_rampe_decel206
	NOP
	NOP
;Ascenseur.c,678 :: 		for (i = PWM_PALIERS; i > 0; i--) {
	DECF        rampe_decel_i_L0+0, 1 
;Ascenseur.c,698 :: 		}
	GOTO        L_rampe_decel189
L_rampe_decel190:
;Ascenseur.c,700 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,701 :: 		}
L_end_rampe_decel:
	RETURN      0
; end of _rampe_decel

_demarrer_moteur:

;Ascenseur.c,703 :: 		void demarrer_moteur(char sens) {
;Ascenseur.c,704 :: 		if (sens == 'U') MOTEUR_MONTER();
	MOVF        FARG_demarrer_moteur_sens+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_demarrer_moteur210
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	MOVLW       1
	MOVWF       _moteur_actif+0 
	GOTO        L_demarrer_moteur214
L_demarrer_moteur210:
;Ascenseur.c,705 :: 		else             MOTEUR_DESCENDRE();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	MOVLW       1
	MOVWF       _moteur_actif+0 
L_demarrer_moteur214:
;Ascenseur.c,707 :: 		set_pwm(PWM_MIN);
	MOVLW       80
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,708 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;Ascenseur.c,709 :: 		rampe_accel();
	CALL        _rampe_accel+0, 0
;Ascenseur.c,710 :: 		}
L_end_demarrer_moteur:
	RETURN      0
; end of _demarrer_moteur

_scanner_req:

;Ascenseur.c,712 :: 		void scanner_req() {
;Ascenseur.c,713 :: 		if (PORTD.F0) req[0] = 1;
	BTFSS       PORTD+0, 0 
	GOTO        L_scanner_req218
	MOVLW       1
	MOVWF       _req+0 
L_scanner_req218:
;Ascenseur.c,714 :: 		if (PORTD.F1) req[1] = 1;
	BTFSS       PORTD+0, 1 
	GOTO        L_scanner_req219
	MOVLW       1
	MOVWF       _req+1 
L_scanner_req219:
;Ascenseur.c,715 :: 		if (PORTD.F2) req[2] = 1;
	BTFSS       PORTD+0, 2 
	GOTO        L_scanner_req220
	MOVLW       1
	MOVWF       _req+2 
L_scanner_req220:
;Ascenseur.c,716 :: 		if (PORTD.F3) req[3] = 1;
	BTFSS       PORTD+0, 3 
	GOTO        L_scanner_req221
	MOVLW       1
	MOVWF       _req+3 
L_scanner_req221:
;Ascenseur.c,717 :: 		}
L_end_scanner_req:
	RETURN      0
; end of _scanner_req

_vider_req:

;Ascenseur.c,719 :: 		void vider_req() {
;Ascenseur.c,721 :: 		for (i = 0; i < NB_ETAGES; i++) req[i] = 0;
	CLRF        R1 
L_vider_req222:
	MOVLW       4
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_vider_req223
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
	GOTO        L_vider_req222
L_vider_req223:
;Ascenseur.c,722 :: 		}
L_end_vider_req:
	RETURN      0
; end of _vider_req

_prochain_req:

;Ascenseur.c,724 :: 		unsigned char prochain_req() {
;Ascenseur.c,728 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,730 :: 		if (direction == 'U') {
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req225
;Ascenseur.c,731 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       R4 
L_prochain_req226:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req227
;Ascenseur.c,732 :: 		if (req[i]) { req[i] = 0; return i; }
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
	GOTO        L_prochain_req229
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
L_prochain_req229:
;Ascenseur.c,731 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	INCF        R4, 1 
;Ascenseur.c,732 :: 		if (req[i]) { req[i] = 0; return i; }
	GOTO        L_prochain_req226
L_prochain_req227:
;Ascenseur.c,734 :: 		for (i = 0; i < etage_actuel; i++)
	CLRF        R4 
L_prochain_req230:
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req231
;Ascenseur.c,735 :: 		if (req[i]) { req[i] = 0; return i; }
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
;Ascenseur.c,734 :: 		for (i = 0; i < etage_actuel; i++)
	INCF        R4, 1 
;Ascenseur.c,735 :: 		if (req[i]) { req[i] = 0; return i; }
	GOTO        L_prochain_req230
L_prochain_req231:
;Ascenseur.c,737 :: 		} else if (direction == 'D') {
	GOTO        L_prochain_req234
L_prochain_req225:
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req235
;Ascenseur.c,738 :: 		for (i = etage_actuel; i > 0; i--)
	MOVF        _etage_actuel+0, 0 
	MOVWF       R4 
L_prochain_req236:
	MOVF        R4, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req237
;Ascenseur.c,739 :: 		if (req[i - 1]) { req[i - 1] = 0; return i - 1; }
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
	GOTO        L_prochain_req239
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
L_prochain_req239:
;Ascenseur.c,738 :: 		for (i = etage_actuel; i > 0; i--)
	DECF        R4, 1 
;Ascenseur.c,739 :: 		if (req[i - 1]) { req[i - 1] = 0; return i - 1; }
	GOTO        L_prochain_req236
L_prochain_req237:
;Ascenseur.c,741 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       R4 
L_prochain_req240:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req241
;Ascenseur.c,742 :: 		if (req[i]) { req[i] = 0; return i; }
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
	GOTO        L_prochain_req243
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
L_prochain_req243:
;Ascenseur.c,741 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	INCF        R4, 1 
;Ascenseur.c,742 :: 		if (req[i]) { req[i] = 0; return i; }
	GOTO        L_prochain_req240
L_prochain_req241:
;Ascenseur.c,744 :: 		} else {
	GOTO        L_prochain_req244
L_prochain_req235:
;Ascenseur.c,745 :: 		nearest = 0xFF;
	MOVLW       255
	MOVWF       R5 
;Ascenseur.c,746 :: 		min_d = 10;
	MOVLW       10
	MOVWF       R8 
	MOVLW       0
	MOVWF       R9 
;Ascenseur.c,748 :: 		for (i = 0; i < NB_ETAGES; i++) {
	CLRF        R4 
L_prochain_req245:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req246
;Ascenseur.c,749 :: 		if (!req[i]) continue;
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
	GOTO        L_prochain_req248
	GOTO        L_prochain_req247
L_prochain_req248:
;Ascenseur.c,751 :: 		d = (i >= etage_actuel) ? (unsigned int)(i - etage_actuel)
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_prochain_req249
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
;Ascenseur.c,752 :: 		: (unsigned int)(etage_actuel - i);
	GOTO        L_prochain_req250
L_prochain_req249:
	MOVF        R4, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
L_prochain_req250:
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
;Ascenseur.c,754 :: 		if (d < min_d) {
	MOVF        R9, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__prochain_req599
	MOVF        R8, 0 
	SUBWF       R2, 0 
L__prochain_req599:
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req251
;Ascenseur.c,755 :: 		min_d = d;
	MOVF        R6, 0 
	MOVWF       R8 
	MOVF        R7, 0 
	MOVWF       R9 
;Ascenseur.c,756 :: 		nearest = i;
	MOVF        R4, 0 
	MOVWF       R5 
;Ascenseur.c,757 :: 		}
L_prochain_req251:
;Ascenseur.c,758 :: 		}
L_prochain_req247:
;Ascenseur.c,748 :: 		for (i = 0; i < NB_ETAGES; i++) {
	INCF        R4, 1 
;Ascenseur.c,758 :: 		}
	GOTO        L_prochain_req245
L_prochain_req246:
;Ascenseur.c,760 :: 		if (nearest != 0xFF) {
	MOVF        R5, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_prochain_req252
;Ascenseur.c,761 :: 		req[nearest] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        R5, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,762 :: 		return nearest;
	MOVF        R5, 0 
	MOVWF       R0 
	GOTO        L_end_prochain_req
;Ascenseur.c,763 :: 		}
L_prochain_req252:
;Ascenseur.c,764 :: 		}
L_prochain_req244:
L_prochain_req234:
;Ascenseur.c,766 :: 		return 0xFF;
	MOVLW       255
	MOVWF       R0 
;Ascenseur.c,767 :: 		}
L_end_prochain_req:
	RETURN      0
; end of _prochain_req

_deplacer_vers:

;Ascenseur.c,769 :: 		void deplacer_vers(unsigned char cible) {
;Ascenseur.c,774 :: 		if (cible == etage_actuel || urgence_flag) return;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	XORWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__deplacer_vers524
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers524
	GOTO        L_deplacer_vers255
L__deplacer_vers524:
	GOTO        L_end_deplacer_vers
L_deplacer_vers255:
;Ascenseur.c,776 :: 		stop_demande = 0;
	CLRF        _stop_demande+0 
;Ascenseur.c,778 :: 		sens = (cible > etage_actuel) ? 'U' : 'D';
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers256
	MOVLW       85
	MOVWF       ?FLOC___deplacer_versT458+0 
	GOTO        L_deplacer_vers257
L_deplacer_vers256:
	MOVLW       68
	MOVWF       ?FLOC___deplacer_versT458+0 
L_deplacer_vers257:
	MOVF        ?FLOC___deplacer_versT458+0, 0 
	MOVWF       deplacer_vers_sens_L0+0 
;Ascenseur.c,779 :: 		direction = sens;
	MOVF        ?FLOC___deplacer_versT458+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,780 :: 		etage_cible = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,781 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,783 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,784 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,785 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,786 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,787 :: 		temps_debut = timer0_count;
	MOVF        _timer0_count+0, 0 
	MOVWF       deplacer_vers_temps_debut_L0+0 
	MOVF        _timer0_count+1, 0 
	MOVWF       deplacer_vers_temps_debut_L0+1 
;Ascenseur.c,789 :: 		attendre_ms(MS_FERMETURE);
	MOVLW       50
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       0
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,790 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers523
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers523
	GOTO        L_deplacer_vers260
L__deplacer_vers523:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers260:
;Ascenseur.c,792 :: 		nb_et = (cible > etage_actuel) ? (cible - etage_actuel) : (etage_actuel - cible);
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers261
	MOVF        _etage_actuel+0, 0 
	SUBWF       FARG_deplacer_vers_cible+0, 0 
	MOVWF       ?FLOC___deplacer_versT462+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT462+1 
	GOTO        L_deplacer_vers262
L_deplacer_vers261:
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       ?FLOC___deplacer_versT462+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT462+1 
L_deplacer_vers262:
	MOVF        ?FLOC___deplacer_versT462+0, 0 
	MOVWF       deplacer_vers_nb_et_L0+0 
;Ascenseur.c,794 :: 		demarrer_moteur(sens);
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       FARG_demarrer_moteur_sens+0 
	CALL        _demarrer_moteur+0, 0
;Ascenseur.c,795 :: 		lcd_update_transit();
	CALL        _lcd_update_transit+0, 0
;Ascenseur.c,797 :: 		for (i = 0; i < nb_et; i++) {
	CLRF        deplacer_vers_i_L0+0 
L_deplacer_vers263:
	MOVF        deplacer_vers_nb_et_L0+0, 0 
	SUBWF       deplacer_vers_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers264
;Ascenseur.c,798 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers522
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers522
	GOTO        L_deplacer_vers268
L__deplacer_vers522:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers268:
;Ascenseur.c,800 :: 		est_dernier = (i == nb_et - 1);
	DECF        deplacer_vers_nb_et_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers601
	MOVF        R0, 0 
	XORWF       deplacer_vers_i_L0+0, 0 
L__deplacer_vers601:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       deplacer_vers_est_dernier_L0+0 
;Ascenseur.c,801 :: 		set_pwm(pwm_max_eff);
	MOVF        _pwm_max_eff+0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,803 :: 		if (!est_dernier) {
	MOVF        deplacer_vers_est_dernier_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers269
;Ascenseur.c,804 :: 		entre_etages = 1;
	MOVLW       1
	MOVWF       _entre_etages+0 
;Ascenseur.c,805 :: 		attendre_ms(MS_CROISIERE);
	MOVLW       244
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,806 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers521
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers521
	GOTO        L_deplacer_vers272
L__deplacer_vers521:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers272:
;Ascenseur.c,807 :: 		entre_etages = 0;
	CLRF        _entre_etages+0 
;Ascenseur.c,809 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers273
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers274
L_deplacer_vers273:
;Ascenseur.c,810 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers274:
;Ascenseur.c,812 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,813 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,814 :: 		lcd_update_transit();
	CALL        _lcd_update_transit+0, 0
;Ascenseur.c,815 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,817 :: 		if (req[etage_actuel]) {
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
	GOTO        L_deplacer_vers275
;Ascenseur.c,818 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,819 :: 		rampe_decel();
	CALL        _rampe_decel+0, 0
;Ascenseur.c,820 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers520
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers520
	GOTO        L_deplacer_vers278
L__deplacer_vers520:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers278:
;Ascenseur.c,822 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,823 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,824 :: 		etage_cible = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,825 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,826 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,827 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,828 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,830 :: 		attendre_ms(MS_ARRET_INTERMED);
	MOVLW       244
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,831 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers519
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers519
	GOTO        L_deplacer_vers281
L__deplacer_vers519:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers281:
;Ascenseur.c,833 :: 		direction = sens;
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,834 :: 		etage_cible = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,835 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,836 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,837 :: 		attendre_ms(MS_FERMETURE);
	MOVLW       50
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       0
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,838 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers518
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers518
	GOTO        L_deplacer_vers284
L__deplacer_vers518:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers284:
;Ascenseur.c,839 :: 		demarrer_moteur(sens);
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       FARG_demarrer_moteur_sens+0 
	CALL        _demarrer_moteur+0, 0
;Ascenseur.c,840 :: 		lcd_update_transit();
	CALL        _lcd_update_transit+0, 0
;Ascenseur.c,841 :: 		}
L_deplacer_vers275:
;Ascenseur.c,843 :: 		} else {
	GOTO        L_deplacer_vers285
L_deplacer_vers269:
;Ascenseur.c,844 :: 		entre_etages = 1;
	MOVLW       1
	MOVWF       _entre_etages+0 
;Ascenseur.c,845 :: 		if (nb_et == 1) attendre_ms(MS_CROISIERE_1ET);
	MOVF        deplacer_vers_nb_et_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers286
	MOVLW       124
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
	GOTO        L_deplacer_vers287
L_deplacer_vers286:
;Ascenseur.c,846 :: 		else            attendre_ms(MS_CROISIERE);
	MOVLW       244
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
L_deplacer_vers287:
;Ascenseur.c,848 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers517
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers517
	GOTO        L_deplacer_vers290
L__deplacer_vers517:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers290:
;Ascenseur.c,849 :: 		entre_etages = 0;
	CLRF        _entre_etages+0 
;Ascenseur.c,851 :: 		rampe_decel();
	CALL        _rampe_decel+0, 0
;Ascenseur.c,852 :: 		if (urgence_flag || stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers516
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers516
	GOTO        L_deplacer_vers293
L__deplacer_vers516:
;Ascenseur.c,853 :: 		position_inconnue = 1;
	MOVLW       1
	MOVWF       _position_inconnue+0 
;Ascenseur.c,854 :: 		goto fin_deplacement;
	GOTO        ___deplacer_vers_fin_deplacement
;Ascenseur.c,855 :: 		}
L_deplacer_vers293:
;Ascenseur.c,857 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers294
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers295
L_deplacer_vers294:
;Ascenseur.c,858 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers295:
;Ascenseur.c,859 :: 		}
L_deplacer_vers285:
;Ascenseur.c,797 :: 		for (i = 0; i < nb_et; i++) {
	INCF        deplacer_vers_i_L0+0, 1 
;Ascenseur.c,860 :: 		}
	GOTO        L_deplacer_vers263
L_deplacer_vers264:
;Ascenseur.c,862 :: 		fin_deplacement:
___deplacer_vers_fin_deplacement:
;Ascenseur.c,863 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,865 :: 		if ((urgence_flag || stop_demande) && entre_etages) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers515
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers515
	GOTO        L_deplacer_vers303
L__deplacer_vers515:
	MOVF        _entre_etages+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_deplacer_vers303
L__deplacer_vers514:
;Ascenseur.c,866 :: 		position_inconnue = 1;
	MOVLW       1
	MOVWF       _position_inconnue+0 
;Ascenseur.c,867 :: 		entre_etages = 0;
	CLRF        _entre_etages+0 
;Ascenseur.c,868 :: 		}
L_deplacer_vers303:
;Ascenseur.c,870 :: 		temps_trajet = timer0_count - temps_debut;
	MOVF        deplacer_vers_temps_debut_L0+0, 0 
	SUBWF       _timer0_count+0, 0 
	MOVWF       _temps_trajet+0 
	MOVF        deplacer_vers_temps_debut_L0+1, 0 
	SUBWFB      _timer0_count+1, 0 
	MOVWF       _temps_trajet+1 
;Ascenseur.c,871 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,872 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,873 :: 		etage_cible = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,874 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,876 :: 		if (!urgence_flag && !stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers306
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers306
L__deplacer_vers513:
;Ascenseur.c,877 :: 		position_inconnue = 0;
	CLRF        _position_inconnue+0 
;Ascenseur.c,878 :: 		}
L_deplacer_vers306:
;Ascenseur.c,880 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,881 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,882 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,883 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,885 :: 		if (!urgence_flag && !stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers309
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers309
L__deplacer_vers512:
;Ascenseur.c,886 :: 		eeprom_sauver_trajet();
	CALL        _eeprom_sauver_trajet+0, 0
;Ascenseur.c,887 :: 		attendre_ms(MS_OUVERTURE);
	MOVLW       100
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       0
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,888 :: 		}
L_deplacer_vers309:
;Ascenseur.c,890 :: 		stop_demande = 0;
	CLRF        _stop_demande+0 
;Ascenseur.c,891 :: 		}
L_end_deplacer_vers:
	RETURN      0
; end of _deplacer_vers

_parser_cmd:

;Ascenseur.c,893 :: 		void parser_cmd(char *buf) {
;Ascenseur.c,899 :: 		p = strstr(buf, "CALL:");
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
;Ascenseur.c,900 :: 		if (p) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd310
;Ascenseur.c,901 :: 		cible = (unsigned char)(*(p + 5) - '0');
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
;Ascenseur.c,902 :: 		if (cible < NB_ETAGES && mode_auto && !al_active && !surcharge_active) {
	MOVLW       4
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd313
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd313
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd313
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd313
L__parser_cmd536:
;Ascenseur.c,903 :: 		req[cible] = 1;
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
;Ascenseur.c,904 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,905 :: 		} else {
	GOTO        L_parser_cmd314
L_parser_cmd313:
;Ascenseur.c,906 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,907 :: 		}
L_parser_cmd314:
;Ascenseur.c,908 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,909 :: 		}
L_parser_cmd310:
;Ascenseur.c,911 :: 		if (strstr(buf, "CMD,STOP")) {
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
	GOTO        L_parser_cmd315
;Ascenseur.c,912 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,913 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,914 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,915 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,916 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,917 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,918 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,919 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,920 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,921 :: 		}
L_parser_cmd315:
;Ascenseur.c,923 :: 		if (strstr(buf, "CMD,ACK")) {
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
	GOTO        L_parser_cmd319
;Ascenseur.c,924 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_parser_cmd320
;Ascenseur.c,925 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,926 :: 		} else if (urg_active) {
	GOTO        L_parser_cmd321
L_parser_cmd320:
	MOVF        _urg_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd322
;Ascenseur.c,927 :: 		urg_active = 0;
	CLRF        _urg_active+0 
;Ascenseur.c,928 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,929 :: 		urgence_flag = 0;
	CLRF        _urgence_flag+0 
;Ascenseur.c,930 :: 		position_inconnue = 0;
	CLRF        _position_inconnue+0 
;Ascenseur.c,931 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,932 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,933 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,934 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,935 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,936 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,937 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,938 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,939 :: 		} else if (surcharge_active) {
	GOTO        L_parser_cmd323
L_parser_cmd322:
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd324
;Ascenseur.c,940 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,941 :: 		} else {
	GOTO        L_parser_cmd325
L_parser_cmd324:
;Ascenseur.c,942 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,943 :: 		}
L_parser_cmd325:
L_parser_cmd323:
L_parser_cmd321:
;Ascenseur.c,944 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,945 :: 		}
L_parser_cmd319:
;Ascenseur.c,947 :: 		if (strstr(buf, "MODE:AUTO")) {
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
	GOTO        L_parser_cmd326
;Ascenseur.c,948 :: 		mode_auto = 1;
	MOVLW       1
	MOVWF       _mode_auto+0 
;Ascenseur.c,949 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,950 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,951 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,952 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,953 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,954 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,955 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,956 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,957 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,958 :: 		}
L_parser_cmd326:
;Ascenseur.c,960 :: 		if (strstr(buf, "MODE:MAN")) {
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
	GOTO        L_parser_cmd327
;Ascenseur.c,961 :: 		mode_auto = 0;
	CLRF        _mode_auto+0 
;Ascenseur.c,962 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,963 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,964 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,965 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,966 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,967 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,968 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,969 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,970 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,971 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,972 :: 		}
L_parser_cmd327:
;Ascenseur.c,974 :: 		if (strstr(buf, "GET:EEP")) {
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
	GOTO        L_parser_cmd331
;Ascenseur.c,975 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,976 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,977 :: 		}
L_parser_cmd331:
;Ascenseur.c,979 :: 		if (strstr(buf, "EEP:RST") || strstr(buf, "RST:EEP")) {
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
	GOTO        L__parser_cmd535
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
	GOTO        L__parser_cmd535
	GOTO        L_parser_cmd334
L__parser_cmd535:
;Ascenseur.c,980 :: 		eeprom_reset();
	CALL        _eeprom_reset+0, 0
;Ascenseur.c,981 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,982 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,983 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,984 :: 		}
L_parser_cmd334:
;Ascenseur.c,987 :: 		char *pP = strstr(buf, "PMAX:");
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
;Ascenseur.c,988 :: 		char *pS = strstr(buf, "SPD:");
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
;Ascenseur.c,989 :: 		if (pP && pS) {
	MOVF        parser_cmd_pP_L1+0, 0 
	IORWF       parser_cmd_pP_L1+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd337
	MOVF        parser_cmd_pS_L1+0, 0 
	IORWF       parser_cmd_pS_L1+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd337
L__parser_cmd534:
;Ascenseur.c,990 :: 		pv = 0;
	CLRF        parser_cmd_pv_L0+0 
	CLRF        parser_cmd_pv_L0+1 
;Ascenseur.c,991 :: 		pP += 5;
	MOVLW       5
	ADDWF       parser_cmd_pP_L1+0, 1 
	MOVLW       0
	ADDWFC      parser_cmd_pP_L1+1, 1 
;Ascenseur.c,992 :: 		while (*pP >= '0' && *pP <= '9') {
L_parser_cmd338:
	MOVFF       parser_cmd_pP_L1+0, FSR0L+0
	MOVFF       parser_cmd_pP_L1+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd339
	MOVFF       parser_cmd_pP_L1+0, FSR0L+0
	MOVFF       parser_cmd_pP_L1+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd339
L__parser_cmd533:
;Ascenseur.c,993 :: 		pv = pv * 10 + (unsigned int)(*pP - '0');
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
;Ascenseur.c,994 :: 		pP++;
	INFSNZ      parser_cmd_pP_L1+0, 1 
	INCF        parser_cmd_pP_L1+1, 1 
;Ascenseur.c,995 :: 		}
	GOTO        L_parser_cmd338
L_parser_cmd339:
;Ascenseur.c,996 :: 		sv = 0;
	CLRF        parser_cmd_sv_L0+0 
;Ascenseur.c,997 :: 		pS += 4;
	MOVLW       4
	ADDWF       parser_cmd_pS_L1+0, 1 
	MOVLW       0
	ADDWFC      parser_cmd_pS_L1+1, 1 
;Ascenseur.c,998 :: 		while (*pS >= '0' && *pS <= '9') {
L_parser_cmd342:
	MOVFF       parser_cmd_pS_L1+0, FSR0L+0
	MOVFF       parser_cmd_pS_L1+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd343
	MOVFF       parser_cmd_pS_L1+0, FSR0L+0
	MOVFF       parser_cmd_pS_L1+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd343
L__parser_cmd532:
;Ascenseur.c,999 :: 		sv = sv * 10 + (unsigned char)(*pS - '0');
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
;Ascenseur.c,1000 :: 		pS++;
	INFSNZ      parser_cmd_pS_L1+0, 1 
	INCF        parser_cmd_pS_L1+1, 1 
;Ascenseur.c,1001 :: 		}
	GOTO        L_parser_cmd342
L_parser_cmd343:
;Ascenseur.c,1003 :: 		if (pv < 1)   pv = 1;
	MOVLW       0
	SUBWF       parser_cmd_pv_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd603
	MOVLW       1
	SUBWF       parser_cmd_pv_L0+0, 0 
L__parser_cmd603:
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd346
	MOVLW       1
	MOVWF       parser_cmd_pv_L0+0 
	MOVLW       0
	MOVWF       parser_cmd_pv_L0+1 
L_parser_cmd346:
;Ascenseur.c,1004 :: 		if (pv > 999) pv = 999;
	MOVF        parser_cmd_pv_L0+1, 0 
	SUBLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd604
	MOVF        parser_cmd_pv_L0+0, 0 
	SUBLW       231
L__parser_cmd604:
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd347
	MOVLW       231
	MOVWF       parser_cmd_pv_L0+0 
	MOVLW       3
	MOVWF       parser_cmd_pv_L0+1 
L_parser_cmd347:
;Ascenseur.c,1005 :: 		poids_max   = pv;
	MOVF        parser_cmd_pv_L0+0, 0 
	MOVWF       _poids_max+0 
	MOVF        parser_cmd_pv_L0+1, 0 
	MOVWF       _poids_max+1 
;Ascenseur.c,1006 :: 		seuil_surge = pv;
	MOVF        parser_cmd_pv_L0+0, 0 
	MOVWF       _seuil_surge+0 
	MOVF        parser_cmd_pv_L0+1, 0 
	MOVWF       _seuil_surge+1 
;Ascenseur.c,1008 :: 		if (sv > 100) sv = 100;
	MOVF        parser_cmd_sv_L0+0, 0 
	SUBLW       100
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd348
	MOVLW       100
	MOVWF       parser_cmd_sv_L0+0 
L_parser_cmd348:
;Ascenseur.c,1009 :: 		if (sv < 10)  sv = 10;
	MOVLW       10
	SUBWF       parser_cmd_sv_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd349
	MOVLW       10
	MOVWF       parser_cmd_sv_L0+0 
L_parser_cmd349:
;Ascenseur.c,1010 :: 		vitesse_max_pc = sv;
	MOVF        parser_cmd_sv_L0+0, 0 
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,1011 :: 		vitesse_eeprom = sv;
	MOVF        parser_cmd_sv_L0+0, 0 
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,1012 :: 		recalc_pwm_max();
	CALL        _recalc_pwm_max+0, 0
;Ascenseur.c,1013 :: 		eep_write_byte(0x03, vitesse_eeprom);
	MOVLW       3
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        _vitesse_eeprom+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,1014 :: 		if (moteur_actif) set_pwm(pwm_max_eff);
	MOVF        _moteur_actif+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd350
	MOVF        _pwm_max_eff+0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
L_parser_cmd350:
;Ascenseur.c,1016 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1017 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1018 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1019 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1020 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1021 :: 		}
L_parser_cmd337:
;Ascenseur.c,1024 :: 		p = strstr(buf, "PMAX:");
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
;Ascenseur.c,1025 :: 		if (p) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd351
;Ascenseur.c,1026 :: 		pv = 0;
	CLRF        parser_cmd_pv_L0+0 
	CLRF        parser_cmd_pv_L0+1 
;Ascenseur.c,1027 :: 		p += 5;
	MOVLW       5
	ADDWF       parser_cmd_p_L0+0, 1 
	MOVLW       0
	ADDWFC      parser_cmd_p_L0+1, 1 
;Ascenseur.c,1028 :: 		while (*p >= '0' && *p <= '9') {
L_parser_cmd352:
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd353
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd353
L__parser_cmd531:
;Ascenseur.c,1029 :: 		pv = pv * 10 + (unsigned int)(*p - '0');
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
;Ascenseur.c,1030 :: 		p++;
	INFSNZ      parser_cmd_p_L0+0, 1 
	INCF        parser_cmd_p_L0+1, 1 
;Ascenseur.c,1031 :: 		}
	GOTO        L_parser_cmd352
L_parser_cmd353:
;Ascenseur.c,1032 :: 		appliquer_pmax(pv);
	MOVF        parser_cmd_pv_L0+0, 0 
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVF        parser_cmd_pv_L0+1, 0 
	MOVWF       FARG_appliquer_pmax_val+1 
	CALL        _appliquer_pmax+0, 0
;Ascenseur.c,1033 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1034 :: 		}
L_parser_cmd351:
;Ascenseur.c,1036 :: 		p = strstr(buf, "SPD:");
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
;Ascenseur.c,1037 :: 		if (p) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd356
;Ascenseur.c,1038 :: 		sv = 0;
	CLRF        parser_cmd_sv_L0+0 
;Ascenseur.c,1039 :: 		p += 4;
	MOVLW       4
	ADDWF       parser_cmd_p_L0+0, 1 
	MOVLW       0
	ADDWFC      parser_cmd_p_L0+1, 1 
;Ascenseur.c,1040 :: 		while (*p >= '0' && *p <= '9') {
L_parser_cmd357:
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd358
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd358
L__parser_cmd530:
;Ascenseur.c,1041 :: 		sv = sv * 10 + (unsigned char)(*p - '0');
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
;Ascenseur.c,1042 :: 		p++;
	INFSNZ      parser_cmd_p_L0+0, 1 
	INCF        parser_cmd_p_L0+1, 1 
;Ascenseur.c,1043 :: 		}
	GOTO        L_parser_cmd357
L_parser_cmd358:
;Ascenseur.c,1044 :: 		appliquer_spd(sv);
	MOVF        parser_cmd_sv_L0+0, 0 
	MOVWF       FARG_appliquer_spd_val+0 
	CALL        _appliquer_spd+0, 0
;Ascenseur.c,1045 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1046 :: 		}
L_parser_cmd356:
;Ascenseur.c,1048 :: 		if (strstr(buf, "DOOR:O")) {
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
	GOTO        L_parser_cmd361
;Ascenseur.c,1049 :: 		if (!mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd362
;Ascenseur.c,1050 :: 		porte_cmd = 1;
	MOVLW       1
	MOVWF       _porte_cmd+0 
;Ascenseur.c,1051 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,1052 :: 		if (!moteur_actif) lcd_transition();
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd363
	CALL        _lcd_transition+0, 0
L_parser_cmd363:
;Ascenseur.c,1053 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1054 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1055 :: 		} else {
	GOTO        L_parser_cmd364
L_parser_cmd362:
;Ascenseur.c,1056 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1057 :: 		}
L_parser_cmd364:
;Ascenseur.c,1058 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1059 :: 		}
L_parser_cmd361:
;Ascenseur.c,1061 :: 		if (strstr(buf, "DOOR:F")) {
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
	GOTO        L_parser_cmd365
;Ascenseur.c,1062 :: 		if (!mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd366
;Ascenseur.c,1063 :: 		porte_cmd = 0;
	CLRF        _porte_cmd+0 
;Ascenseur.c,1064 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,1065 :: 		if (!moteur_actif) lcd_transition();
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd367
	CALL        _lcd_transition+0, 0
L_parser_cmd367:
;Ascenseur.c,1066 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1067 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1068 :: 		} else {
	GOTO        L_parser_cmd368
L_parser_cmd366:
;Ascenseur.c,1069 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1070 :: 		}
L_parser_cmd368:
;Ascenseur.c,1071 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1072 :: 		}
L_parser_cmd365:
;Ascenseur.c,1074 :: 		if (strstr(buf, "MOT:UP")) {
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
	GOTO        L_parser_cmd369
;Ascenseur.c,1075 :: 		if (!mode_auto && !urg_active && !al_active && !surcharge_active) {
	MOVF        _mode_auto+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd372
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd372
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd372
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd372
L__parser_cmd529:
;Ascenseur.c,1076 :: 		if (moteur_actif || en_mouvement) {
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd528
	MOVF        _en_mouvement+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd528
	GOTO        L_parser_cmd375
L__parser_cmd528:
;Ascenseur.c,1077 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1078 :: 		} else if (etage_actuel >= NB_ETAGES - 1) {
	GOTO        L_parser_cmd376
L_parser_cmd375:
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd605
	MOVLW       3
	SUBWF       _etage_actuel+0, 0 
L__parser_cmd605:
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd377
;Ascenseur.c,1079 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1080 :: 		} else {
	GOTO        L_parser_cmd378
L_parser_cmd377:
;Ascenseur.c,1081 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1082 :: 		deplacer_vers(etage_actuel + 1);
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,1083 :: 		}
L_parser_cmd378:
L_parser_cmd376:
;Ascenseur.c,1084 :: 		} else {
	GOTO        L_parser_cmd379
L_parser_cmd372:
;Ascenseur.c,1085 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1086 :: 		}
L_parser_cmd379:
;Ascenseur.c,1087 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1088 :: 		}
L_parser_cmd369:
;Ascenseur.c,1090 :: 		if (strstr(buf, "MOT:DWN")) {
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
	GOTO        L_parser_cmd380
;Ascenseur.c,1091 :: 		if (!mode_auto && !urg_active && !al_active && !surcharge_active) {
	MOVF        _mode_auto+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd383
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd383
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd383
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd383
L__parser_cmd527:
;Ascenseur.c,1092 :: 		if (moteur_actif || en_mouvement) {
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd526
	MOVF        _en_mouvement+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd526
	GOTO        L_parser_cmd386
L__parser_cmd526:
;Ascenseur.c,1093 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1094 :: 		} else if (etage_actuel == 0) {
	GOTO        L_parser_cmd387
L_parser_cmd386:
	MOVF        _etage_actuel+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd388
;Ascenseur.c,1095 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1096 :: 		} else {
	GOTO        L_parser_cmd389
L_parser_cmd388:
;Ascenseur.c,1097 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1098 :: 		deplacer_vers(etage_actuel - 1);
	DECF        _etage_actuel+0, 0 
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,1099 :: 		}
L_parser_cmd389:
L_parser_cmd387:
;Ascenseur.c,1100 :: 		} else {
	GOTO        L_parser_cmd390
L_parser_cmd383:
;Ascenseur.c,1101 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1102 :: 		}
L_parser_cmd390:
;Ascenseur.c,1103 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1104 :: 		}
L_parser_cmd380:
;Ascenseur.c,1106 :: 		if (strstr(buf, "MOT:STP") || strstr(buf, "MOT:STOP")) {
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
	GOTO        L__parser_cmd525
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
	GOTO        L__parser_cmd525
	GOTO        L_parser_cmd393
L__parser_cmd525:
;Ascenseur.c,1107 :: 		if (!mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd394
;Ascenseur.c,1108 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1109 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1110 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1111 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1112 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1113 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1114 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1115 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1116 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1117 :: 		} else {
	GOTO        L_parser_cmd398
L_parser_cmd394:
;Ascenseur.c,1118 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1119 :: 		}
L_parser_cmd398:
;Ascenseur.c,1120 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1121 :: 		}
L_parser_cmd393:
;Ascenseur.c,1123 :: 		if (strstr(buf, "AL:ON")) {
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
	GOTO        L_parser_cmd399
;Ascenseur.c,1124 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,1125 :: 		al_flag = 1;
	MOVLW       1
	MOVWF       _al_flag+0 
;Ascenseur.c,1126 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1127 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1128 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1129 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1130 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1131 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1132 :: 		}
L_parser_cmd399:
;Ascenseur.c,1134 :: 		if (strstr(buf, "RST:AL")) {
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
	GOTO        L_parser_cmd403
;Ascenseur.c,1135 :: 		if (!urg_active) {
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd404
;Ascenseur.c,1136 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1137 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1138 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1139 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1140 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1141 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1142 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,1143 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1144 :: 		} else {
	GOTO        L_parser_cmd405
L_parser_cmd404:
;Ascenseur.c,1145 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1146 :: 		}
L_parser_cmd405:
;Ascenseur.c,1147 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,1148 :: 		}
L_parser_cmd403:
;Ascenseur.c,1150 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,1151 :: 		}
L_end_parser_cmd:
	RETURN      0
; end of _parser_cmd

_init_timer1:

;Ascenseur.c,1153 :: 		void init_timer1() {
;Ascenseur.c,1154 :: 		T1CON = 0x00;
	CLRF        T1CON+0 
;Ascenseur.c,1155 :: 		TMR1H = 0xFE;
	MOVLW       254
	MOVWF       TMR1H+0 
;Ascenseur.c,1156 :: 		TMR1L = 0x0C;
	MOVLW       12
	MOVWF       TMR1L+0 
;Ascenseur.c,1157 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Ascenseur.c,1158 :: 		TMR1IE_bit = 1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;Ascenseur.c,1159 :: 		TMR1ON_bit = 1;
	BSF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;Ascenseur.c,1160 :: 		}
L_end_init_timer1:
	RETURN      0
; end of _init_timer1

_main:

;Ascenseur.c,1162 :: 		void main() {
;Ascenseur.c,1167 :: 		PWM1_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;Ascenseur.c,1168 :: 		PWM1_Set_Duty(0);
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,1169 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;Ascenseur.c,1171 :: 		ANSELA = 0x02;
	MOVLW       2
	MOVWF       ANSELA+0 
;Ascenseur.c,1172 :: 		TRISA0_bit = 1;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Ascenseur.c,1173 :: 		TRISA1_bit = 1;
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,1174 :: 		TRISA2_bit = 0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;Ascenseur.c,1175 :: 		TRISA3_bit = 0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;Ascenseur.c,1176 :: 		LATA2_bit = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;Ascenseur.c,1177 :: 		LATA3_bit = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1179 :: 		ANSELB = 0x00;
	CLRF        ANSELB+0 
;Ascenseur.c,1180 :: 		TRISB6_bit = 1;
	BSF         TRISB6_bit+0, BitPos(TRISB6_bit+0) 
;Ascenseur.c,1181 :: 		TRISB7_bit = 1;
	BSF         TRISB7_bit+0, BitPos(TRISB7_bit+0) 
;Ascenseur.c,1182 :: 		INTCON2.RBPU = 1;
	BSF         INTCON2+0, 7 
;Ascenseur.c,1184 :: 		ANSELC = 0x00;
	CLRF        ANSELC+0 
;Ascenseur.c,1185 :: 		TRISC0_bit = 0;
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;Ascenseur.c,1186 :: 		TRISC1_bit = 0;
	BCF         TRISC1_bit+0, BitPos(TRISC1_bit+0) 
;Ascenseur.c,1187 :: 		TRISC2_bit = 0;
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;Ascenseur.c,1188 :: 		TRISC3_bit = 0;
	BCF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;Ascenseur.c,1189 :: 		TRISC4_bit = 1;
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;Ascenseur.c,1190 :: 		TRISC5_bit = 0;
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;Ascenseur.c,1191 :: 		TRISC6_bit = 0;
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;Ascenseur.c,1192 :: 		TRISC7_bit = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;Ascenseur.c,1193 :: 		LATC0_bit = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;Ascenseur.c,1194 :: 		LATC1_bit = 0;
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;Ascenseur.c,1195 :: 		LATC5_bit = 0;
	BCF         LATC5_bit+0, BitPos(LATC5_bit+0) 
;Ascenseur.c,1197 :: 		ANSELD = 0x00;
	CLRF        ANSELD+0 
;Ascenseur.c,1198 :: 		TRISD = 0xFF;
	MOVLW       255
	MOVWF       TRISD+0 
;Ascenseur.c,1200 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;Ascenseur.c,1201 :: 		ANSELA = 0x02;
	MOVLW       2
	MOVWF       ANSELA+0 
;Ascenseur.c,1202 :: 		TRISA0_bit = 1;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Ascenseur.c,1203 :: 		TRISA1_bit = 1;
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,1205 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Ascenseur.c,1206 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main406:
	DECFSZ      R13, 1, 1
	BRA         L_main406
	DECFSZ      R12, 1, 1
	BRA         L_main406
	DECFSZ      R11, 1, 1
	BRA         L_main406
	NOP
;Ascenseur.c,1208 :: 		I2C1_Init(100000);
	MOVLW       20
	MOVWF       SSP1ADD+0 
	CALL        _I2C1_Init+0, 0
;Ascenseur.c,1209 :: 		Delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_main407:
	DECFSZ      R13, 1, 1
	BRA         L_main407
	DECFSZ      R12, 1, 1
	BRA         L_main407
	NOP
;Ascenseur.c,1211 :: 		eeprom_charger();
	CALL        _eeprom_charger+0, 0
;Ascenseur.c,1213 :: 		T0CON = 0x07;
	MOVLW       7
	MOVWF       T0CON+0 
;Ascenseur.c,1214 :: 		TMR0H = T0_RELOAD_H;
	MOVLW       194
	MOVWF       TMR0H+0 
;Ascenseur.c,1215 :: 		TMR0L = T0_RELOAD_L;
	MOVLW       247
	MOVWF       TMR0L+0 
;Ascenseur.c,1216 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Ascenseur.c,1217 :: 		TMR0IE_bit = 1;
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;Ascenseur.c,1219 :: 		init_timer1();
	CALL        _init_timer1+0, 0
;Ascenseur.c,1221 :: 		RC1IE_bit = 1;
	BSF         RC1IE_bit+0, BitPos(RC1IE_bit+0) 
;Ascenseur.c,1222 :: 		PEIE_bit = 1;
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;Ascenseur.c,1223 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,1224 :: 		T0CON = 0x87;
	MOVLW       135
	MOVWF       T0CON+0 
;Ascenseur.c,1226 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;Ascenseur.c,1227 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1228 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1229 :: 		Lcd_Out(1, 1, " ASCENSEUR 4ET  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr43_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr43_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1230 :: 		Lcd_Out(2, 1, "  Pret  - ET:0  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr44_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr44_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1231 :: 		Delay_ms(1500);
	MOVLW       16
	MOVWF       R11, 0
	MOVLW       57
	MOVWF       R12, 0
	MOVLW       13
	MOVWF       R13, 0
L_main408:
	DECFSZ      R13, 1, 1
	BRA         L_main408
	DECFSZ      R12, 1, 1
	BRA         L_main408
	DECFSZ      R11, 1, 1
	BRA         L_main408
	NOP
	NOP
;Ascenseur.c,1232 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1234 :: 		UART1_Write_Text("<DATA,ET:0,DIR:0,PT:0,PRT:0,AL:0,URG:0,NB:0,PWM:0,TPS:0>\r\n");
	MOVLW       ?lstr45_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr45_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,1236 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1237 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1238 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1240 :: 		while (1) {
L_main409:
;Ascenseur.c,1242 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main413
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main413
L__main542:
;Ascenseur.c,1243 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main414:
	DECFSZ      R13, 1, 1
	BRA         L_main414
	DECFSZ      R12, 1, 1
	BRA         L_main414
	NOP
	NOP
;Ascenseur.c,1244 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main415
;Ascenseur.c,1245 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1246 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1247 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1248 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,1249 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1250 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,1251 :: 		}
L_main415:
;Ascenseur.c,1252 :: 		}
L_main413:
;Ascenseur.c,1254 :: 		if (urgence_flag) {
	MOVF        _urgence_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main419
;Ascenseur.c,1255 :: 		urgence_flag = 0;
	CLRF        _urgence_flag+0 
;Ascenseur.c,1256 :: 		etat_surcharge = 0;
	CLRF        _etat_surcharge+0 
;Ascenseur.c,1257 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1258 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1259 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1260 :: 		vider_req();
	CALL        _vider_req+0, 0
;Ascenseur.c,1262 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1263 :: 		Lcd_Out(1, 1, " ARRET URGENCE  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr46_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr46_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1264 :: 		if (position_inconnue) Lcd_Out(2, 1, "POS?-ACQ:BP/PC  ");
	MOVF        _position_inconnue+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main423
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr47_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr47_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_main424
L_main423:
;Ascenseur.c,1265 :: 		else                   Lcd_Out(2, 1, "ACQ : BP ou PC  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr48_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr48_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_main424:
;Ascenseur.c,1267 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1268 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1269 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1272 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L3+0 
;Ascenseur.c,1273 :: 		while (acq_recu == 0) {
L_main425:
	MOVF        main_acq_recu_L3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main426
;Ascenseur.c,1274 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main427:
	DECFSZ      R13, 1, 1
	BRA         L_main427
	DECFSZ      R12, 1, 1
	BRA         L_main427
	NOP
	NOP
;Ascenseur.c,1275 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main428
;Ascenseur.c,1276 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1277 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1278 :: 		}
L_main428:
;Ascenseur.c,1280 :: 		if (BP_ACQ && !BP_URGENCE) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main431
	BTFSC       PORTB+0, 6 
	GOTO        L_main431
L__main541:
;Ascenseur.c,1281 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main432:
	DECFSZ      R13, 1, 1
	BRA         L_main432
	DECFSZ      R12, 1, 1
	BRA         L_main432
	NOP
	NOP
;Ascenseur.c,1282 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3+0 
;Ascenseur.c,1283 :: 		}
L_main431:
;Ascenseur.c,1285 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main433
;Ascenseur.c,1286 :: 		if (strstr(cmd, "CMD,ACK") && !BP_URGENCE)
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
	GOTO        L_main436
	BTFSC       PORTB+0, 6 
	GOTO        L_main436
L__main540:
;Ascenseur.c,1287 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3+0 
L_main436:
;Ascenseur.c,1288 :: 		}
L_main433:
;Ascenseur.c,1289 :: 		}
	GOTO        L_main425
L_main426:
;Ascenseur.c,1290 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main437:
	DECFSZ      R13, 1, 1
	BRA         L_main437
	DECFSZ      R12, 1, 1
	BRA         L_main437
	DECFSZ      R11, 1, 1
	BRA         L_main437
;Ascenseur.c,1293 :: 		urg_active = 0;
	CLRF        _urg_active+0 
;Ascenseur.c,1294 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1295 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1296 :: 		position_inconnue = 0;
	CLRF        _position_inconnue+0 
;Ascenseur.c,1297 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1298 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1299 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1301 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1302 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1303 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1304 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1305 :: 		}
L_main419:
;Ascenseur.c,1307 :: 		if (al_flag) {
	MOVF        _al_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main438
;Ascenseur.c,1308 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1309 :: 		vider_req();
	CALL        _vider_req+0, 0
;Ascenseur.c,1311 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1312 :: 		Lcd_Out(1, 1, "   ALARME !!!   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr50_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr50_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1313 :: 		Lcd_Out(2, 1, "ACQ : BP ou PC  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr51_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr51_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1314 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1317 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L3_L3+0 
;Ascenseur.c,1318 :: 		while (acq_recu == 0) {
L_main439:
	MOVF        main_acq_recu_L3_L3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main440
;Ascenseur.c,1319 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main441:
	DECFSZ      R13, 1, 1
	BRA         L_main441
	DECFSZ      R12, 1, 1
	BRA         L_main441
	NOP
	NOP
;Ascenseur.c,1320 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main442
;Ascenseur.c,1321 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1322 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1323 :: 		}
L_main442:
;Ascenseur.c,1324 :: 		if (BP_ACQ) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main443
;Ascenseur.c,1325 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main444:
	DECFSZ      R13, 1, 1
	BRA         L_main444
	DECFSZ      R12, 1, 1
	BRA         L_main444
	NOP
	NOP
;Ascenseur.c,1326 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3_L3+0 
;Ascenseur.c,1327 :: 		}
L_main443:
;Ascenseur.c,1328 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main445
;Ascenseur.c,1329 :: 		if (strstr(cmd, "RST:AL"))
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
	GOTO        L_main446
;Ascenseur.c,1330 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3_L3+0 
L_main446:
;Ascenseur.c,1331 :: 		}
L_main445:
;Ascenseur.c,1332 :: 		}
	GOTO        L_main439
L_main440:
;Ascenseur.c,1333 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main447:
	DECFSZ      R13, 1, 1
	BRA         L_main447
	DECFSZ      R12, 1, 1
	BRA         L_main447
	DECFSZ      R11, 1, 1
	BRA         L_main447
;Ascenseur.c,1336 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1337 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1338 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1339 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1340 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1341 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1342 :: 		}
L_main438:
;Ascenseur.c,1344 :: 		if (BP_ALARME && !al_active) {
	BTFSS       PORTB+0, 7 
	GOTO        L_main450
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main450
L__main539:
;Ascenseur.c,1345 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main451:
	DECFSZ      R13, 1, 1
	BRA         L_main451
	DECFSZ      R12, 1, 1
	BRA         L_main451
	NOP
	NOP
;Ascenseur.c,1346 :: 		if (BP_ALARME) {
	BTFSS       PORTB+0, 7 
	GOTO        L_main452
;Ascenseur.c,1347 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,1348 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1349 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1350 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1351 :: 		vider_req();
	CALL        _vider_req+0, 0
;Ascenseur.c,1353 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1354 :: 		Lcd_Out(1, 1, "   ALARME !!!   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr53_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr53_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1355 :: 		Lcd_Out(2, 1, "ACQ : BP ou PC  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr54_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr54_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1356 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1359 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L4+0 
;Ascenseur.c,1360 :: 		while (acq_recu == 0) {
L_main456:
	MOVF        main_acq_recu_L4+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main457
;Ascenseur.c,1361 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main458:
	DECFSZ      R13, 1, 1
	BRA         L_main458
	DECFSZ      R12, 1, 1
	BRA         L_main458
	NOP
	NOP
;Ascenseur.c,1362 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main459
;Ascenseur.c,1363 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1364 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1365 :: 		}
L_main459:
;Ascenseur.c,1366 :: 		if (BP_ACQ) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main460
;Ascenseur.c,1367 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main461:
	DECFSZ      R13, 1, 1
	BRA         L_main461
	DECFSZ      R12, 1, 1
	BRA         L_main461
	NOP
	NOP
;Ascenseur.c,1368 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L4+0 
;Ascenseur.c,1369 :: 		}
L_main460:
;Ascenseur.c,1370 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main462
;Ascenseur.c,1371 :: 		if (strstr(cmd, "RST:AL"))
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
	GOTO        L_main463
;Ascenseur.c,1372 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L4+0 
L_main463:
;Ascenseur.c,1373 :: 		}
L_main462:
;Ascenseur.c,1374 :: 		}
	GOTO        L_main456
L_main457:
;Ascenseur.c,1375 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main464:
	DECFSZ      R13, 1, 1
	BRA         L_main464
	DECFSZ      R12, 1, 1
	BRA         L_main464
	DECFSZ      R11, 1, 1
	BRA         L_main464
;Ascenseur.c,1378 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1379 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1380 :: 		etat_surcharge = 0xFF;
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
L_main452:
;Ascenseur.c,1386 :: 		}
L_main450:
;Ascenseur.c,1388 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1389 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1391 :: 		while (pop_cmd(cmd)) {
L_main465:
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main466
;Ascenseur.c,1392 :: 		parser_cmd(cmd);
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_parser_cmd_buf+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_parser_cmd_buf+1 
	CALL        _parser_cmd+0, 0
;Ascenseur.c,1393 :: 		}
	GOTO        L_main465
L_main466:
;Ascenseur.c,1395 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,1397 :: 		if (!urg_active && !al_active) {
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main469
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main469
L__main538:
;Ascenseur.c,1398 :: 		surge_now = surcharge_active ? 1 : 0;
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main470
	MOVLW       1
	MOVWF       ?FLOC___mainT661+0 
	GOTO        L_main471
L_main470:
	CLRF        ?FLOC___mainT661+0 
L_main471:
	MOVF        ?FLOC___mainT661+0, 0 
	MOVWF       main_surge_now_L0+0 
;Ascenseur.c,1399 :: 		if (surge_now != etat_surcharge) {
	MOVF        ?FLOC___mainT661+0, 0 
	XORWF       _etat_surcharge+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main472
;Ascenseur.c,1400 :: 		etat_surcharge = surge_now;
	MOVF        main_surge_now_L0+0, 0 
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1401 :: 		if (!moteur_actif) lcd_transition();
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main473
	CALL        _lcd_transition+0, 0
L_main473:
;Ascenseur.c,1402 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1403 :: 		}
L_main472:
;Ascenseur.c,1404 :: 		}
L_main469:
;Ascenseur.c,1406 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main474
;Ascenseur.c,1407 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1408 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1409 :: 		if (moteur_actif) lcd_update_transit();
	MOVF        _moteur_actif+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main475
	CALL        _lcd_update_transit+0, 0
	GOTO        L_main476
L_main475:
;Ascenseur.c,1410 :: 		else              afficher_lcd();
	CALL        _afficher_lcd+0, 0
L_main476:
;Ascenseur.c,1411 :: 		}
L_main474:
;Ascenseur.c,1413 :: 		if (mode_auto && !urg_active && !al_active && !position_inconnue) {
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main479
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main479
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main479
	MOVF        _position_inconnue+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main479
L__main537:
;Ascenseur.c,1414 :: 		if (!surcharge_active) {
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main480
;Ascenseur.c,1415 :: 		scanner_req();
	CALL        _scanner_req+0, 0
;Ascenseur.c,1416 :: 		prochain = prochain_req();
	CALL        _prochain_req+0, 0
	MOVF        R0, 0 
	MOVWF       main_prochain_L0+0 
;Ascenseur.c,1418 :: 		if (prochain != 0xFF) {
	MOVF        R0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_main481
;Ascenseur.c,1419 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1420 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1422 :: 		if (ir_porte == 1) {
	MOVF        _ir_porte+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main482
;Ascenseur.c,1423 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1424 :: 		Lcd_Out(1, 1, "PORTE OUVERTE!  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr56_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr56_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1425 :: 		Lcd_Out(2, 1, "Veuillez fermer ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr57_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr57_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1426 :: 		Delay_ms(2000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main483:
	DECFSZ      R13, 1, 1
	BRA         L_main483
	DECFSZ      R12, 1, 1
	BRA         L_main483
	DECFSZ      R11, 1, 1
	BRA         L_main483
	NOP
;Ascenseur.c,1427 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1428 :: 		}
	GOTO        L_main484
L_main482:
;Ascenseur.c,1429 :: 		else if (surcharge_active) {
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main485
;Ascenseur.c,1430 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1431 :: 		}
	GOTO        L_main486
L_main485:
;Ascenseur.c,1433 :: 		deplacer_vers(prochain);
	MOVF        main_prochain_L0+0, 0 
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,1434 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1435 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1436 :: 		}
L_main486:
L_main484:
;Ascenseur.c,1437 :: 		}
L_main481:
;Ascenseur.c,1438 :: 		}
L_main480:
;Ascenseur.c,1439 :: 		}
L_main479:
;Ascenseur.c,1441 :: 		if (!moteur_actif) afficher_lcd();
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main487
	CALL        _afficher_lcd+0, 0
L_main487:
;Ascenseur.c,1442 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main488:
	DECFSZ      R13, 1, 1
	BRA         L_main488
	DECFSZ      R12, 1, 1
	BRA         L_main488
	NOP
	NOP
;Ascenseur.c,1443 :: 		}
	GOTO        L_main409
;Ascenseur.c,1444 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
