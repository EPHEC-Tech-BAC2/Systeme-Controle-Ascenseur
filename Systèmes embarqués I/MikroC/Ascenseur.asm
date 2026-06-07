
_interrupt:

;Ascenseur.c,160 :: 		void interrupt() {
;Ascenseur.c,163 :: 		if (TMR0IE_bit && TMR0IF_bit) {
	BTFSS       TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
	GOTO        L_interrupt2
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt2
L__interrupt417:
;Ascenseur.c,164 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Ascenseur.c,165 :: 		TMR0H = T0_RELOAD_H;
	MOVLW       194
	MOVWF       TMR0H+0 
;Ascenseur.c,166 :: 		TMR0L = T0_RELOAD_L;
	MOVLW       247
	MOVWF       TMR0L+0 
;Ascenseur.c,167 :: 		timer0_flag = 1;
	MOVLW       1
	MOVWF       _timer0_flag+0 
;Ascenseur.c,168 :: 		timer0_count++;
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
;Ascenseur.c,169 :: 		}
L_interrupt2:
;Ascenseur.c,171 :: 		if (TMR1IE_bit && TMR1IF_bit) {
	BTFSS       TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
	GOTO        L_interrupt5
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt5
L__interrupt416:
;Ascenseur.c,172 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Ascenseur.c,173 :: 		TMR1H = 0xFE;
	MOVLW       254
	MOVWF       TMR1H+0 
;Ascenseur.c,174 :: 		TMR1L = 0x0C;
	MOVLW       12
	MOVWF       TMR1L+0 
;Ascenseur.c,175 :: 		if (al_active) BUZZER = ~BUZZER;
	MOVF        _al_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt6
	BTG         LATC5_bit+0, BitPos(LATC5_bit+0) 
	GOTO        L_interrupt7
L_interrupt6:
;Ascenseur.c,176 :: 		else           BUZZER = 0;
	BCF         LATC5_bit+0, BitPos(LATC5_bit+0) 
L_interrupt7:
;Ascenseur.c,177 :: 		}
L_interrupt5:
;Ascenseur.c,179 :: 		if (RC1IE_bit && RC1IF_bit) {
	BTFSS       RC1IE_bit+0, BitPos(RC1IE_bit+0) 
	GOTO        L_interrupt10
	BTFSS       RC1IF_bit+0, BitPos(RC1IF_bit+0) 
	GOTO        L_interrupt10
L__interrupt415:
;Ascenseur.c,184 :: 		if (OERR1_bit) {
	BTFSS       OERR1_bit+0, BitPos(OERR1_bit+0) 
	GOTO        L_interrupt11
;Ascenseur.c,185 :: 		CREN1_bit = 0;
	BCF         CREN1_bit+0, BitPos(CREN1_bit+0) 
;Ascenseur.c,186 :: 		CREN1_bit = 1;
	BSF         CREN1_bit+0, BitPos(CREN1_bit+0) 
;Ascenseur.c,187 :: 		}
L_interrupt11:
;Ascenseur.c,189 :: 		c = RCREG1;
	MOVF        RCREG1+0, 0 
	MOVWF       interrupt_c_L0+0 
;Ascenseur.c,191 :: 		if (c == '<') {
	MOVF        interrupt_c_L0+0, 0 
	XORLW       60
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt12
;Ascenseur.c,192 :: 		rx_idx = 0;
	CLRF        _rx_idx+0 
;Ascenseur.c,193 :: 		}
L_interrupt12:
;Ascenseur.c,195 :: 		if (rx_idx < 48) {
	MOVLW       48
	SUBWF       _rx_idx+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt13
;Ascenseur.c,196 :: 		rx_buf[rx_idx++] = c;
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
;Ascenseur.c,197 :: 		}
L_interrupt13:
;Ascenseur.c,199 :: 		if (c == '>') {
	MOVF        interrupt_c_L0+0, 0 
	XORLW       62
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
;Ascenseur.c,200 :: 		if (rx_idx >= 5 && rx_buf[0] == '<') {
	MOVLW       5
	SUBWF       _rx_idx+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt17
	MOVF        _rx_buf+0, 0 
	XORLW       60
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt17
L__interrupt414:
;Ascenseur.c,201 :: 		nxt = (unsigned char)((cmd_qtail + 1) & (CMD_QSIZE - 1));
	MOVF        _cmd_qtail+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVLW       3
	ANDWF       R0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       interrupt_nxt_L1+0 
;Ascenseur.c,202 :: 		if (nxt != cmd_qhead) {
	MOVF        R1, 0 
	XORWF       _cmd_qhead+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt18
;Ascenseur.c,203 :: 		n = rx_idx;
	MOVF        _rx_idx+0, 0 
	MOVWF       interrupt_n_L1+0 
;Ascenseur.c,204 :: 		if (n > (CMD_QLEN - 2)) n = CMD_QLEN - 2;
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt459
	MOVF        interrupt_n_L1+0, 0 
	SUBLW       38
L__interrupt459:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt19
	MOVLW       38
	MOVWF       interrupt_n_L1+0 
L_interrupt19:
;Ascenseur.c,205 :: 		for (j = 0; j < n; j++)
	CLRF        interrupt_j_L1+0 
L_interrupt20:
	MOVF        interrupt_n_L1+0, 0 
	SUBWF       interrupt_j_L1+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt21
;Ascenseur.c,206 :: 		cmd_queue[cmd_qtail][j] = rx_buf[j];
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
;Ascenseur.c,205 :: 		for (j = 0; j < n; j++)
	INCF        interrupt_j_L1+0, 1 
;Ascenseur.c,206 :: 		cmd_queue[cmd_qtail][j] = rx_buf[j];
	GOTO        L_interrupt20
L_interrupt21:
;Ascenseur.c,207 :: 		cmd_queue[cmd_qtail][n] = '\0';
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
;Ascenseur.c,208 :: 		cmd_qtail = nxt;
	MOVF        interrupt_nxt_L1+0, 0 
	MOVWF       _cmd_qtail+0 
;Ascenseur.c,209 :: 		}
L_interrupt18:
;Ascenseur.c,210 :: 		}
L_interrupt17:
;Ascenseur.c,211 :: 		rx_idx = 0;
	CLRF        _rx_idx+0 
;Ascenseur.c,212 :: 		}
L_interrupt14:
;Ascenseur.c,213 :: 		}
L_interrupt10:
;Ascenseur.c,214 :: 		}
L_end_interrupt:
L__interrupt458:
	RETFIE      1
; end of _interrupt

_eep_write_byte:

;Ascenseur.c,216 :: 		void eep_write_byte(unsigned char addr, unsigned char val) {
;Ascenseur.c,217 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Ascenseur.c,218 :: 		I2C1_Wr(EEPROM_W);
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,219 :: 		I2C1_Wr(addr);
	MOVF        FARG_eep_write_byte_addr+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,220 :: 		I2C1_Wr(val);
	MOVF        FARG_eep_write_byte_val+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,221 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Ascenseur.c,222 :: 		Delay_ms(10);
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
;Ascenseur.c,223 :: 		}
L_end_eep_write_byte:
	RETURN      0
; end of _eep_write_byte

_eep_read_byte:

;Ascenseur.c,225 :: 		unsigned char eep_read_byte(unsigned char addr) {
;Ascenseur.c,227 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Ascenseur.c,228 :: 		I2C1_Wr(EEPROM_W);
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,229 :: 		I2C1_Wr(addr);
	MOVF        FARG_eep_read_byte_addr+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,230 :: 		I2C1_Repeated_Start();
	CALL        _I2C1_Repeated_Start+0, 0
;Ascenseur.c,231 :: 		I2C1_Wr(EEPROM_R);
	MOVLW       161
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,232 :: 		val = I2C1_Rd(0);
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       eep_read_byte_val_L0+0 
;Ascenseur.c,233 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Ascenseur.c,234 :: 		return val;
	MOVF        eep_read_byte_val_L0+0, 0 
	MOVWF       R0 
;Ascenseur.c,235 :: 		}
L_end_eep_read_byte:
	RETURN      0
; end of _eep_read_byte

_eep_write_word:

;Ascenseur.c,237 :: 		void eep_write_word(unsigned char addr, unsigned int val) {
;Ascenseur.c,238 :: 		eep_write_byte(addr,     (unsigned char)(val >> 8));
	MOVF        FARG_eep_write_word_addr+0, 0 
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        FARG_eep_write_word_val+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,239 :: 		eep_write_byte(addr + 1, (unsigned char)(val & 0xFF));
	MOVF        FARG_eep_write_word_addr+0, 0 
	ADDLW       1
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVLW       255
	ANDWF       FARG_eep_write_word_val+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,240 :: 		}
L_end_eep_write_word:
	RETURN      0
; end of _eep_write_word

_eep_read_word:

;Ascenseur.c,242 :: 		unsigned int eep_read_word(unsigned char addr) {
;Ascenseur.c,243 :: 		unsigned int hi = (unsigned int)eep_read_byte(addr);
	MOVF        FARG_eep_read_word_addr+0, 0 
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       eep_read_word_hi_L0+0 
	MOVLW       0
	MOVWF       eep_read_word_hi_L0+1 
;Ascenseur.c,244 :: 		unsigned int lo = (unsigned int)eep_read_byte(addr + 1);
	MOVF        FARG_eep_read_word_addr+0, 0 
	ADDLW       1
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
;Ascenseur.c,245 :: 		return (hi << 8) | lo;
	MOVF        eep_read_word_hi_L0+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R3, 0 
	IORWF       R0, 1 
	MOVF        R4, 0 
	IORWF       R1, 1 
;Ascenseur.c,246 :: 		}
L_end_eep_read_word:
	RETURN      0
; end of _eep_read_word

_recalc_pwm_max:

;Ascenseur.c,248 :: 		void recalc_pwm_max() {
;Ascenseur.c,249 :: 		pwm_max_eff = (unsigned char)((unsigned int)vitesse_max_pc * 255 / 100);
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
;Ascenseur.c,250 :: 		if (pwm_max_eff < (unsigned char)(PWM_MIN + 20))
	MOVLW       100
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_recalc_pwm_max24
;Ascenseur.c,251 :: 		pwm_max_eff = (unsigned char)(PWM_MIN + 20);
	MOVLW       100
	MOVWF       _pwm_max_eff+0 
L_recalc_pwm_max24:
;Ascenseur.c,252 :: 		}
L_end_recalc_pwm_max:
	RETURN      0
; end of _recalc_pwm_max

_pop_cmd:

;Ascenseur.c,254 :: 		unsigned char pop_cmd(char *dest) {
;Ascenseur.c,256 :: 		if (cmd_qhead == cmd_qtail) return 0;
	MOVF        _cmd_qhead+0, 0 
	XORWF       _cmd_qtail+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_pop_cmd25
	CLRF        R0 
	GOTO        L_end_pop_cmd
L_pop_cmd25:
;Ascenseur.c,257 :: 		GIE_bit = 0;
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,258 :: 		for (i = 0; i < (CMD_QLEN - 1); i++)
	CLRF        pop_cmd_i_L0+0 
L_pop_cmd26:
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pop_cmd466
	MOVLW       39
	SUBWF       pop_cmd_i_L0+0, 0 
L__pop_cmd466:
	BTFSC       STATUS+0, 0 
	GOTO        L_pop_cmd27
;Ascenseur.c,259 :: 		dest[i] = cmd_queue[cmd_qhead][i];
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
;Ascenseur.c,258 :: 		for (i = 0; i < (CMD_QLEN - 1); i++)
	INCF        pop_cmd_i_L0+0, 1 
;Ascenseur.c,259 :: 		dest[i] = cmd_queue[cmd_qhead][i];
	GOTO        L_pop_cmd26
L_pop_cmd27:
;Ascenseur.c,260 :: 		dest[CMD_QLEN - 1] = '\0';
	MOVLW       39
	ADDWF       FARG_pop_cmd_dest+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_pop_cmd_dest+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;Ascenseur.c,261 :: 		cmd_qhead = (unsigned char)((cmd_qhead + 1) & (CMD_QSIZE - 1));
	MOVF        _cmd_qhead+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVLW       3
	ANDWF       R0, 0 
	MOVWF       _cmd_qhead+0 
;Ascenseur.c,262 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,263 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
;Ascenseur.c,264 :: 		}
L_end_pop_cmd:
	RETURN      0
; end of _pop_cmd

_eeprom_charger:

;Ascenseur.c,266 :: 		void eeprom_charger() {
;Ascenseur.c,270 :: 		stored_traj = eep_read_word(0x00);
	CLRF        FARG_eep_read_word_addr+0 
	CALL        _eep_read_word+0, 0
	MOVF        R0, 0 
	MOVWF       eeprom_charger_stored_traj_L0+0 
	MOVF        R1, 0 
	MOVWF       eeprom_charger_stored_traj_L0+1 
;Ascenseur.c,271 :: 		last_etage  = eep_read_byte(0x02);
	MOVLW       2
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       _last_etage+0 
;Ascenseur.c,272 :: 		stored_vit  = eep_read_byte(0x03);
	MOVLW       3
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       eeprom_charger_stored_vit_L0+0 
;Ascenseur.c,274 :: 		if (stored_traj == 0xFFFF) {
	MOVF        eeprom_charger_stored_traj_L0+1, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L__eeprom_charger468
	MOVLW       255
	XORWF       eeprom_charger_stored_traj_L0+0, 0 
L__eeprom_charger468:
	BTFSS       STATUS+0, 2 
	GOTO        L_eeprom_charger29
;Ascenseur.c,275 :: 		nb_trajets = 0;
	CLRF        _nb_trajets+0 
	CLRF        _nb_trajets+1 
;Ascenseur.c,276 :: 		eep_write_word(0x00, 0);
	CLRF        FARG_eep_write_word_addr+0 
	CLRF        FARG_eep_write_word_val+0 
	CLRF        FARG_eep_write_word_val+1 
	CALL        _eep_write_word+0, 0
;Ascenseur.c,277 :: 		} else {
	GOTO        L_eeprom_charger30
L_eeprom_charger29:
;Ascenseur.c,278 :: 		nb_trajets = stored_traj;
	MOVF        eeprom_charger_stored_traj_L0+0, 0 
	MOVWF       _nb_trajets+0 
	MOVF        eeprom_charger_stored_traj_L0+1, 0 
	MOVWF       _nb_trajets+1 
;Ascenseur.c,279 :: 		}
L_eeprom_charger30:
;Ascenseur.c,281 :: 		if (last_etage == 0xFF) {
	MOVF        _last_etage+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_eeprom_charger31
;Ascenseur.c,282 :: 		last_etage = 0;
	CLRF        _last_etage+0 
;Ascenseur.c,283 :: 		eep_write_byte(0x02, 0);
	MOVLW       2
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,284 :: 		}
L_eeprom_charger31:
;Ascenseur.c,286 :: 		if (stored_vit == 0xFF || stored_vit == 0) {
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L__eeprom_charger418
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__eeprom_charger418
	GOTO        L_eeprom_charger34
L__eeprom_charger418:
;Ascenseur.c,287 :: 		vitesse_eeprom = 100;
	MOVLW       100
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,288 :: 		vitesse_max_pc  = 100;
	MOVLW       100
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,289 :: 		eep_write_byte(0x03, 100);
	MOVLW       3
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVLW       100
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,290 :: 		} else {
	GOTO        L_eeprom_charger35
L_eeprom_charger34:
;Ascenseur.c,291 :: 		vitesse_eeprom = stored_vit;
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,292 :: 		vitesse_max_pc  = stored_vit;
	MOVF        eeprom_charger_stored_vit_L0+0, 0 
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,293 :: 		}
L_eeprom_charger35:
;Ascenseur.c,295 :: 		poids_max        = POIDS_MAX_DEF;
	MOVLW       118
	MOVWF       _poids_max+0 
	MOVLW       2
	MOVWF       _poids_max+1 
;Ascenseur.c,296 :: 		seuil_surge      = POIDS_MAX_DEF;
	MOVLW       118
	MOVWF       _seuil_surge+0 
	MOVLW       2
	MOVWF       _seuil_surge+1 
;Ascenseur.c,297 :: 		surcharge_active = 0;
	CLRF        _surcharge_active+0 
;Ascenseur.c,298 :: 		etat_surcharge   = 0;
	CLRF        _etat_surcharge+0 
;Ascenseur.c,300 :: 		recalc_pwm_max();
	CALL        _recalc_pwm_max+0, 0
;Ascenseur.c,301 :: 		}
L_end_eeprom_charger:
	RETURN      0
; end of _eeprom_charger

_eeprom_sauver_trajet:

;Ascenseur.c,303 :: 		void eeprom_sauver_trajet() {
;Ascenseur.c,304 :: 		nb_session++;
	INFSNZ      _nb_session+0, 1 
	INCF        _nb_session+1, 1 
;Ascenseur.c,305 :: 		nb_trajets++;
	INFSNZ      _nb_trajets+0, 1 
	INCF        _nb_trajets+1, 1 
;Ascenseur.c,306 :: 		last_etage = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _last_etage+0 
;Ascenseur.c,307 :: 		eep_write_word(0x00, nb_trajets);
	CLRF        FARG_eep_write_word_addr+0 
	MOVF        _nb_trajets+0, 0 
	MOVWF       FARG_eep_write_word_val+0 
	MOVF        _nb_trajets+1, 0 
	MOVWF       FARG_eep_write_word_val+1 
	CALL        _eep_write_word+0, 0
;Ascenseur.c,308 :: 		eep_write_byte(0x02, last_etage);
	MOVLW       2
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        _last_etage+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,309 :: 		}
L_end_eeprom_sauver_trajet:
	RETURN      0
; end of _eeprom_sauver_trajet

_eeprom_reset:

;Ascenseur.c,311 :: 		void eeprom_reset() {
;Ascenseur.c,312 :: 		nb_trajets = 0;
	CLRF        _nb_trajets+0 
	CLRF        _nb_trajets+1 
;Ascenseur.c,313 :: 		last_etage = 0;
	CLRF        _last_etage+0 
;Ascenseur.c,314 :: 		vitesse_eeprom = 100;
	MOVLW       100
	MOVWF       _vitesse_eeprom+0 
;Ascenseur.c,315 :: 		vitesse_max_pc = 100;
	MOVLW       100
	MOVWF       _vitesse_max_pc+0 
;Ascenseur.c,316 :: 		recalc_pwm_max();
	CALL        _recalc_pwm_max+0, 0
;Ascenseur.c,318 :: 		eep_write_byte(0x00, 0x00);
	CLRF        FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,319 :: 		eep_write_byte(0x01, 0x00);
	MOVLW       1
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,320 :: 		eep_write_byte(0x02, 0x00);
	MOVLW       2
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,321 :: 		eep_write_byte(0x03, 100);
	MOVLW       3
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVLW       100
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,322 :: 		eep_write_byte(0x04, 0x00);
	MOVLW       4
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,323 :: 		eep_write_byte(0x05, 0x00);
	MOVLW       5
	MOVWF       FARG_eep_write_byte_addr+0 
	CLRF        FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,324 :: 		}
L_end_eeprom_reset:
	RETURN      0
; end of _eeprom_reset

_set_pwm:

;Ascenseur.c,326 :: 		void set_pwm(unsigned char duty) {
;Ascenseur.c,327 :: 		PWM1_Set_Duty(duty);
	MOVF        FARG_set_pwm_duty+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,329 :: 		if (pwm_max_eff > 0) {
	MOVF        _pwm_max_eff+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_set_pwm36
;Ascenseur.c,330 :: 		if (duty >= pwm_max_eff)
	MOVF        _pwm_max_eff+0, 0 
	SUBWF       FARG_set_pwm_duty+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_set_pwm37
;Ascenseur.c,331 :: 		pwm_actuel = vitesse_max_pc;
	MOVF        _vitesse_max_pc+0, 0 
	MOVWF       _pwm_actuel+0 
	GOTO        L_set_pwm38
L_set_pwm37:
;Ascenseur.c,333 :: 		pwm_actuel = (unsigned char)((unsigned long)vitesse_max_pc * duty / pwm_max_eff);
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
;Ascenseur.c,334 :: 		} else {
	GOTO        L_set_pwm39
L_set_pwm36:
;Ascenseur.c,335 :: 		pwm_actuel = 0;
	CLRF        _pwm_actuel+0 
;Ascenseur.c,336 :: 		}
L_set_pwm39:
;Ascenseur.c,337 :: 		}
L_end_set_pwm:
	RETURN      0
; end of _set_pwm

_uart_send_data:

;Ascenseur.c,339 :: 		void uart_send_data() {
;Ascenseur.c,343 :: 		if (suppress_data_count > 0) {
	MOVF        _suppress_data_count+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_uart_send_data40
;Ascenseur.c,344 :: 		suppress_data_count--;
	DECF        _suppress_data_count+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _suppress_data_count+0 
;Ascenseur.c,345 :: 		return;
	GOTO        L_end_uart_send_data
;Ascenseur.c,346 :: 		}
L_uart_send_data40:
;Ascenseur.c,348 :: 		if      (direction == 'U') dir_n = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data41
	MOVLW       1
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data42
L_uart_send_data41:
;Ascenseur.c,349 :: 		else if (direction == 'D') dir_n = 2;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data43
	MOVLW       2
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data44
L_uart_send_data43:
;Ascenseur.c,350 :: 		else                       dir_n = 0;
	CLRF        uart_send_data_dir_n_L0+0 
L_uart_send_data44:
L_uart_send_data42:
;Ascenseur.c,352 :: 		prt_n = mode_auto ? (ir_porte ? 1 : 0) : (porte_cmd ? 1 : 0);
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
;Ascenseur.c,354 :: 		sprintf(trame,
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_sprintf_wh+1 
;Ascenseur.c,355 :: 		"<DATA,ET:%d,DIR:%d,PT:%d,PRT:%d,AL:%d,URG:%d,NB:%d,PWM:%d,TPS:%d>\r\n",
	MOVLW       ?lstr_1_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,356 :: 		(int)etage_actuel, (int)dir_n, (int)poids_kg,
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
;Ascenseur.c,357 :: 		(int)prt_n,        (int)al_active, (int)urg_active,
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
;Ascenseur.c,358 :: 		(int)nb_session,   (int)pwm_actuel, (int)temps_trajet);
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
;Ascenseur.c,360 :: 		UART1_Write_Text(trame);
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,361 :: 		}
L_end_uart_send_data:
	RETURN      0
; end of _uart_send_data

_uart_send_eeprom:

;Ascenseur.c,363 :: 		void uart_send_eeprom() {
;Ascenseur.c,365 :: 		suppress_data_count = 1;
	MOVLW       1
	MOVWF       _suppress_data_count+0 
;Ascenseur.c,366 :: 		sprintf(trame,
	MOVLW       uart_send_eeprom_trame_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(uart_send_eeprom_trame_L0+0)
	MOVWF       FARG_sprintf_wh+1 
;Ascenseur.c,367 :: 		"<EEP,TRAJ:%d,LAST:%d,VITESSE:%d>\r\n",
	MOVLW       ?lstr_2_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_2_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_2_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,368 :: 		(int)nb_trajets, (int)last_etage, (int)vitesse_eeprom);
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
;Ascenseur.c,369 :: 		UART1_Write_Text(trame);
	MOVLW       uart_send_eeprom_trame_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(uart_send_eeprom_trame_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,370 :: 		}
L_end_uart_send_eeprom:
	RETURN      0
; end of _uart_send_eeprom

_uart_ack_ok:

;Ascenseur.c,372 :: 		void uart_ack_ok()  { UART1_Write_Text("<ACK,OK>\r\n");  }
	MOVLW       ?lstr3_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
L_end_uart_ack_ok:
	RETURN      0
; end of _uart_ack_ok

_uart_ack_err:

;Ascenseur.c,373 :: 		void uart_ack_err() { UART1_Write_Text("<ACK,ERR>\r\n"); }
	MOVLW       ?lstr4_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
L_end_uart_ack_err:
	RETURN      0
; end of _uart_ack_err

_lire_capteurs:

;Ascenseur.c,375 :: 		void lire_capteurs() {
;Ascenseur.c,376 :: 		unsigned long somme = 0;
	CLRF        lire_capteurs_somme_L0+0 
	CLRF        lire_capteurs_somme_L0+1 
	CLRF        lire_capteurs_somme_L0+2 
	CLRF        lire_capteurs_somme_L0+3 
;Ascenseur.c,380 :: 		ir_porte = PORTA.F0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       _ir_porte+0 
;Ascenseur.c,382 :: 		ADC_Read(1);
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;Ascenseur.c,383 :: 		for (n = 0; n < 8; n++) {
	CLRF        lire_capteurs_n_L0+0 
L_lire_capteurs51:
	MOVLW       8
	SUBWF       lire_capteurs_n_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_lire_capteurs52
;Ascenseur.c,384 :: 		somme += ADC_Read(1);
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
;Ascenseur.c,383 :: 		for (n = 0; n < 8; n++) {
	INCF        lire_capteurs_n_L0+0, 1 
;Ascenseur.c,385 :: 		}
	GOTO        L_lire_capteurs51
L_lire_capteurs52:
;Ascenseur.c,386 :: 		raw_adc = (unsigned int)(somme >> 3);
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
L__lire_capteurs477:
	BZ          L__lire_capteurs478
	RRCF        R4, 1 
	RRCF        R3, 1 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R4, 7 
	ADDLW       255
	GOTO        L__lire_capteurs477
L__lire_capteurs478:
	MOVF        R1, 0 
	MOVWF       lire_capteurs_raw_adc_L0+0 
	MOVF        R2, 0 
	MOVWF       lire_capteurs_raw_adc_L0+1 
;Ascenseur.c,388 :: 		if (raw_adc > POT_ADC_MAX) raw_adc = POT_ADC_MAX;
	MOVF        R2, 0 
	SUBLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__lire_capteurs479
	MOVF        R1, 0 
	SUBLW       132
L__lire_capteurs479:
	BTFSC       STATUS+0, 0 
	GOTO        L_lire_capteurs54
	MOVLW       132
	MOVWF       lire_capteurs_raw_adc_L0+0 
	MOVLW       3
	MOVWF       lire_capteurs_raw_adc_L0+1 
L_lire_capteurs54:
;Ascenseur.c,389 :: 		poids_kg = (unsigned int)((raw_adc * 900UL) / POT_ADC_MAX);
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
;Ascenseur.c,390 :: 		}
L_end_lire_capteurs:
	RETURN      0
; end of _lire_capteurs

_maj_surcharge:

;Ascenseur.c,392 :: 		void maj_surcharge(unsigned char force_transition) {
;Ascenseur.c,393 :: 		surcharge_active = (poids_kg >= seuil_surge) ? 1 : 0;
	MOVF        _seuil_surge+1, 0 
	SUBWF       _poids_kg+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__maj_surcharge481
	MOVF        _seuil_surge+0, 0 
	SUBWF       _poids_kg+0, 0 
L__maj_surcharge481:
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
;Ascenseur.c,394 :: 		if (force_transition) {
	MOVF        FARG_maj_surcharge_force_transition+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_maj_surcharge57
;Ascenseur.c,395 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,396 :: 		}
L_maj_surcharge57:
;Ascenseur.c,397 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,398 :: 		}
L_end_maj_surcharge:
	RETURN      0
; end of _maj_surcharge

_gerer_leds:

;Ascenseur.c,400 :: 		void gerer_leds() {
;Ascenseur.c,401 :: 		if (mode_auto) LED1 = ir_porte ? 1 : 0;
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
	GOTO        L__gerer_leds483
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L__gerer_leds484
L__gerer_leds483:
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
L__gerer_leds484:
	GOTO        L_gerer_leds61
L_gerer_leds58:
;Ascenseur.c,402 :: 		else           LED1 = porte_cmd ? 1 : 0;
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
	GOTO        L__gerer_leds485
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
	GOTO        L__gerer_leds486
L__gerer_leds485:
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
L__gerer_leds486:
L_gerer_leds61:
;Ascenseur.c,404 :: 		LED2 = (surcharge_active || urg_active || al_active) ? 1 : 0;
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds419
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds419
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__gerer_leds419
	GOTO        L_gerer_leds66
L__gerer_leds419:
	MOVLW       1
	MOVWF       R2 
	GOTO        L_gerer_leds67
L_gerer_leds66:
	CLRF        R2 
L_gerer_leds67:
	BTFSC       R2, 0 
	GOTO        L__gerer_leds487
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
	GOTO        L__gerer_leds488
L__gerer_leds487:
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
L__gerer_leds488:
;Ascenseur.c,405 :: 		}
L_end_gerer_leds:
	RETURN      0
; end of _gerer_leds

_etat_porte_char:

;Ascenseur.c,407 :: 		char etat_porte_char() {
;Ascenseur.c,408 :: 		return (mode_auto ? ir_porte : porte_cmd) ? 'O' : 'F';
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
;Ascenseur.c,409 :: 		}
L_end_etat_porte_char:
	RETURN      0
; end of _etat_porte_char

_lcd_build_surcharge_l2:

;Ascenseur.c,411 :: 		void lcd_build_surcharge_l2(char *buf) {
;Ascenseur.c,412 :: 		unsigned int v = poids_max;
	MOVF        _poids_max+0, 0 
	MOVWF       lcd_build_surcharge_l2_v_L0+0 
	MOVF        _poids_max+1, 0 
	MOVWF       lcd_build_surcharge_l2_v_L0+1 
;Ascenseur.c,414 :: 		buf[0]  = ' ';
	MOVFF       FARG_lcd_build_surcharge_l2_buf+0, FSR1L+0
	MOVFF       FARG_lcd_build_surcharge_l2_buf+1, FSR1H+0
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,415 :: 		buf[1]  = ' ';
	MOVLW       1
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,416 :: 		buf[2]  = 'M';
	MOVLW       2
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       77
	MOVWF       POSTINC1+0 
;Ascenseur.c,417 :: 		buf[3]  = 'A';
	MOVLW       3
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       65
	MOVWF       POSTINC1+0 
;Ascenseur.c,418 :: 		buf[4]  = 'X';
	MOVLW       4
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       88
	MOVWF       POSTINC1+0 
;Ascenseur.c,419 :: 		buf[5]  = ':';
	MOVLW       5
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       58
	MOVWF       POSTINC1+0 
;Ascenseur.c,420 :: 		buf[6]  = (v >= 100) ? ((char)('0' + (v / 100)))       : ' ';
	MOVLW       6
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+1 
	MOVLW       0
	SUBWF       lcd_build_surcharge_l2_v_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__lcd_build_surcharge_l2491
	MOVLW       100
	SUBWF       lcd_build_surcharge_l2_v_L0+0, 0 
L__lcd_build_surcharge_l2491:
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
;Ascenseur.c,421 :: 		buf[7]  = (v >= 10)  ? ((char)('0' + ((v / 10) % 10))) : ' ';
	MOVLW       7
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FLOC__lcd_build_surcharge_l2+1 
	MOVLW       0
	SUBWF       lcd_build_surcharge_l2_v_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__lcd_build_surcharge_l2492
	MOVLW       10
	SUBWF       lcd_build_surcharge_l2_v_L0+0, 0 
L__lcd_build_surcharge_l2492:
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
;Ascenseur.c,422 :: 		buf[8]  = (char)('0' + (v % 10));
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
;Ascenseur.c,423 :: 		buf[9]  = ' ';
	MOVLW       9
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,424 :: 		buf[10] = 'k';
	MOVLW       10
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       107
	MOVWF       POSTINC1+0 
;Ascenseur.c,425 :: 		buf[11] = 'g';
	MOVLW       11
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       103
	MOVWF       POSTINC1+0 
;Ascenseur.c,426 :: 		buf[12] = ' ';
	MOVLW       12
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,427 :: 		buf[13] = ' ';
	MOVLW       13
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,428 :: 		buf[14] = ' ';
	MOVLW       14
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,429 :: 		buf[15] = ' ';
	MOVLW       15
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Ascenseur.c,430 :: 		buf[16] = '\0';
	MOVLW       16
	ADDWF       FARG_lcd_build_surcharge_l2_buf+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_build_surcharge_l2_buf+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;Ascenseur.c,431 :: 		}
L_end_lcd_build_surcharge_l2:
	RETURN      0
; end of _lcd_build_surcharge_l2

_afficher_lcd:

;Ascenseur.c,433 :: 		void afficher_lcd() {
;Ascenseur.c,438 :: 		if (position_inconnue) {
	MOVF        _position_inconnue+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd76
;Ascenseur.c,439 :: 		Lcd_Out(1, 1, "POS INCONNUE!   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,440 :: 		Lcd_Out(2, 1, "Replacer manuel ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,441 :: 		return;
	GOTO        L_end_afficher_lcd
;Ascenseur.c,442 :: 		}
L_afficher_lcd76:
;Ascenseur.c,444 :: 		if (!urg_active && !al_active && surcharge_active) {
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd79
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_afficher_lcd79
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd79
L__afficher_lcd420:
;Ascenseur.c,445 :: 		lcd_build_surcharge_l2(surcharge_l2);
	MOVLW       afficher_lcd_surcharge_l2_L0+0
	MOVWF       FARG_lcd_build_surcharge_l2_buf+0 
	MOVLW       hi_addr(afficher_lcd_surcharge_l2_L0+0)
	MOVWF       FARG_lcd_build_surcharge_l2_buf+1 
	CALL        _lcd_build_surcharge_l2+0, 0
;Ascenseur.c,446 :: 		Lcd_Out(1, 1, "  SURCHARGE!    ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,447 :: 		Lcd_Out(2, 1, surcharge_l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       afficher_lcd_surcharge_l2_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(afficher_lcd_surcharge_l2_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,448 :: 		return;
	GOTO        L_end_afficher_lcd
;Ascenseur.c,449 :: 		}
L_afficher_lcd79:
;Ascenseur.c,451 :: 		if (mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd80
;Ascenseur.c,452 :: 		mode_str[0]='A'; mode_str[1]='u'; mode_str[2]='t'; mode_str[3]='o'; mode_str[4]='\0';
	MOVLW       65
	MOVWF       afficher_lcd_mode_str_L0+0 
	MOVLW       117
	MOVWF       afficher_lcd_mode_str_L0+1 
	MOVLW       116
	MOVWF       afficher_lcd_mode_str_L0+2 
	MOVLW       111
	MOVWF       afficher_lcd_mode_str_L0+3 
	CLRF        afficher_lcd_mode_str_L0+4 
;Ascenseur.c,453 :: 		} else {
	GOTO        L_afficher_lcd81
L_afficher_lcd80:
;Ascenseur.c,454 :: 		mode_str[0]='M'; mode_str[1]='a'; mode_str[2]='n'; mode_str[3]='u'; mode_str[4]='\0';
	MOVLW       77
	MOVWF       afficher_lcd_mode_str_L0+0 
	MOVLW       97
	MOVWF       afficher_lcd_mode_str_L0+1 
	MOVLW       110
	MOVWF       afficher_lcd_mode_str_L0+2 
	MOVLW       117
	MOVWF       afficher_lcd_mode_str_L0+3 
	CLRF        afficher_lcd_mode_str_L0+4 
;Ascenseur.c,455 :: 		}
L_afficher_lcd81:
;Ascenseur.c,457 :: 		if (en_mouvement) {
	MOVF        _en_mouvement+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_afficher_lcd82
;Ascenseur.c,458 :: 		if (direction == 'U') { dir_str[0]='U'; dir_str[1]='P'; dir_str[2]='\0'; }
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
;Ascenseur.c,459 :: 		else                  { dir_str[0]='D'; dir_str[1]='N'; dir_str[2]='\0'; }
	MOVLW       68
	MOVWF       afficher_lcd_dir_str_L0+0 
	MOVLW       78
	MOVWF       afficher_lcd_dir_str_L0+1 
	CLRF        afficher_lcd_dir_str_L0+2 
L_afficher_lcd84:
;Ascenseur.c,461 :: 		sprintf(l1, "ET:%u->%u %s %s ",
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
;Ascenseur.c,462 :: 		(unsigned)etage_actuel, (unsigned)etage_cible, dir_str, mode_str);
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
;Ascenseur.c,463 :: 		} else {
	GOTO        L_afficher_lcd85
L_afficher_lcd82:
;Ascenseur.c,464 :: 		sprintf(l1, "ET:%u STOP  %s ",
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
;Ascenseur.c,465 :: 		(unsigned)etage_actuel, mode_str);
	MOVF        _etage_actuel+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       0
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       afficher_lcd_mode_str_L0+0
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       hi_addr(afficher_lcd_mode_str_L0+0)
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;Ascenseur.c,466 :: 		}
L_afficher_lcd85:
;Ascenseur.c,468 :: 		Lcd_Out(1, 1, l1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,469 :: 		sprintf(l2, "P:%3dkg IR:%c    ", (int)poids_kg, etat_porte_char());
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
;Ascenseur.c,470 :: 		Lcd_Out(2, 1, l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,471 :: 		}
L_end_afficher_lcd:
	RETURN      0
; end of _afficher_lcd

_lcd_transition:

;Ascenseur.c,473 :: 		void lcd_transition() {
;Ascenseur.c,474 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,475 :: 		afficher_lcd();
	CALL        _afficher_lcd+0, 0
;Ascenseur.c,476 :: 		}
L_end_lcd_transition:
	RETURN      0
; end of _lcd_transition

_lcd_update_transit:

;Ascenseur.c,478 :: 		void lcd_update_transit() {
;Ascenseur.c,482 :: 		if (direction == 'U') { dir_str[0]='U'; dir_str[1]='P'; dir_str[2]='\0'; }
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
;Ascenseur.c,483 :: 		else                  { dir_str[0]='D'; dir_str[1]='N'; dir_str[2]='\0'; }
	MOVLW       68
	MOVWF       lcd_update_transit_dir_str_L0+0 
	MOVLW       78
	MOVWF       lcd_update_transit_dir_str_L0+1 
	CLRF        lcd_update_transit_dir_str_L0+2 
L_lcd_update_transit87:
;Ascenseur.c,485 :: 		if (mode_auto) {
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_update_transit88
;Ascenseur.c,486 :: 		mode_str[0]='A'; mode_str[1]='u'; mode_str[2]='t'; mode_str[3]='o'; mode_str[4]='\0';
	MOVLW       65
	MOVWF       lcd_update_transit_mode_str_L0+0 
	MOVLW       117
	MOVWF       lcd_update_transit_mode_str_L0+1 
	MOVLW       116
	MOVWF       lcd_update_transit_mode_str_L0+2 
	MOVLW       111
	MOVWF       lcd_update_transit_mode_str_L0+3 
	CLRF        lcd_update_transit_mode_str_L0+4 
;Ascenseur.c,487 :: 		} else {
	GOTO        L_lcd_update_transit89
L_lcd_update_transit88:
;Ascenseur.c,488 :: 		mode_str[0]='M'; mode_str[1]='a'; mode_str[2]='n'; mode_str[3]='u'; mode_str[4]='\0';
	MOVLW       77
	MOVWF       lcd_update_transit_mode_str_L0+0 
	MOVLW       97
	MOVWF       lcd_update_transit_mode_str_L0+1 
	MOVLW       110
	MOVWF       lcd_update_transit_mode_str_L0+2 
	MOVLW       117
	MOVWF       lcd_update_transit_mode_str_L0+3 
	CLRF        lcd_update_transit_mode_str_L0+4 
;Ascenseur.c,489 :: 		}
L_lcd_update_transit89:
;Ascenseur.c,496 :: 		sprintf(l1, "ET:%u->%u %s %s ",
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
;Ascenseur.c,497 :: 		(unsigned)etage_actuel, (unsigned)etage_cible, dir_str, mode_str);
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
;Ascenseur.c,498 :: 		Lcd_Out(1, 1, l1);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l1+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l1+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,500 :: 		sprintf(l2, "P:%3dkg IR:%c    ", (int)poids_kg, etat_porte_char());
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
;Ascenseur.c,501 :: 		Lcd_Out(2, 1, l2);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _l2+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_l2+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,506 :: 		}
L_end_lcd_update_transit:
	RETURN      0
; end of _lcd_update_transit

_appliquer_pmax:

;Ascenseur.c,508 :: 		void appliquer_pmax(unsigned int val) {
;Ascenseur.c,509 :: 		if (val < 1)   val = 1;
	MOVLW       0
	SUBWF       FARG_appliquer_pmax_val+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__appliquer_pmax497
	MOVLW       1
	SUBWF       FARG_appliquer_pmax_val+0, 0 
L__appliquer_pmax497:
	BTFSC       STATUS+0, 0 
	GOTO        L_appliquer_pmax90
	MOVLW       1
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVLW       0
	MOVWF       FARG_appliquer_pmax_val+1 
L_appliquer_pmax90:
;Ascenseur.c,510 :: 		if (val > 999) val = 999;
	MOVF        FARG_appliquer_pmax_val+1, 0 
	SUBLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__appliquer_pmax498
	MOVF        FARG_appliquer_pmax_val+0, 0 
	SUBLW       231
L__appliquer_pmax498:
	BTFSC       STATUS+0, 0 
	GOTO        L_appliquer_pmax91
	MOVLW       231
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVLW       3
	MOVWF       FARG_appliquer_pmax_val+1 
L_appliquer_pmax91:
;Ascenseur.c,512 :: 		poids_max  = val;
	MOVF        FARG_appliquer_pmax_val+0, 0 
	MOVWF       _poids_max+0 
	MOVF        FARG_appliquer_pmax_val+1, 0 
	MOVWF       _poids_max+1 
;Ascenseur.c,513 :: 		seuil_surge = val;
	MOVF        FARG_appliquer_pmax_val+0, 0 
	MOVWF       _seuil_surge+0 
	MOVF        FARG_appliquer_pmax_val+1, 0 
	MOVWF       _seuil_surge+1 
;Ascenseur.c,515 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,516 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,518 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,519 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,520 :: 		}
L_end_appliquer_pmax:
	RETURN      0
; end of _appliquer_pmax

_attendre_ms:

;Ascenseur.c,522 :: 		void attendre_ms(unsigned int ms) {
;Ascenseur.c,523 :: 		unsigned int  elapsed = 0;
	CLRF        attendre_ms_elapsed_L0+0 
	CLRF        attendre_ms_elapsed_L0+1 
;Ascenseur.c,530 :: 		while (elapsed < ms) {
L_attendre_ms92:
	MOVF        FARG_attendre_ms_ms+1, 0 
	SUBWF       attendre_ms_elapsed_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms500
	MOVF        FARG_attendre_ms_ms+0, 0 
	SUBWF       attendre_ms_elapsed_L0+0, 0 
L__attendre_ms500:
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms93
;Ascenseur.c,532 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_attendre_ms96
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms96
L__attendre_ms430:
;Ascenseur.c,533 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_attendre_ms97:
	DECFSZ      R13, 1, 1
	BRA         L_attendre_ms97
	DECFSZ      R12, 1, 1
	BRA         L_attendre_ms97
	NOP
	NOP
;Ascenseur.c,534 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_attendre_ms98
;Ascenseur.c,535 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,536 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,537 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,538 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,539 :: 		}
L_attendre_ms98:
;Ascenseur.c,540 :: 		}
L_attendre_ms96:
;Ascenseur.c,542 :: 		if (urgence_flag || stop_demande) return;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms429
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms429
	GOTO        L_attendre_ms104
L__attendre_ms429:
	GOTO        L_end_attendre_ms
L_attendre_ms104:
;Ascenseur.c,544 :: 		if (pop_cmd(local_cmd)) {
	MOVLW       attendre_ms_local_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(attendre_ms_local_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms105
;Ascenseur.c,546 :: 		if (strstr(local_cmd, "CMD,STOP")) {
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
	GOTO        L_attendre_ms106
;Ascenseur.c,547 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,548 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,549 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,550 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,551 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,552 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,553 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,555 :: 		} else if (strstr(local_cmd, "AL:ON")) {
	GOTO        L_attendre_ms110
L_attendre_ms106:
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
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms111
;Ascenseur.c,556 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,557 :: 		al_flag = 1;
	MOVLW       1
	MOVWF       _al_flag+0 
;Ascenseur.c,558 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,559 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,561 :: 		} else if ((pp = strstr(local_cmd, "CALL:")) != 0) {
	GOTO        L_attendre_ms112
L_attendre_ms111:
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
	MOVWF       attendre_ms_pp_L0+0 
	MOVF        R1, 0 
	MOVWF       attendre_ms_pp_L0+1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms501
	MOVLW       0
	XORWF       R0, 0 
L__attendre_ms501:
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms113
;Ascenseur.c,562 :: 		nc = (unsigned char)(*(pp + 5) - '0');
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
;Ascenseur.c,563 :: 		if (nc < NB_ETAGES && !al_active && !surcharge_active) {
	MOVLW       4
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms116
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms116
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms116
L__attendre_ms428:
;Ascenseur.c,564 :: 		if      (direction == 'U' && nc > etage_actuel) req[nc] = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms119
	MOVF        attendre_ms_nc_L0+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms119
L__attendre_ms427:
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
	GOTO        L_attendre_ms120
L_attendre_ms119:
;Ascenseur.c,565 :: 		else if (direction == 'D' && nc < etage_actuel) req[nc] = 1;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms123
	MOVF        _etage_actuel+0, 0 
	SUBWF       attendre_ms_nc_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms123
L__attendre_ms426:
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
L_attendre_ms123:
L_attendre_ms120:
;Ascenseur.c,566 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,567 :: 		} else {
	GOTO        L_attendre_ms124
L_attendre_ms116:
;Ascenseur.c,568 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,569 :: 		}
L_attendre_ms124:
;Ascenseur.c,571 :: 		} else if ((pp = strstr(local_cmd, "PMAX:")) != 0) {
	GOTO        L_attendre_ms125
L_attendre_ms113:
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
	MOVWF       attendre_ms_pp_L0+0 
	MOVF        R1, 0 
	MOVWF       attendre_ms_pp_L0+1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms502
	MOVLW       0
	XORWF       R0, 0 
L__attendre_ms502:
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms126
;Ascenseur.c,572 :: 		pv = 0;
	CLRF        attendre_ms_pv_L0+0 
	CLRF        attendre_ms_pv_L0+1 
;Ascenseur.c,573 :: 		pp += 5;
	MOVLW       5
	ADDWF       attendre_ms_pp_L0+0, 1 
	MOVLW       0
	ADDWFC      attendre_ms_pp_L0+1, 1 
;Ascenseur.c,574 :: 		while (*pp >= '0' && *pp <= '9') {
L_attendre_ms127:
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_attendre_ms128
	MOVFF       attendre_ms_pp_L0+0, FSR0L+0
	MOVFF       attendre_ms_pp_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_attendre_ms128
L__attendre_ms425:
;Ascenseur.c,575 :: 		pv = pv * 10 + (unsigned int)(*pp - '0');
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
;Ascenseur.c,576 :: 		pp++;
	INFSNZ      attendre_ms_pp_L0+0, 1 
	INCF        attendre_ms_pp_L0+1, 1 
;Ascenseur.c,577 :: 		}
	GOTO        L_attendre_ms127
L_attendre_ms128:
;Ascenseur.c,578 :: 		appliquer_pmax(pv);
	MOVF        attendre_ms_pv_L0+0, 0 
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVF        attendre_ms_pv_L0+1, 0 
	MOVWF       FARG_appliquer_pmax_val+1 
	CALL        _appliquer_pmax+0, 0
;Ascenseur.c,580 :: 		} else if (strstr(local_cmd, "GET:EEP")) {
	GOTO        L_attendre_ms131
L_attendre_ms126:
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
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms132
;Ascenseur.c,581 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,583 :: 		} else if (strstr(local_cmd, "EEP:RST") || strstr(local_cmd, "RST:EEP")) {
	GOTO        L_attendre_ms133
L_attendre_ms132:
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
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms424
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
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms424
	GOTO        L_attendre_ms136
L__attendre_ms424:
;Ascenseur.c,584 :: 		eeprom_reset();
	CALL        _eeprom_reset+0, 0
;Ascenseur.c,585 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,586 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,587 :: 		}
L_attendre_ms136:
L_attendre_ms133:
L_attendre_ms131:
L_attendre_ms125:
L_attendre_ms112:
L_attendre_ms110:
;Ascenseur.c,588 :: 		}
L_attendre_ms105:
;Ascenseur.c,590 :: 		if (urgence_flag || stop_demande) return;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms423
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__attendre_ms423
	GOTO        L_attendre_ms139
L__attendre_ms423:
	GOTO        L_end_attendre_ms
L_attendre_ms139:
;Ascenseur.c,592 :: 		for (b = 0; b < NB_ETAGES; b++) {
	CLRF        attendre_ms_b_L0+0 
L_attendre_ms140:
	MOVLW       4
	SUBWF       attendre_ms_b_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms141
;Ascenseur.c,593 :: 		if (PORTD & (1 << b)) {
	MOVF        attendre_ms_b_L0+0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__attendre_ms503:
	BZ          L__attendre_ms504
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__attendre_ms503
L__attendre_ms504:
	MOVF        PORTD+0, 0 
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms143
;Ascenseur.c,594 :: 		if      (direction == 'U' && b > etage_actuel) req[b] = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms146
	MOVF        attendre_ms_b_L0+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms146
L__attendre_ms422:
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
	GOTO        L_attendre_ms147
L_attendre_ms146:
;Ascenseur.c,595 :: 		else if (direction == 'D' && b < etage_actuel) req[b] = 1;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_attendre_ms150
	MOVF        _etage_actuel+0, 0 
	SUBWF       attendre_ms_b_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_attendre_ms150
L__attendre_ms421:
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
L_attendre_ms150:
L_attendre_ms147:
;Ascenseur.c,596 :: 		}
L_attendre_ms143:
;Ascenseur.c,592 :: 		for (b = 0; b < NB_ETAGES; b++) {
	INCF        attendre_ms_b_L0+0, 1 
;Ascenseur.c,597 :: 		}
	GOTO        L_attendre_ms140
L_attendre_ms141:
;Ascenseur.c,599 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms151
;Ascenseur.c,600 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,601 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,602 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,603 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,605 :: 		if (moteur_actif) lcd_update_transit();
	MOVF        _moteur_actif+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_attendre_ms152
	CALL        _lcd_update_transit+0, 0
	GOTO        L_attendre_ms153
L_attendre_ms152:
;Ascenseur.c,606 :: 		else              afficher_lcd();
	CALL        _afficher_lcd+0, 0
L_attendre_ms153:
;Ascenseur.c,607 :: 		}
L_attendre_ms151:
;Ascenseur.c,609 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_attendre_ms154:
	DECFSZ      R13, 1, 1
	BRA         L_attendre_ms154
	DECFSZ      R12, 1, 1
	BRA         L_attendre_ms154
	NOP
	NOP
;Ascenseur.c,610 :: 		elapsed += MS_LOOP_STEP;
	MOVLW       20
	ADDWF       attendre_ms_elapsed_L0+0, 1 
	MOVLW       0
	ADDWFC      attendre_ms_elapsed_L0+1, 1 
;Ascenseur.c,611 :: 		}
	GOTO        L_attendre_ms92
L_attendre_ms93:
;Ascenseur.c,612 :: 		}
L_end_attendre_ms:
	RETURN      0
; end of _attendre_ms

_rampe_accel:

;Ascenseur.c,614 :: 		void rampe_accel() {
;Ascenseur.c,618 :: 		for (i = 0; i <= PWM_PALIERS; i++) {
	CLRF        rampe_accel_i_L0+0 
L_rampe_accel155:
	MOVF        rampe_accel_i_L0+0, 0 
	SUBLW       6
	BTFSS       STATUS+0, 0 
	GOTO        L_rampe_accel156
;Ascenseur.c,619 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_accel160
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_rampe_accel160
L__rampe_accel432:
;Ascenseur.c,620 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_accel161:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_accel161
	DECFSZ      R12, 1, 1
	BRA         L_rampe_accel161
	NOP
	NOP
;Ascenseur.c,621 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_accel162
;Ascenseur.c,622 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,623 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,624 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,625 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,626 :: 		}
L_rampe_accel162:
;Ascenseur.c,627 :: 		}
L_rampe_accel160:
;Ascenseur.c,629 :: 		if (urgence_flag || stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_accel431
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_accel431
	GOTO        L_rampe_accel168
L__rampe_accel431:
;Ascenseur.c,630 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,631 :: 		return;
	GOTO        L_end_rampe_accel
;Ascenseur.c,632 :: 		}
L_rampe_accel168:
;Ascenseur.c,634 :: 		pwm = PWM_MIN + ((unsigned int)(pwm_max_eff - PWM_MIN) * i) / PWM_PALIERS;
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
;Ascenseur.c,635 :: 		set_pwm((unsigned char)pwm);
	MOVF        R0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,636 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,637 :: 		Delay_ms(MS_PALIER);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_accel172:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_accel172
	DECFSZ      R12, 1, 1
	BRA         L_rampe_accel172
	NOP
	NOP
;Ascenseur.c,618 :: 		for (i = 0; i <= PWM_PALIERS; i++) {
	INCF        rampe_accel_i_L0+0, 1 
;Ascenseur.c,638 :: 		}
	GOTO        L_rampe_accel155
L_rampe_accel156:
;Ascenseur.c,639 :: 		}
L_end_rampe_accel:
	RETURN      0
; end of _rampe_accel

_rampe_decel:

;Ascenseur.c,641 :: 		void rampe_decel() {
;Ascenseur.c,645 :: 		for (i = PWM_PALIERS; i > 0; i--) {
	MOVLW       6
	MOVWF       rampe_decel_i_L0+0 
L_rampe_decel173:
	MOVF        rampe_decel_i_L0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_rampe_decel174
;Ascenseur.c,646 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_decel178
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_rampe_decel178
L__rampe_decel434:
;Ascenseur.c,647 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_decel179:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_decel179
	DECFSZ      R12, 1, 1
	BRA         L_rampe_decel179
	NOP
	NOP
;Ascenseur.c,648 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_rampe_decel180
;Ascenseur.c,649 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,650 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,651 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,652 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,653 :: 		}
L_rampe_decel180:
;Ascenseur.c,654 :: 		}
L_rampe_decel178:
;Ascenseur.c,656 :: 		if (urgence_flag || stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_decel433
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__rampe_decel433
	GOTO        L_rampe_decel186
L__rampe_decel433:
;Ascenseur.c,657 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,658 :: 		return;
	GOTO        L_end_rampe_decel
;Ascenseur.c,659 :: 		}
L_rampe_decel186:
;Ascenseur.c,661 :: 		pwm = PWM_MIN + ((unsigned int)(pwm_max_eff - PWM_MIN) * (i - 1)) / PWM_PALIERS;
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
;Ascenseur.c,662 :: 		set_pwm((unsigned char)pwm);
	MOVF        R0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,663 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,664 :: 		Delay_ms(MS_PALIER);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_rampe_decel190:
	DECFSZ      R13, 1, 1
	BRA         L_rampe_decel190
	DECFSZ      R12, 1, 1
	BRA         L_rampe_decel190
	NOP
	NOP
;Ascenseur.c,645 :: 		for (i = PWM_PALIERS; i > 0; i--) {
	DECF        rampe_decel_i_L0+0, 1 
;Ascenseur.c,665 :: 		}
	GOTO        L_rampe_decel173
L_rampe_decel174:
;Ascenseur.c,667 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,668 :: 		}
L_end_rampe_decel:
	RETURN      0
; end of _rampe_decel

_demarrer_moteur:

;Ascenseur.c,670 :: 		void demarrer_moteur(char sens) {
;Ascenseur.c,671 :: 		if (sens == 'U') MOTEUR_MONTER();
	MOVF        FARG_demarrer_moteur_sens+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_demarrer_moteur194
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	MOVLW       1
	MOVWF       _moteur_actif+0 
	GOTO        L_demarrer_moteur198
L_demarrer_moteur194:
;Ascenseur.c,672 :: 		else             MOTEUR_DESCENDRE();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	MOVLW       1
	MOVWF       _moteur_actif+0 
L_demarrer_moteur198:
;Ascenseur.c,674 :: 		set_pwm(PWM_MIN);
	MOVLW       80
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,675 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;Ascenseur.c,676 :: 		rampe_accel();
	CALL        _rampe_accel+0, 0
;Ascenseur.c,677 :: 		}
L_end_demarrer_moteur:
	RETURN      0
; end of _demarrer_moteur

_scanner_req:

;Ascenseur.c,679 :: 		void scanner_req() {
;Ascenseur.c,680 :: 		if (PORTD.F0) req[0] = 1;
	BTFSS       PORTD+0, 0 
	GOTO        L_scanner_req202
	MOVLW       1
	MOVWF       _req+0 
L_scanner_req202:
;Ascenseur.c,681 :: 		if (PORTD.F1) req[1] = 1;
	BTFSS       PORTD+0, 1 
	GOTO        L_scanner_req203
	MOVLW       1
	MOVWF       _req+1 
L_scanner_req203:
;Ascenseur.c,682 :: 		if (PORTD.F2) req[2] = 1;
	BTFSS       PORTD+0, 2 
	GOTO        L_scanner_req204
	MOVLW       1
	MOVWF       _req+2 
L_scanner_req204:
;Ascenseur.c,683 :: 		if (PORTD.F3) req[3] = 1;
	BTFSS       PORTD+0, 3 
	GOTO        L_scanner_req205
	MOVLW       1
	MOVWF       _req+3 
L_scanner_req205:
;Ascenseur.c,684 :: 		}
L_end_scanner_req:
	RETURN      0
; end of _scanner_req

_vider_req:

;Ascenseur.c,686 :: 		void vider_req() {
;Ascenseur.c,688 :: 		for (i = 0; i < NB_ETAGES; i++) req[i] = 0;
	CLRF        R1 
L_vider_req206:
	MOVLW       4
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_vider_req207
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
	GOTO        L_vider_req206
L_vider_req207:
;Ascenseur.c,689 :: 		}
L_end_vider_req:
	RETURN      0
; end of _vider_req

_prochain_req:

;Ascenseur.c,691 :: 		unsigned char prochain_req() {
;Ascenseur.c,695 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,697 :: 		if (direction == 'U') {
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req209
;Ascenseur.c,698 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       R4 
L_prochain_req210:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req211
;Ascenseur.c,699 :: 		if (req[i]) { req[i] = 0; return i; }
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
	GOTO        L_prochain_req213
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
L_prochain_req213:
;Ascenseur.c,698 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	INCF        R4, 1 
;Ascenseur.c,699 :: 		if (req[i]) { req[i] = 0; return i; }
	GOTO        L_prochain_req210
L_prochain_req211:
;Ascenseur.c,701 :: 		for (i = 0; i < etage_actuel; i++)
	CLRF        R4 
L_prochain_req214:
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req215
;Ascenseur.c,702 :: 		if (req[i]) { req[i] = 0; return i; }
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
	GOTO        L_prochain_req217
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
L_prochain_req217:
;Ascenseur.c,701 :: 		for (i = 0; i < etage_actuel; i++)
	INCF        R4, 1 
;Ascenseur.c,702 :: 		if (req[i]) { req[i] = 0; return i; }
	GOTO        L_prochain_req214
L_prochain_req215:
;Ascenseur.c,704 :: 		} else if (direction == 'D') {
	GOTO        L_prochain_req218
L_prochain_req209:
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_prochain_req219
;Ascenseur.c,705 :: 		for (i = etage_actuel; i > 0; i--)
	MOVF        _etage_actuel+0, 0 
	MOVWF       R4 
L_prochain_req220:
	MOVF        R4, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req221
;Ascenseur.c,706 :: 		if (req[i - 1]) { req[i - 1] = 0; return i - 1; }
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
	GOTO        L_prochain_req223
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
L_prochain_req223:
;Ascenseur.c,705 :: 		for (i = etage_actuel; i > 0; i--)
	DECF        R4, 1 
;Ascenseur.c,706 :: 		if (req[i - 1]) { req[i - 1] = 0; return i - 1; }
	GOTO        L_prochain_req220
L_prochain_req221:
;Ascenseur.c,708 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	MOVF        _etage_actuel+0, 0 
	ADDLW       1
	MOVWF       R4 
L_prochain_req224:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req225
;Ascenseur.c,709 :: 		if (req[i]) { req[i] = 0; return i; }
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
	GOTO        L_prochain_req227
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
L_prochain_req227:
;Ascenseur.c,708 :: 		for (i = etage_actuel + 1; i < NB_ETAGES; i++)
	INCF        R4, 1 
;Ascenseur.c,709 :: 		if (req[i]) { req[i] = 0; return i; }
	GOTO        L_prochain_req224
L_prochain_req225:
;Ascenseur.c,711 :: 		} else {
	GOTO        L_prochain_req228
L_prochain_req219:
;Ascenseur.c,712 :: 		nearest = 0xFF;
	MOVLW       255
	MOVWF       R5 
;Ascenseur.c,713 :: 		min_d = 10;
	MOVLW       10
	MOVWF       R8 
	MOVLW       0
	MOVWF       R9 
;Ascenseur.c,715 :: 		for (i = 0; i < NB_ETAGES; i++) {
	CLRF        R4 
L_prochain_req229:
	MOVLW       4
	SUBWF       R4, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req230
;Ascenseur.c,716 :: 		if (!req[i]) continue;
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
	GOTO        L_prochain_req232
	GOTO        L_prochain_req231
L_prochain_req232:
;Ascenseur.c,718 :: 		d = (i >= etage_actuel) ? (unsigned int)(i - etage_actuel)
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_prochain_req233
	MOVF        _etage_actuel+0, 0 
	SUBWF       R4, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
;Ascenseur.c,719 :: 		: (unsigned int)(etage_actuel - i);
	GOTO        L_prochain_req234
L_prochain_req233:
	MOVF        R4, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
L_prochain_req234:
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
;Ascenseur.c,721 :: 		if (d < min_d) {
	MOVF        R9, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__prochain_req511
	MOVF        R8, 0 
	SUBWF       R2, 0 
L__prochain_req511:
	BTFSC       STATUS+0, 0 
	GOTO        L_prochain_req235
;Ascenseur.c,722 :: 		min_d = d;
	MOVF        R6, 0 
	MOVWF       R8 
	MOVF        R7, 0 
	MOVWF       R9 
;Ascenseur.c,723 :: 		nearest = i;
	MOVF        R4, 0 
	MOVWF       R5 
;Ascenseur.c,724 :: 		}
L_prochain_req235:
;Ascenseur.c,725 :: 		}
L_prochain_req231:
;Ascenseur.c,715 :: 		for (i = 0; i < NB_ETAGES; i++) {
	INCF        R4, 1 
;Ascenseur.c,725 :: 		}
	GOTO        L_prochain_req229
L_prochain_req230:
;Ascenseur.c,727 :: 		if (nearest != 0xFF) {
	MOVF        R5, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_prochain_req236
;Ascenseur.c,728 :: 		req[nearest] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        R5, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,729 :: 		return nearest;
	MOVF        R5, 0 
	MOVWF       R0 
	GOTO        L_end_prochain_req
;Ascenseur.c,730 :: 		}
L_prochain_req236:
;Ascenseur.c,731 :: 		}
L_prochain_req228:
L_prochain_req218:
;Ascenseur.c,733 :: 		return 0xFF;
	MOVLW       255
	MOVWF       R0 
;Ascenseur.c,734 :: 		}
L_end_prochain_req:
	RETURN      0
; end of _prochain_req

_deplacer_vers:

;Ascenseur.c,736 :: 		void deplacer_vers(unsigned char cible) {
;Ascenseur.c,741 :: 		if (cible == etage_actuel || urgence_flag) return;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	XORWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__deplacer_vers447
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers447
	GOTO        L_deplacer_vers239
L__deplacer_vers447:
	GOTO        L_end_deplacer_vers
L_deplacer_vers239:
;Ascenseur.c,743 :: 		stop_demande = 0;
	CLRF        _stop_demande+0 
;Ascenseur.c,745 :: 		sens = (cible > etage_actuel) ? 'U' : 'D';
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers240
	MOVLW       85
	MOVWF       ?FLOC___deplacer_versT435+0 
	GOTO        L_deplacer_vers241
L_deplacer_vers240:
	MOVLW       68
	MOVWF       ?FLOC___deplacer_versT435+0 
L_deplacer_vers241:
	MOVF        ?FLOC___deplacer_versT435+0, 0 
	MOVWF       deplacer_vers_sens_L0+0 
;Ascenseur.c,746 :: 		direction = sens;
	MOVF        ?FLOC___deplacer_versT435+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,747 :: 		etage_cible = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,748 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,750 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,751 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,752 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,753 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,754 :: 		temps_debut = timer0_count;
	MOVF        _timer0_count+0, 0 
	MOVWF       deplacer_vers_temps_debut_L0+0 
	MOVF        _timer0_count+1, 0 
	MOVWF       deplacer_vers_temps_debut_L0+1 
;Ascenseur.c,756 :: 		attendre_ms(MS_FERMETURE);
	MOVLW       50
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       0
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,757 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers446
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers446
	GOTO        L_deplacer_vers244
L__deplacer_vers446:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers244:
;Ascenseur.c,759 :: 		nb_et = (cible > etage_actuel) ? (cible - etage_actuel) : (etage_actuel - cible);
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers245
	MOVF        _etage_actuel+0, 0 
	SUBWF       FARG_deplacer_vers_cible+0, 0 
	MOVWF       ?FLOC___deplacer_versT439+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT439+1 
	GOTO        L_deplacer_vers246
L_deplacer_vers245:
	MOVF        FARG_deplacer_vers_cible+0, 0 
	SUBWF       _etage_actuel+0, 0 
	MOVWF       ?FLOC___deplacer_versT439+0 
	MOVLW       0
	MOVWF       ?FLOC___deplacer_versT439+1 
L_deplacer_vers246:
	MOVF        ?FLOC___deplacer_versT439+0, 0 
	MOVWF       deplacer_vers_nb_et_L0+0 
;Ascenseur.c,761 :: 		demarrer_moteur(sens);
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       FARG_demarrer_moteur_sens+0 
	CALL        _demarrer_moteur+0, 0
;Ascenseur.c,762 :: 		lcd_update_transit();
	CALL        _lcd_update_transit+0, 0
;Ascenseur.c,764 :: 		for (i = 0; i < nb_et; i++) {
	CLRF        deplacer_vers_i_L0+0 
L_deplacer_vers247:
	MOVF        deplacer_vers_nb_et_L0+0, 0 
	SUBWF       deplacer_vers_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_deplacer_vers248
;Ascenseur.c,765 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers445
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers445
	GOTO        L_deplacer_vers252
L__deplacer_vers445:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers252:
;Ascenseur.c,767 :: 		est_dernier = (i == nb_et - 1);
	DECF        deplacer_vers_nb_et_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers513
	MOVF        R0, 0 
	XORWF       deplacer_vers_i_L0+0, 0 
L__deplacer_vers513:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       deplacer_vers_est_dernier_L0+0 
;Ascenseur.c,768 :: 		set_pwm(pwm_max_eff);
	MOVF        _pwm_max_eff+0, 0 
	MOVWF       FARG_set_pwm_duty+0 
	CALL        _set_pwm+0, 0
;Ascenseur.c,770 :: 		if (!est_dernier) {
	MOVF        deplacer_vers_est_dernier_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers253
;Ascenseur.c,771 :: 		entre_etages = 1;
	MOVLW       1
	MOVWF       _entre_etages+0 
;Ascenseur.c,772 :: 		attendre_ms(MS_CROISIERE);
	MOVLW       244
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,773 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers444
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers444
	GOTO        L_deplacer_vers256
L__deplacer_vers444:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers256:
;Ascenseur.c,774 :: 		entre_etages = 0;
	CLRF        _entre_etages+0 
;Ascenseur.c,776 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers257
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers258
L_deplacer_vers257:
;Ascenseur.c,777 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers258:
;Ascenseur.c,779 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,780 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,781 :: 		lcd_update_transit();
	CALL        _lcd_update_transit+0, 0
;Ascenseur.c,782 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,784 :: 		if (req[etage_actuel]) {
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
	GOTO        L_deplacer_vers259
;Ascenseur.c,785 :: 		req[etage_actuel] = 0;
	MOVLW       _req+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_req+0)
	MOVWF       FSR1L+1 
	MOVF        _etage_actuel+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	CLRF        POSTINC1+0 
;Ascenseur.c,786 :: 		rampe_decel();
	CALL        _rampe_decel+0, 0
;Ascenseur.c,787 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers443
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers443
	GOTO        L_deplacer_vers262
L__deplacer_vers443:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers262:
;Ascenseur.c,789 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,790 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,791 :: 		etage_cible = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,792 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,793 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,794 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,795 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,797 :: 		attendre_ms(MS_ARRET_INTERMED);
	MOVLW       244
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,798 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers442
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers442
	GOTO        L_deplacer_vers265
L__deplacer_vers442:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers265:
;Ascenseur.c,800 :: 		direction = sens;
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       _direction+0 
;Ascenseur.c,801 :: 		etage_cible = cible;
	MOVF        FARG_deplacer_vers_cible+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,802 :: 		en_mouvement = 1;
	MOVLW       1
	MOVWF       _en_mouvement+0 
;Ascenseur.c,803 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,804 :: 		attendre_ms(MS_FERMETURE);
	MOVLW       50
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       0
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,805 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers441
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers441
	GOTO        L_deplacer_vers268
L__deplacer_vers441:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers268:
;Ascenseur.c,806 :: 		demarrer_moteur(sens);
	MOVF        deplacer_vers_sens_L0+0, 0 
	MOVWF       FARG_demarrer_moteur_sens+0 
	CALL        _demarrer_moteur+0, 0
;Ascenseur.c,807 :: 		lcd_update_transit();
	CALL        _lcd_update_transit+0, 0
;Ascenseur.c,808 :: 		}
L_deplacer_vers259:
;Ascenseur.c,810 :: 		} else {
	GOTO        L_deplacer_vers269
L_deplacer_vers253:
;Ascenseur.c,811 :: 		entre_etages = 1;
	MOVLW       1
	MOVWF       _entre_etages+0 
;Ascenseur.c,812 :: 		if (nb_et == 1) attendre_ms(MS_CROISIERE_1ET);
	MOVF        deplacer_vers_nb_et_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers270
	MOVLW       124
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
	GOTO        L_deplacer_vers271
L_deplacer_vers270:
;Ascenseur.c,813 :: 		else            attendre_ms(MS_CROISIERE);
	MOVLW       244
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       1
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
L_deplacer_vers271:
;Ascenseur.c,815 :: 		if (urgence_flag || stop_demande) goto fin_deplacement;
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers440
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers440
	GOTO        L_deplacer_vers274
L__deplacer_vers440:
	GOTO        ___deplacer_vers_fin_deplacement
L_deplacer_vers274:
;Ascenseur.c,816 :: 		entre_etages = 0;
	CLRF        _entre_etages+0 
;Ascenseur.c,818 :: 		rampe_decel();
	CALL        _rampe_decel+0, 0
;Ascenseur.c,819 :: 		if (urgence_flag || stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers439
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers439
	GOTO        L_deplacer_vers277
L__deplacer_vers439:
;Ascenseur.c,820 :: 		position_inconnue = 1;
	MOVLW       1
	MOVWF       _position_inconnue+0 
;Ascenseur.c,821 :: 		goto fin_deplacement;
	GOTO        ___deplacer_vers_fin_deplacement
;Ascenseur.c,822 :: 		}
L_deplacer_vers277:
;Ascenseur.c,824 :: 		if (sens == 'U') etage_actuel++;
	MOVF        deplacer_vers_sens_L0+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers278
	INCF        _etage_actuel+0, 1 
	GOTO        L_deplacer_vers279
L_deplacer_vers278:
;Ascenseur.c,825 :: 		else             etage_actuel--;
	DECF        _etage_actuel+0, 1 
L_deplacer_vers279:
;Ascenseur.c,826 :: 		}
L_deplacer_vers269:
;Ascenseur.c,764 :: 		for (i = 0; i < nb_et; i++) {
	INCF        deplacer_vers_i_L0+0, 1 
;Ascenseur.c,827 :: 		}
	GOTO        L_deplacer_vers247
L_deplacer_vers248:
;Ascenseur.c,829 :: 		fin_deplacement:
___deplacer_vers_fin_deplacement:
;Ascenseur.c,830 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,832 :: 		if ((urgence_flag || stop_demande) && entre_etages) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers438
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__deplacer_vers438
	GOTO        L_deplacer_vers287
L__deplacer_vers438:
	MOVF        _entre_etages+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_deplacer_vers287
L__deplacer_vers437:
;Ascenseur.c,833 :: 		position_inconnue = 1;
	MOVLW       1
	MOVWF       _position_inconnue+0 
;Ascenseur.c,834 :: 		entre_etages = 0;
	CLRF        _entre_etages+0 
;Ascenseur.c,835 :: 		}
L_deplacer_vers287:
;Ascenseur.c,837 :: 		temps_trajet = timer0_count - temps_debut;
	MOVF        deplacer_vers_temps_debut_L0+0, 0 
	SUBWF       _timer0_count+0, 0 
	MOVWF       _temps_trajet+0 
	MOVF        deplacer_vers_temps_debut_L0+1, 0 
	SUBWFB      _timer0_count+1, 0 
	MOVWF       _temps_trajet+1 
;Ascenseur.c,838 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,839 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,840 :: 		etage_cible = etage_actuel;
	MOVF        _etage_actuel+0, 0 
	MOVWF       _etage_cible+0 
;Ascenseur.c,841 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,843 :: 		if (!urgence_flag && !stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers290
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers290
L__deplacer_vers436:
;Ascenseur.c,844 :: 		position_inconnue = 0;
	CLRF        _position_inconnue+0 
;Ascenseur.c,845 :: 		}
L_deplacer_vers290:
;Ascenseur.c,847 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,848 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,849 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,850 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,852 :: 		if (!urgence_flag && !stop_demande) {
	MOVF        _urgence_flag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers293
	MOVF        _stop_demande+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_deplacer_vers293
L__deplacer_vers435:
;Ascenseur.c,853 :: 		eeprom_sauver_trajet();
	CALL        _eeprom_sauver_trajet+0, 0
;Ascenseur.c,854 :: 		attendre_ms(MS_OUVERTURE);
	MOVLW       100
	MOVWF       FARG_attendre_ms_ms+0 
	MOVLW       0
	MOVWF       FARG_attendre_ms_ms+1 
	CALL        _attendre_ms+0, 0
;Ascenseur.c,855 :: 		}
L_deplacer_vers293:
;Ascenseur.c,857 :: 		stop_demande = 0;
	CLRF        _stop_demande+0 
;Ascenseur.c,858 :: 		}
L_end_deplacer_vers:
	RETURN      0
; end of _deplacer_vers

_parser_cmd:

;Ascenseur.c,860 :: 		void parser_cmd(char *buf) {
;Ascenseur.c,865 :: 		p = strstr(buf, "CALL:");
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr20_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr20_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       parser_cmd_p_L0+0 
	MOVF        R1, 0 
	MOVWF       parser_cmd_p_L0+1 
;Ascenseur.c,866 :: 		if (p) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd294
;Ascenseur.c,867 :: 		cible = (unsigned char)(*(p + 5) - '0');
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
;Ascenseur.c,868 :: 		if (cible < NB_ETAGES && mode_auto && !al_active && !surcharge_active) {
	MOVLW       4
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_parser_cmd297
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd297
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd297
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd297
L__parser_cmd450:
;Ascenseur.c,869 :: 		req[cible] = 1;
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
;Ascenseur.c,870 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,871 :: 		} else {
	GOTO        L_parser_cmd298
L_parser_cmd297:
;Ascenseur.c,872 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,873 :: 		}
L_parser_cmd298:
;Ascenseur.c,874 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,875 :: 		}
L_parser_cmd294:
;Ascenseur.c,877 :: 		if (strstr(buf, "CMD,STOP")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr21_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr21_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd299
;Ascenseur.c,878 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,879 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,880 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,881 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,882 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,883 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,884 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,885 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,886 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,887 :: 		}
L_parser_cmd299:
;Ascenseur.c,889 :: 		if (strstr(buf, "CMD,ACK")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr22_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr22_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd303
;Ascenseur.c,890 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_parser_cmd304
;Ascenseur.c,891 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,892 :: 		} else if (urg_active) {
	GOTO        L_parser_cmd305
L_parser_cmd304:
	MOVF        _urg_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd306
;Ascenseur.c,893 :: 		urg_active = 0;
	CLRF        _urg_active+0 
;Ascenseur.c,894 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,895 :: 		urgence_flag = 0;
	CLRF        _urgence_flag+0 
;Ascenseur.c,896 :: 		position_inconnue = 0;
	CLRF        _position_inconnue+0 
;Ascenseur.c,897 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,898 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,899 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,900 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,901 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,902 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,903 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,904 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,905 :: 		} else if (surcharge_active) {
	GOTO        L_parser_cmd307
L_parser_cmd306:
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd308
;Ascenseur.c,906 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,907 :: 		} else {
	GOTO        L_parser_cmd309
L_parser_cmd308:
;Ascenseur.c,908 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,909 :: 		}
L_parser_cmd309:
L_parser_cmd307:
L_parser_cmd305:
;Ascenseur.c,910 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,911 :: 		}
L_parser_cmd303:
;Ascenseur.c,913 :: 		if (strstr(buf, "MODE:AUTO")) {
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
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd310
;Ascenseur.c,914 :: 		mode_auto = 1;
	MOVLW       1
	MOVWF       _mode_auto+0 
;Ascenseur.c,915 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,916 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,917 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,918 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,919 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,920 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,921 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,922 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,923 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,924 :: 		}
L_parser_cmd310:
;Ascenseur.c,926 :: 		if (strstr(buf, "MODE:MAN")) {
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
	GOTO        L_parser_cmd311
;Ascenseur.c,927 :: 		mode_auto = 0;
	CLRF        _mode_auto+0 
;Ascenseur.c,928 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,929 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,930 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,931 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,932 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,933 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,934 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,935 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,936 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,937 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,938 :: 		}
L_parser_cmd311:
;Ascenseur.c,940 :: 		if (strstr(buf, "GET:EEP")) {
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
	GOTO        L_parser_cmd315
;Ascenseur.c,941 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,942 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,943 :: 		}
L_parser_cmd315:
;Ascenseur.c,945 :: 		if (strstr(buf, "EEP:RST") || strstr(buf, "RST:EEP")) {
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
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd449
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
	BTFSS       STATUS+0, 2 
	GOTO        L__parser_cmd449
	GOTO        L_parser_cmd318
L__parser_cmd449:
;Ascenseur.c,946 :: 		eeprom_reset();
	CALL        _eeprom_reset+0, 0
;Ascenseur.c,947 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,948 :: 		uart_send_eeprom();
	CALL        _uart_send_eeprom+0, 0
;Ascenseur.c,949 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,950 :: 		}
L_parser_cmd318:
;Ascenseur.c,952 :: 		p = strstr(buf, "PMAX:");
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
	MOVWF       parser_cmd_p_L0+0 
	MOVF        R1, 0 
	MOVWF       parser_cmd_p_L0+1 
;Ascenseur.c,953 :: 		if (p) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd319
;Ascenseur.c,954 :: 		pv = 0;
	CLRF        parser_cmd_pv_L0+0 
	CLRF        parser_cmd_pv_L0+1 
;Ascenseur.c,955 :: 		p += 5;
	MOVLW       5
	ADDWF       parser_cmd_p_L0+0, 1 
	MOVLW       0
	ADDWFC      parser_cmd_p_L0+1, 1 
;Ascenseur.c,956 :: 		while (*p >= '0' && *p <= '9') {
L_parser_cmd320:
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd321
	MOVFF       parser_cmd_p_L0+0, FSR0L+0
	MOVFF       parser_cmd_p_L0+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_parser_cmd321
L__parser_cmd448:
;Ascenseur.c,957 :: 		pv = pv * 10 + (unsigned int)(*p - '0');
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
;Ascenseur.c,958 :: 		p++;
	INFSNZ      parser_cmd_p_L0+0, 1 
	INCF        parser_cmd_p_L0+1, 1 
;Ascenseur.c,959 :: 		}
	GOTO        L_parser_cmd320
L_parser_cmd321:
;Ascenseur.c,960 :: 		appliquer_pmax(pv);
	MOVF        parser_cmd_pv_L0+0, 0 
	MOVWF       FARG_appliquer_pmax_val+0 
	MOVF        parser_cmd_pv_L0+1, 0 
	MOVWF       FARG_appliquer_pmax_val+1 
	CALL        _appliquer_pmax+0, 0
;Ascenseur.c,961 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,962 :: 		}
L_parser_cmd319:
;Ascenseur.c,964 :: 		if (strstr(buf, "AL:ON")) {
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
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd324
;Ascenseur.c,965 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,966 :: 		al_flag = 1;
	MOVLW       1
	MOVWF       _al_flag+0 
;Ascenseur.c,967 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,968 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,969 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,970 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,971 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,972 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,973 :: 		}
L_parser_cmd324:
;Ascenseur.c,975 :: 		if (strstr(buf, "RST:AL")) {
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
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd328
;Ascenseur.c,976 :: 		if (!urg_active) {
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd329
;Ascenseur.c,977 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,978 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,979 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,980 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,981 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,982 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,983 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,984 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,985 :: 		} else {
	GOTO        L_parser_cmd330
L_parser_cmd329:
;Ascenseur.c,986 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,987 :: 		}
L_parser_cmd330:
;Ascenseur.c,988 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,989 :: 		}
L_parser_cmd328:
;Ascenseur.c,991 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,992 :: 		}
L_end_parser_cmd:
	RETURN      0
; end of _parser_cmd

_init_timer1:

;Ascenseur.c,994 :: 		void init_timer1() {
;Ascenseur.c,995 :: 		T1CON = 0x00;
	CLRF        T1CON+0 
;Ascenseur.c,996 :: 		TMR1H = 0xFE;
	MOVLW       254
	MOVWF       TMR1H+0 
;Ascenseur.c,997 :: 		TMR1L = 0x0C;
	MOVLW       12
	MOVWF       TMR1L+0 
;Ascenseur.c,998 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Ascenseur.c,999 :: 		TMR1IE_bit = 1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;Ascenseur.c,1000 :: 		TMR1ON_bit = 1;
	BSF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;Ascenseur.c,1001 :: 		}
L_end_init_timer1:
	RETURN      0
; end of _init_timer1

_main:

;Ascenseur.c,1003 :: 		void main() {
;Ascenseur.c,1008 :: 		PWM1_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;Ascenseur.c,1009 :: 		PWM1_Set_Duty(0);
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;Ascenseur.c,1010 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;Ascenseur.c,1012 :: 		ANSELA = 0x02;
	MOVLW       2
	MOVWF       ANSELA+0 
;Ascenseur.c,1013 :: 		TRISA0_bit = 1;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Ascenseur.c,1014 :: 		TRISA1_bit = 1;
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,1015 :: 		TRISA2_bit = 0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;Ascenseur.c,1016 :: 		TRISA3_bit = 0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;Ascenseur.c,1017 :: 		LATA2_bit = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;Ascenseur.c,1018 :: 		LATA3_bit = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1020 :: 		ANSELB = 0x00;
	CLRF        ANSELB+0 
;Ascenseur.c,1021 :: 		TRISB6_bit = 1;
	BSF         TRISB6_bit+0, BitPos(TRISB6_bit+0) 
;Ascenseur.c,1022 :: 		TRISB7_bit = 1;
	BSF         TRISB7_bit+0, BitPos(TRISB7_bit+0) 
;Ascenseur.c,1023 :: 		INTCON2.RBPU = 1;
	BSF         INTCON2+0, 7 
;Ascenseur.c,1025 :: 		ANSELC = 0x00;
	CLRF        ANSELC+0 
;Ascenseur.c,1026 :: 		TRISC0_bit = 0;
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;Ascenseur.c,1027 :: 		TRISC1_bit = 0;
	BCF         TRISC1_bit+0, BitPos(TRISC1_bit+0) 
;Ascenseur.c,1028 :: 		TRISC2_bit = 0;
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;Ascenseur.c,1029 :: 		TRISC3_bit = 0;
	BCF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;Ascenseur.c,1030 :: 		TRISC4_bit = 1;
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;Ascenseur.c,1031 :: 		TRISC5_bit = 0;
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;Ascenseur.c,1032 :: 		TRISC6_bit = 0;
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;Ascenseur.c,1033 :: 		TRISC7_bit = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;Ascenseur.c,1034 :: 		LATC0_bit = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;Ascenseur.c,1035 :: 		LATC1_bit = 0;
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;Ascenseur.c,1036 :: 		LATC5_bit = 0;
	BCF         LATC5_bit+0, BitPos(LATC5_bit+0) 
;Ascenseur.c,1038 :: 		ANSELD = 0x00;
	CLRF        ANSELD+0 
;Ascenseur.c,1039 :: 		TRISD = 0xFF;
	MOVLW       255
	MOVWF       TRISD+0 
;Ascenseur.c,1041 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;Ascenseur.c,1042 :: 		ANSELA = 0x02;
	MOVLW       2
	MOVWF       ANSELA+0 
;Ascenseur.c,1043 :: 		TRISA0_bit = 1;
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Ascenseur.c,1044 :: 		TRISA1_bit = 1;
	BSF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;Ascenseur.c,1046 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Ascenseur.c,1047 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main331:
	DECFSZ      R13, 1, 1
	BRA         L_main331
	DECFSZ      R12, 1, 1
	BRA         L_main331
	DECFSZ      R11, 1, 1
	BRA         L_main331
	NOP
;Ascenseur.c,1049 :: 		I2C1_Init(100000);
	MOVLW       20
	MOVWF       SSP1ADD+0 
	CALL        _I2C1_Init+0, 0
;Ascenseur.c,1050 :: 		Delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_main332:
	DECFSZ      R13, 1, 1
	BRA         L_main332
	DECFSZ      R12, 1, 1
	BRA         L_main332
	NOP
;Ascenseur.c,1052 :: 		eeprom_charger();
	CALL        _eeprom_charger+0, 0
;Ascenseur.c,1054 :: 		T0CON = 0x07;
	MOVLW       7
	MOVWF       T0CON+0 
;Ascenseur.c,1055 :: 		TMR0H = T0_RELOAD_H;
	MOVLW       194
	MOVWF       TMR0H+0 
;Ascenseur.c,1056 :: 		TMR0L = T0_RELOAD_L;
	MOVLW       247
	MOVWF       TMR0L+0 
;Ascenseur.c,1057 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Ascenseur.c,1058 :: 		TMR0IE_bit = 1;
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;Ascenseur.c,1060 :: 		init_timer1();
	CALL        _init_timer1+0, 0
;Ascenseur.c,1062 :: 		RC1IE_bit = 1;
	BSF         RC1IE_bit+0, BitPos(RC1IE_bit+0) 
;Ascenseur.c,1063 :: 		PEIE_bit = 1;
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;Ascenseur.c,1064 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,1065 :: 		T0CON = 0x87;
	MOVLW       135
	MOVWF       T0CON+0 
;Ascenseur.c,1067 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;Ascenseur.c,1068 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1069 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1070 :: 		Lcd_Out(1, 1, " ASCENSEUR 4ET  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr31_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr31_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1071 :: 		Lcd_Out(2, 1, "  Pret  - ET:0  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr32_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr32_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1072 :: 		Delay_ms(1500);
	MOVLW       16
	MOVWF       R11, 0
	MOVLW       57
	MOVWF       R12, 0
	MOVLW       13
	MOVWF       R13, 0
L_main333:
	DECFSZ      R13, 1, 1
	BRA         L_main333
	DECFSZ      R12, 1, 1
	BRA         L_main333
	DECFSZ      R11, 1, 1
	BRA         L_main333
	NOP
	NOP
;Ascenseur.c,1073 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1075 :: 		UART1_Write_Text("<DATA,ET:0,DIR:0,PT:0,PRT:0,AL:0,URG:0,NB:0,PWM:0,TPS:0>\r\n");
	MOVLW       ?lstr33_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr33_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,1077 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1078 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1079 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1081 :: 		while (1) {
L_main334:
;Ascenseur.c,1083 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main338
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main338
L__main456:
;Ascenseur.c,1084 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main339:
	DECFSZ      R13, 1, 1
	BRA         L_main339
	DECFSZ      R12, 1, 1
	BRA         L_main339
	NOP
	NOP
;Ascenseur.c,1085 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main340
;Ascenseur.c,1086 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1087 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1088 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1089 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,1090 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1091 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,1092 :: 		}
L_main340:
;Ascenseur.c,1093 :: 		}
L_main338:
;Ascenseur.c,1095 :: 		if (urgence_flag) {
	MOVF        _urgence_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main344
;Ascenseur.c,1096 :: 		urgence_flag = 0;
	CLRF        _urgence_flag+0 
;Ascenseur.c,1097 :: 		etat_surcharge = 0;
	CLRF        _etat_surcharge+0 
;Ascenseur.c,1098 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1099 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1100 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1101 :: 		vider_req();
	CALL        _vider_req+0, 0
;Ascenseur.c,1103 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1104 :: 		Lcd_Out(1, 1, " ARRET URGENCE  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr34_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr34_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1105 :: 		if (position_inconnue) Lcd_Out(2, 1, "POS?-ACQ:BP/PC  ");
	MOVF        _position_inconnue+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main348
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr35_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr35_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_main349
L_main348:
;Ascenseur.c,1106 :: 		else                   Lcd_Out(2, 1, "ACQ : BP ou PC  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr36_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr36_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_main349:
;Ascenseur.c,1108 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1109 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1110 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1113 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L3+0 
;Ascenseur.c,1114 :: 		while (acq_recu == 0) {
L_main350:
	MOVF        main_acq_recu_L3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main351
;Ascenseur.c,1115 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main352:
	DECFSZ      R13, 1, 1
	BRA         L_main352
	DECFSZ      R12, 1, 1
	BRA         L_main352
	NOP
	NOP
;Ascenseur.c,1116 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main353
;Ascenseur.c,1117 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1118 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1119 :: 		}
L_main353:
;Ascenseur.c,1121 :: 		if (BP_ACQ && !BP_URGENCE) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main356
	BTFSC       PORTB+0, 6 
	GOTO        L_main356
L__main455:
;Ascenseur.c,1122 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main357:
	DECFSZ      R13, 1, 1
	BRA         L_main357
	DECFSZ      R12, 1, 1
	BRA         L_main357
	NOP
	NOP
;Ascenseur.c,1123 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3+0 
;Ascenseur.c,1124 :: 		}
L_main356:
;Ascenseur.c,1126 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main358
;Ascenseur.c,1127 :: 		if (strstr(cmd, "CMD,ACK") && !BP_URGENCE)
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr37_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr37_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main361
	BTFSC       PORTB+0, 6 
	GOTO        L_main361
L__main454:
;Ascenseur.c,1128 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3+0 
L_main361:
;Ascenseur.c,1129 :: 		}
L_main358:
;Ascenseur.c,1130 :: 		}
	GOTO        L_main350
L_main351:
;Ascenseur.c,1131 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main362:
	DECFSZ      R13, 1, 1
	BRA         L_main362
	DECFSZ      R12, 1, 1
	BRA         L_main362
	DECFSZ      R11, 1, 1
	BRA         L_main362
;Ascenseur.c,1134 :: 		urg_active = 0;
	CLRF        _urg_active+0 
;Ascenseur.c,1135 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1136 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1137 :: 		position_inconnue = 0;
	CLRF        _position_inconnue+0 
;Ascenseur.c,1138 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1139 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1140 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1142 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1143 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1144 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1145 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1146 :: 		}
L_main344:
;Ascenseur.c,1148 :: 		if (al_flag) {
	MOVF        _al_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main363
;Ascenseur.c,1149 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1150 :: 		vider_req();
	CALL        _vider_req+0, 0
;Ascenseur.c,1152 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1153 :: 		Lcd_Out(1, 1, "   ALARME !!!   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr38_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr38_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1154 :: 		Lcd_Out(2, 1, "ACQ : BP ou PC  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr39_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr39_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1155 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1158 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L3_L3+0 
;Ascenseur.c,1159 :: 		while (acq_recu == 0) {
L_main364:
	MOVF        main_acq_recu_L3_L3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main365
;Ascenseur.c,1160 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main366:
	DECFSZ      R13, 1, 1
	BRA         L_main366
	DECFSZ      R12, 1, 1
	BRA         L_main366
	NOP
	NOP
;Ascenseur.c,1161 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main367
;Ascenseur.c,1162 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1163 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1164 :: 		}
L_main367:
;Ascenseur.c,1165 :: 		if (BP_ACQ) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main368
;Ascenseur.c,1166 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main369:
	DECFSZ      R13, 1, 1
	BRA         L_main369
	DECFSZ      R12, 1, 1
	BRA         L_main369
	NOP
	NOP
;Ascenseur.c,1167 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3_L3+0 
;Ascenseur.c,1168 :: 		}
L_main368:
;Ascenseur.c,1169 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main370
;Ascenseur.c,1170 :: 		if (strstr(cmd, "RST:AL"))
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr40_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr40_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main371
;Ascenseur.c,1171 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3_L3+0 
L_main371:
;Ascenseur.c,1172 :: 		}
L_main370:
;Ascenseur.c,1173 :: 		}
	GOTO        L_main364
L_main365:
;Ascenseur.c,1174 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main372:
	DECFSZ      R13, 1, 1
	BRA         L_main372
	DECFSZ      R12, 1, 1
	BRA         L_main372
	DECFSZ      R11, 1, 1
	BRA         L_main372
;Ascenseur.c,1177 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1178 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1179 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1180 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1181 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1182 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1183 :: 		}
L_main363:
;Ascenseur.c,1185 :: 		if (BP_ALARME && !al_active) {
	BTFSS       PORTB+0, 7 
	GOTO        L_main375
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main375
L__main453:
;Ascenseur.c,1186 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main376:
	DECFSZ      R13, 1, 1
	BRA         L_main376
	DECFSZ      R12, 1, 1
	BRA         L_main376
	NOP
	NOP
;Ascenseur.c,1187 :: 		if (BP_ALARME) {
	BTFSS       PORTB+0, 7 
	GOTO        L_main377
;Ascenseur.c,1188 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,1189 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,1190 :: 		en_mouvement = 0;
	CLRF        _en_mouvement+0 
;Ascenseur.c,1191 :: 		MOTEUR_ARRETER();
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	CLRF        _moteur_actif+0 
	CLRF        _pwm_actuel+0 
;Ascenseur.c,1192 :: 		vider_req();
	CALL        _vider_req+0, 0
;Ascenseur.c,1194 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1195 :: 		Lcd_Out(1, 1, "   ALARME !!!   ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr41_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr41_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1196 :: 		Lcd_Out(2, 1, "ACQ : BP ou PC  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr42_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr42_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1197 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1200 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L4+0 
;Ascenseur.c,1201 :: 		while (acq_recu == 0) {
L_main381:
	MOVF        main_acq_recu_L4+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main382
;Ascenseur.c,1202 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main383:
	DECFSZ      R13, 1, 1
	BRA         L_main383
	DECFSZ      R12, 1, 1
	BRA         L_main383
	NOP
	NOP
;Ascenseur.c,1203 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main384
;Ascenseur.c,1204 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1205 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1206 :: 		}
L_main384:
;Ascenseur.c,1207 :: 		if (BP_ACQ) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main385
;Ascenseur.c,1208 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main386:
	DECFSZ      R13, 1, 1
	BRA         L_main386
	DECFSZ      R12, 1, 1
	BRA         L_main386
	NOP
	NOP
;Ascenseur.c,1209 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L4+0 
;Ascenseur.c,1210 :: 		}
L_main385:
;Ascenseur.c,1211 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main387
;Ascenseur.c,1212 :: 		if (strstr(cmd, "RST:AL"))
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr43_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr43_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main388
;Ascenseur.c,1213 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L4+0 
L_main388:
;Ascenseur.c,1214 :: 		}
L_main387:
;Ascenseur.c,1215 :: 		}
	GOTO        L_main381
L_main382:
;Ascenseur.c,1216 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main389:
	DECFSZ      R13, 1, 1
	BRA         L_main389
	DECFSZ      R12, 1, 1
	BRA         L_main389
	DECFSZ      R11, 1, 1
	BRA         L_main389
;Ascenseur.c,1219 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,1220 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,1221 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1222 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1223 :: 		maj_surcharge(1);
	MOVLW       1
	MOVWF       FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1224 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1225 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1226 :: 		}
L_main377:
;Ascenseur.c,1227 :: 		}
L_main375:
;Ascenseur.c,1229 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1230 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1232 :: 		while (pop_cmd(cmd)) {
L_main390:
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main391
;Ascenseur.c,1233 :: 		parser_cmd(cmd);
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_parser_cmd_buf+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_parser_cmd_buf+1 
	CALL        _parser_cmd+0, 0
;Ascenseur.c,1234 :: 		}
	GOTO        L_main390
L_main391:
;Ascenseur.c,1236 :: 		gerer_leds();
	CALL        _gerer_leds+0, 0
;Ascenseur.c,1238 :: 		if (!urg_active && !al_active) {
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main394
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main394
L__main452:
;Ascenseur.c,1239 :: 		surge_now = surcharge_active ? 1 : 0;
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main395
	MOVLW       1
	MOVWF       ?FLOC___mainT563+0 
	GOTO        L_main396
L_main395:
	CLRF        ?FLOC___mainT563+0 
L_main396:
	MOVF        ?FLOC___mainT563+0, 0 
	MOVWF       main_surge_now_L0+0 
;Ascenseur.c,1240 :: 		if (surge_now != etat_surcharge) {
	MOVF        ?FLOC___mainT563+0, 0 
	XORWF       _etat_surcharge+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main397
;Ascenseur.c,1241 :: 		etat_surcharge = surge_now;
	MOVF        main_surge_now_L0+0, 0 
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1242 :: 		if (!moteur_actif) lcd_transition();
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main398
	CALL        _lcd_transition+0, 0
L_main398:
;Ascenseur.c,1243 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1244 :: 		}
L_main397:
;Ascenseur.c,1245 :: 		}
L_main394:
;Ascenseur.c,1247 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main399
;Ascenseur.c,1248 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,1249 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1250 :: 		if (moteur_actif) lcd_update_transit();
	MOVF        _moteur_actif+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main400
	CALL        _lcd_update_transit+0, 0
	GOTO        L_main401
L_main400:
;Ascenseur.c,1251 :: 		else              afficher_lcd();
	CALL        _afficher_lcd+0, 0
L_main401:
;Ascenseur.c,1252 :: 		}
L_main399:
;Ascenseur.c,1254 :: 		if (mode_auto && !urg_active && !al_active && !position_inconnue) {
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main404
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main404
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main404
	MOVF        _position_inconnue+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main404
L__main451:
;Ascenseur.c,1255 :: 		if (!surcharge_active) {
	MOVF        _surcharge_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main405
;Ascenseur.c,1256 :: 		scanner_req();
	CALL        _scanner_req+0, 0
;Ascenseur.c,1257 :: 		prochain = prochain_req();
	CALL        _prochain_req+0, 0
	MOVF        R0, 0 
	MOVWF       main_prochain_L0+0 
;Ascenseur.c,1259 :: 		if (prochain != 0xFF) {
	MOVF        R0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_main406
;Ascenseur.c,1260 :: 		lire_capteurs();
	CALL        _lire_capteurs+0, 0
;Ascenseur.c,1261 :: 		maj_surcharge(0);
	CLRF        FARG_maj_surcharge_force_transition+0 
	CALL        _maj_surcharge+0, 0
;Ascenseur.c,1263 :: 		if (ir_porte == 1) {
	MOVF        _ir_porte+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main407
;Ascenseur.c,1264 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Ascenseur.c,1265 :: 		Lcd_Out(1, 1, "PORTE OUVERTE!  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr44_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr44_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1266 :: 		Lcd_Out(2, 1, "Veuillez fermer ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr45_Ascenseur+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr45_Ascenseur+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Ascenseur.c,1267 :: 		Delay_ms(2000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main408:
	DECFSZ      R13, 1, 1
	BRA         L_main408
	DECFSZ      R12, 1, 1
	BRA         L_main408
	DECFSZ      R11, 1, 1
	BRA         L_main408
	NOP
;Ascenseur.c,1268 :: 		lcd_transition();
	CALL        _lcd_transition+0, 0
;Ascenseur.c,1269 :: 		}
	GOTO        L_main409
L_main407:
;Ascenseur.c,1270 :: 		else if (surcharge_active) {
	MOVF        _surcharge_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main410
;Ascenseur.c,1271 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,1272 :: 		}
	GOTO        L_main411
L_main410:
;Ascenseur.c,1274 :: 		deplacer_vers(prochain);
	MOVF        main_prochain_L0+0, 0 
	MOVWF       FARG_deplacer_vers_cible+0 
	CALL        _deplacer_vers+0, 0
;Ascenseur.c,1275 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,1276 :: 		etat_surcharge = 0xFF;
	MOVLW       255
	MOVWF       _etat_surcharge+0 
;Ascenseur.c,1277 :: 		}
L_main411:
L_main409:
;Ascenseur.c,1278 :: 		}
L_main406:
;Ascenseur.c,1279 :: 		}
L_main405:
;Ascenseur.c,1280 :: 		}
L_main404:
;Ascenseur.c,1282 :: 		if (!moteur_actif) afficher_lcd();
	MOVF        _moteur_actif+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main412
	CALL        _afficher_lcd+0, 0
L_main412:
;Ascenseur.c,1283 :: 		Delay_ms(MS_LOOP_STEP);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main413:
	DECFSZ      R13, 1, 1
	BRA         L_main413
	DECFSZ      R12, 1, 1
	BRA         L_main413
	NOP
	NOP
;Ascenseur.c,1284 :: 		}
	GOTO        L_main334
;Ascenseur.c,1285 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
