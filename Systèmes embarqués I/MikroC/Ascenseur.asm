
_interrupt:

;Ascenseur.c,54 :: 		void interrupt() {
;Ascenseur.c,57 :: 		if (TMR0IE_bit && TMR0IF_bit) {
	BTFSS       TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
	GOTO        L_interrupt2
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt2
L__interrupt95:
;Ascenseur.c,58 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Ascenseur.c,59 :: 		TMR0H = T0_RELOAD_H;
	MOVLW       194
	MOVWF       TMR0H+0 
;Ascenseur.c,60 :: 		TMR0L = T0_RELOAD_L;
	MOVLW       247
	MOVWF       TMR0L+0 
;Ascenseur.c,61 :: 		timer0_flag = 1;
	MOVLW       1
	MOVWF       _timer0_flag+0 
;Ascenseur.c,62 :: 		timer0_count++;
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
;Ascenseur.c,63 :: 		}
L_interrupt2:
;Ascenseur.c,65 :: 		if (TMR1IE_bit && TMR1IF_bit) {
	BTFSS       TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
	GOTO        L_interrupt5
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt5
L__interrupt94:
;Ascenseur.c,66 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Ascenseur.c,67 :: 		TMR1H = 0xFE;
	MOVLW       254
	MOVWF       TMR1H+0 
;Ascenseur.c,68 :: 		TMR1L = 0x0C;
	MOVLW       12
	MOVWF       TMR1L+0 
;Ascenseur.c,69 :: 		if (al_active) BUZZER = ~BUZZER;
	MOVF        _al_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt6
	BTG         LATC5_bit+0, BitPos(LATC5_bit+0) 
	GOTO        L_interrupt7
L_interrupt6:
;Ascenseur.c,70 :: 		else           BUZZER = 0;
	BCF         LATC5_bit+0, BitPos(LATC5_bit+0) 
L_interrupt7:
;Ascenseur.c,71 :: 		}
L_interrupt5:
;Ascenseur.c,73 :: 		if (RC1IE_bit && RC1IF_bit) {
	BTFSS       RC1IE_bit+0, BitPos(RC1IE_bit+0) 
	GOTO        L_interrupt10
	BTFSS       RC1IF_bit+0, BitPos(RC1IF_bit+0) 
	GOTO        L_interrupt10
L__interrupt93:
;Ascenseur.c,78 :: 		if (OERR1_bit) {
	BTFSS       OERR1_bit+0, BitPos(OERR1_bit+0) 
	GOTO        L_interrupt11
;Ascenseur.c,79 :: 		CREN1_bit = 0;
	BCF         CREN1_bit+0, BitPos(CREN1_bit+0) 
;Ascenseur.c,80 :: 		CREN1_bit = 1;
	BSF         CREN1_bit+0, BitPos(CREN1_bit+0) 
;Ascenseur.c,81 :: 		}
L_interrupt11:
;Ascenseur.c,83 :: 		c = RCREG1;
	MOVF        RCREG1+0, 0 
	MOVWF       interrupt_c_L0+0 
;Ascenseur.c,85 :: 		if (c == '<') {
	MOVF        interrupt_c_L0+0, 0 
	XORLW       60
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt12
;Ascenseur.c,86 :: 		rx_idx = 0;
	CLRF        _rx_idx+0 
;Ascenseur.c,87 :: 		}
L_interrupt12:
;Ascenseur.c,89 :: 		if (rx_idx < 48) {
	MOVLW       48
	SUBWF       _rx_idx+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt13
;Ascenseur.c,90 :: 		rx_buf[rx_idx++] = c;
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
;Ascenseur.c,91 :: 		}
L_interrupt13:
;Ascenseur.c,93 :: 		if (c == '>') {
	MOVF        interrupt_c_L0+0, 0 
	XORLW       62
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
;Ascenseur.c,94 :: 		if (rx_idx >= 5 && rx_buf[0] == '<') {
	MOVLW       5
	SUBWF       _rx_idx+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt17
	MOVF        _rx_buf+0, 0 
	XORLW       60
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt17
L__interrupt92:
;Ascenseur.c,95 :: 		nxt = (unsigned char)((cmd_qtail + 1) & (CMD_QSIZE - 1));
	MOVF        _cmd_qtail+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVLW       3
	ANDWF       R0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       interrupt_nxt_L1+0 
;Ascenseur.c,96 :: 		if (nxt != cmd_qhead) {
	MOVF        R1, 0 
	XORWF       _cmd_qhead+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt18
;Ascenseur.c,97 :: 		n = rx_idx;
	MOVF        _rx_idx+0, 0 
	MOVWF       interrupt_n_L1+0 
;Ascenseur.c,98 :: 		if (n > (CMD_QLEN - 2)) n = CMD_QLEN - 2;
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt102
	MOVF        interrupt_n_L1+0, 0 
	SUBLW       38
L__interrupt102:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt19
	MOVLW       38
	MOVWF       interrupt_n_L1+0 
L_interrupt19:
;Ascenseur.c,99 :: 		for (j = 0; j < n; j++)
	CLRF        interrupt_j_L1+0 
L_interrupt20:
	MOVF        interrupt_n_L1+0, 0 
	SUBWF       interrupt_j_L1+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt21
;Ascenseur.c,100 :: 		cmd_queue[cmd_qtail][j] = rx_buf[j];
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
;Ascenseur.c,99 :: 		for (j = 0; j < n; j++)
	INCF        interrupt_j_L1+0, 1 
;Ascenseur.c,100 :: 		cmd_queue[cmd_qtail][j] = rx_buf[j];
	GOTO        L_interrupt20
L_interrupt21:
;Ascenseur.c,101 :: 		cmd_queue[cmd_qtail][n] = '\0';
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
;Ascenseur.c,102 :: 		cmd_qtail = nxt;
	MOVF        interrupt_nxt_L1+0, 0 
	MOVWF       _cmd_qtail+0 
;Ascenseur.c,103 :: 		}
L_interrupt18:
;Ascenseur.c,104 :: 		}
L_interrupt17:
;Ascenseur.c,105 :: 		rx_idx = 0;
	CLRF        _rx_idx+0 
;Ascenseur.c,106 :: 		}
L_interrupt14:
;Ascenseur.c,107 :: 		}
L_interrupt10:
;Ascenseur.c,108 :: 		}
L_end_interrupt:
L__interrupt101:
	RETFIE      1
; end of _interrupt

_eep_write_byte:

;Ascenseur.c,110 :: 		void eep_write_byte(unsigned char addr, unsigned char val) {
;Ascenseur.c,111 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Ascenseur.c,112 :: 		I2C1_Wr(EEPROM_W);
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,113 :: 		I2C1_Wr(addr);
	MOVF        FARG_eep_write_byte_addr+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,114 :: 		I2C1_Wr(val);
	MOVF        FARG_eep_write_byte_val+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,115 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Ascenseur.c,116 :: 		Delay_ms(10);
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
;Ascenseur.c,117 :: 		}
L_end_eep_write_byte:
	RETURN      0
; end of _eep_write_byte

_eep_read_byte:

;Ascenseur.c,119 :: 		unsigned char eep_read_byte(unsigned char addr) {
;Ascenseur.c,121 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Ascenseur.c,122 :: 		I2C1_Wr(EEPROM_W);
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,123 :: 		I2C1_Wr(addr);
	MOVF        FARG_eep_read_byte_addr+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,124 :: 		I2C1_Repeated_Start();
	CALL        _I2C1_Repeated_Start+0, 0
;Ascenseur.c,125 :: 		I2C1_Wr(EEPROM_R);
	MOVLW       161
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Ascenseur.c,126 :: 		val = I2C1_Rd(0);
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       eep_read_byte_val_L0+0 
;Ascenseur.c,127 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Ascenseur.c,128 :: 		return val;
	MOVF        eep_read_byte_val_L0+0, 0 
	MOVWF       R0 
;Ascenseur.c,129 :: 		}
L_end_eep_read_byte:
	RETURN      0
; end of _eep_read_byte

_eep_write_word:

;Ascenseur.c,131 :: 		void eep_write_word(unsigned char addr, unsigned int val) {
;Ascenseur.c,132 :: 		eep_write_byte(addr,     (unsigned char)(val >> 8));
	MOVF        FARG_eep_write_word_addr+0, 0 
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVF        FARG_eep_write_word_val+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,133 :: 		eep_write_byte(addr + 1, (unsigned char)(val & 0xFF));
	MOVF        FARG_eep_write_word_addr+0, 0 
	ADDLW       1
	MOVWF       FARG_eep_write_byte_addr+0 
	MOVLW       255
	ANDWF       FARG_eep_write_word_val+0, 0 
	MOVWF       FARG_eep_write_byte_val+0 
	CALL        _eep_write_byte+0, 0
;Ascenseur.c,134 :: 		}
L_end_eep_write_word:
	RETURN      0
; end of _eep_write_word

_eep_read_word:

;Ascenseur.c,136 :: 		unsigned int eep_read_word(unsigned char addr) {
;Ascenseur.c,137 :: 		unsigned int hi = (unsigned int)eep_read_byte(addr);
	MOVF        FARG_eep_read_word_addr+0, 0 
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       eep_read_word_hi_L0+0 
	MOVLW       0
	MOVWF       eep_read_word_hi_L0+1 
;Ascenseur.c,138 :: 		unsigned int lo = (unsigned int)eep_read_byte(addr + 1);
	MOVF        FARG_eep_read_word_addr+0, 0 
	ADDLW       1
	MOVWF       FARG_eep_read_byte_addr+0 
	CALL        _eep_read_byte+0, 0
	MOVF        R0, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
;Ascenseur.c,139 :: 		return (hi << 8) | lo;
	MOVF        eep_read_word_hi_L0+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R3, 0 
	IORWF       R0, 1 
	MOVF        R4, 0 
	IORWF       R1, 1 
;Ascenseur.c,140 :: 		}
L_end_eep_read_word:
	RETURN      0
; end of _eep_read_word

_pop_cmd:

;Ascenseur.c,142 :: 		unsigned char pop_cmd(char *dest) {
;Ascenseur.c,144 :: 		if (cmd_qhead == cmd_qtail) return 0;
	MOVF        _cmd_qhead+0, 0 
	XORWF       _cmd_qtail+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_pop_cmd24
	CLRF        R0 
	GOTO        L_end_pop_cmd
L_pop_cmd24:
;Ascenseur.c,145 :: 		GIE_bit = 0;
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,146 :: 		for (i = 0; i < (CMD_QLEN - 1); i++)
	CLRF        pop_cmd_i_L0+0 
L_pop_cmd25:
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pop_cmd108
	MOVLW       39
	SUBWF       pop_cmd_i_L0+0, 0 
L__pop_cmd108:
	BTFSC       STATUS+0, 0 
	GOTO        L_pop_cmd26
;Ascenseur.c,147 :: 		dest[i] = cmd_queue[cmd_qhead][i];
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
;Ascenseur.c,146 :: 		for (i = 0; i < (CMD_QLEN - 1); i++)
	INCF        pop_cmd_i_L0+0, 1 
;Ascenseur.c,147 :: 		dest[i] = cmd_queue[cmd_qhead][i];
	GOTO        L_pop_cmd25
L_pop_cmd26:
;Ascenseur.c,148 :: 		dest[CMD_QLEN - 1] = '\0';
	MOVLW       39
	ADDWF       FARG_pop_cmd_dest+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_pop_cmd_dest+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;Ascenseur.c,149 :: 		cmd_qhead = (unsigned char)((cmd_qhead + 1) & (CMD_QSIZE - 1));
	MOVF        _cmd_qhead+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVLW       3
	ANDWF       R0, 0 
	MOVWF       _cmd_qhead+0 
;Ascenseur.c,150 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,151 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
;Ascenseur.c,152 :: 		}
L_end_pop_cmd:
	RETURN      0
; end of _pop_cmd

_uart_send_data:

;Ascenseur.c,154 :: 		void uart_send_data() {
;Ascenseur.c,158 :: 		if (suppress_data_count > 0) {
	MOVF        _suppress_data_count+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_uart_send_data28
;Ascenseur.c,159 :: 		suppress_data_count--;
	DECF        _suppress_data_count+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _suppress_data_count+0 
;Ascenseur.c,160 :: 		return;
	GOTO        L_end_uart_send_data
;Ascenseur.c,161 :: 		}
L_uart_send_data28:
;Ascenseur.c,163 :: 		if      (direction == 'U') dir_n = 1;
	MOVF        _direction+0, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data29
	MOVLW       1
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data30
L_uart_send_data29:
;Ascenseur.c,164 :: 		else if (direction == 'D') dir_n = 2;
	MOVF        _direction+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_uart_send_data31
	MOVLW       2
	MOVWF       uart_send_data_dir_n_L0+0 
	GOTO        L_uart_send_data32
L_uart_send_data31:
;Ascenseur.c,165 :: 		else                       dir_n = 0;
	CLRF        uart_send_data_dir_n_L0+0 
L_uart_send_data32:
L_uart_send_data30:
;Ascenseur.c,167 :: 		prt_n = mode_auto ? (ir_porte ? 1 : 0) : (porte_cmd ? 1 : 0);
	MOVF        _mode_auto+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data33
	MOVF        _ir_porte+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data35
	MOVLW       1
	MOVWF       ?FLOC___uart_send_dataT72+0 
	GOTO        L_uart_send_data36
L_uart_send_data35:
	CLRF        ?FLOC___uart_send_dataT72+0 
L_uart_send_data36:
	MOVF        ?FLOC___uart_send_dataT72+0, 0 
	MOVWF       ?FLOC___uart_send_dataT73+0 
	GOTO        L_uart_send_data34
L_uart_send_data33:
	MOVF        _porte_cmd+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_uart_send_data37
	MOVLW       1
	MOVWF       ?FLOC___uart_send_dataT74+0 
	GOTO        L_uart_send_data38
L_uart_send_data37:
	CLRF        ?FLOC___uart_send_dataT74+0 
L_uart_send_data38:
	MOVF        ?FLOC___uart_send_dataT74+0, 0 
	MOVWF       ?FLOC___uart_send_dataT73+0 
L_uart_send_data34:
;Ascenseur.c,169 :: 		sprintf(trame,
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_sprintf_wh+1 
;Ascenseur.c,170 :: 		"<DATA,ET:%d,DIR:%d,PT:%d,PRT:%d,AL:%d,URG:%d,NB:%d,PWM:%d,TPS:%d>\r\n",
	MOVLW       ?lstr_1_Ascenseur+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_Ascenseur+0)
	MOVWF       FARG_sprintf_f+2 
;Ascenseur.c,171 :: 		(int)etage_actuel, (int)dir_n, (int)poids_kg,
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
;Ascenseur.c,172 :: 		(int)prt_n,        (int)al_active, (int)urg_active,
	MOVF        ?FLOC___uart_send_dataT73+0, 0 
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
;Ascenseur.c,173 :: 		(int)nb_session,   (int)pwm_actuel, (int)temps_trajet);
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
;Ascenseur.c,175 :: 		UART1_Write_Text(trame);
	MOVLW       uart_send_data_trame_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(uart_send_data_trame_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,176 :: 		}
L_end_uart_send_data:
	RETURN      0
; end of _uart_send_data

_uart_ack_ok:

;Ascenseur.c,178 :: 		void uart_ack_ok()  { UART1_Write_Text("<ACK,OK>\r\n");  }
	MOVLW       ?lstr2_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
L_end_uart_ack_ok:
	RETURN      0
; end of _uart_ack_ok

_uart_ack_err:

;Ascenseur.c,179 :: 		void uart_ack_err() { UART1_Write_Text("<ACK,ERR>\r\n"); }
	MOVLW       ?lstr3_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
L_end_uart_ack_err:
	RETURN      0
; end of _uart_ack_err

_parser_cmd:

;Ascenseur.c,181 :: 		void parser_cmd(char *buf) {
;Ascenseur.c,183 :: 		if (strstr(buf, "CMD,STOP")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr4_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr4_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd39
;Ascenseur.c,184 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,185 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,186 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,187 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,188 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,189 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,190 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,191 :: 		}
L_parser_cmd39:
;Ascenseur.c,193 :: 		if (strstr(buf, "CMD,ACK")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr5_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr5_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd40
;Ascenseur.c,194 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_parser_cmd41
;Ascenseur.c,195 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,196 :: 		} else if (urg_active) {
	GOTO        L_parser_cmd42
L_parser_cmd41:
	MOVF        _urg_active+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd43
;Ascenseur.c,197 :: 		urg_active = 0;
	CLRF        _urg_active+0 
;Ascenseur.c,198 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,199 :: 		urgence_flag = 0;
	CLRF        _urgence_flag+0 
;Ascenseur.c,200 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,201 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,202 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,203 :: 		} else {
	GOTO        L_parser_cmd44
L_parser_cmd43:
;Ascenseur.c,204 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,205 :: 		}
L_parser_cmd44:
L_parser_cmd42:
;Ascenseur.c,206 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,207 :: 		}
L_parser_cmd40:
;Ascenseur.c,209 :: 		if (strstr(buf, "MODE:AUTO")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr6_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr6_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd45
;Ascenseur.c,210 :: 		mode_auto = 1;
	MOVLW       1
	MOVWF       _mode_auto+0 
;Ascenseur.c,211 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,212 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,213 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,214 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,215 :: 		}
L_parser_cmd45:
;Ascenseur.c,217 :: 		if (strstr(buf, "MODE:MAN")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr7_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr7_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd46
;Ascenseur.c,218 :: 		mode_auto = 0;
	CLRF        _mode_auto+0 
;Ascenseur.c,219 :: 		direction = 'S';
	MOVLW       83
	MOVWF       _direction+0 
;Ascenseur.c,220 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,221 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,222 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,223 :: 		}
L_parser_cmd46:
;Ascenseur.c,225 :: 		if (strstr(buf, "AL:ON")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr8_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr8_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd47
;Ascenseur.c,226 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,227 :: 		al_flag = 1;
	MOVLW       1
	MOVWF       _al_flag+0 
;Ascenseur.c,228 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,229 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,230 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,231 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,232 :: 		}
L_parser_cmd47:
;Ascenseur.c,234 :: 		if (strstr(buf, "RST:AL")) {
	MOVF        FARG_parser_cmd_buf+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_parser_cmd_buf+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr9_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr9_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_parser_cmd48
;Ascenseur.c,235 :: 		if (!urg_active) {
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_parser_cmd49
;Ascenseur.c,236 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,237 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,238 :: 		uart_ack_ok();
	CALL        _uart_ack_ok+0, 0
;Ascenseur.c,239 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,240 :: 		} else {
	GOTO        L_parser_cmd50
L_parser_cmd49:
;Ascenseur.c,241 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,242 :: 		}
L_parser_cmd50:
;Ascenseur.c,243 :: 		return;
	GOTO        L_end_parser_cmd
;Ascenseur.c,244 :: 		}
L_parser_cmd48:
;Ascenseur.c,246 :: 		uart_ack_err();
	CALL        _uart_ack_err+0, 0
;Ascenseur.c,247 :: 		}
L_end_parser_cmd:
	RETURN      0
; end of _parser_cmd

_init_timer1:

;Ascenseur.c,249 :: 		void init_timer1() {
;Ascenseur.c,250 :: 		T1CON = 0x00;
	CLRF        T1CON+0 
;Ascenseur.c,251 :: 		TMR1H = 0xFE;
	MOVLW       254
	MOVWF       TMR1H+0 
;Ascenseur.c,252 :: 		TMR1L = 0x0C;
	MOVLW       12
	MOVWF       TMR1L+0 
;Ascenseur.c,253 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Ascenseur.c,254 :: 		TMR1IE_bit = 1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;Ascenseur.c,255 :: 		TMR1ON_bit = 1;
	BSF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;Ascenseur.c,256 :: 		}
L_end_init_timer1:
	RETURN      0
; end of _init_timer1

_main:

;Ascenseur.c,258 :: 		void main() {
;Ascenseur.c,261 :: 		ANSELA = 0x00;
	CLRF        ANSELA+0 
;Ascenseur.c,262 :: 		TRISA3_bit = 0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;Ascenseur.c,263 :: 		LATA3_bit = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,265 :: 		ANSELB = 0x00;
	CLRF        ANSELB+0 
;Ascenseur.c,266 :: 		TRISB6_bit = 1;
	BSF         TRISB6_bit+0, BitPos(TRISB6_bit+0) 
;Ascenseur.c,267 :: 		TRISB7_bit = 1;
	BSF         TRISB7_bit+0, BitPos(TRISB7_bit+0) 
;Ascenseur.c,268 :: 		INTCON2.RBPU = 1;
	BSF         INTCON2+0, 7 
;Ascenseur.c,270 :: 		ANSELC = 0x00;
	CLRF        ANSELC+0 
;Ascenseur.c,271 :: 		TRISC5_bit = 0;
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;Ascenseur.c,272 :: 		TRISC6_bit = 0;
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;Ascenseur.c,273 :: 		TRISC7_bit = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;Ascenseur.c,274 :: 		LATC5_bit = 0;
	BCF         LATC5_bit+0, BitPos(LATC5_bit+0) 
;Ascenseur.c,276 :: 		ANSELD = 0x00;
	CLRF        ANSELD+0 
;Ascenseur.c,277 :: 		TRISD4_bit = 1;
	BSF         TRISD4_bit+0, BitPos(TRISD4_bit+0) 
;Ascenseur.c,279 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Ascenseur.c,280 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main51:
	DECFSZ      R13, 1, 1
	BRA         L_main51
	DECFSZ      R12, 1, 1
	BRA         L_main51
	DECFSZ      R11, 1, 1
	BRA         L_main51
	NOP
;Ascenseur.c,282 :: 		I2C1_Init(100000);
	MOVLW       20
	MOVWF       SSP1ADD+0 
	CALL        _I2C1_Init+0, 0
;Ascenseur.c,283 :: 		Delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_main52:
	DECFSZ      R13, 1, 1
	BRA         L_main52
	DECFSZ      R12, 1, 1
	BRA         L_main52
	NOP
;Ascenseur.c,285 :: 		T0CON = 0x07;
	MOVLW       7
	MOVWF       T0CON+0 
;Ascenseur.c,286 :: 		TMR0H = T0_RELOAD_H;
	MOVLW       194
	MOVWF       TMR0H+0 
;Ascenseur.c,287 :: 		TMR0L = T0_RELOAD_L;
	MOVLW       247
	MOVWF       TMR0L+0 
;Ascenseur.c,288 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Ascenseur.c,289 :: 		TMR0IE_bit = 1;
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;Ascenseur.c,291 :: 		init_timer1();
	CALL        _init_timer1+0, 0
;Ascenseur.c,293 :: 		RC1IE_bit = 1;
	BSF         RC1IE_bit+0, BitPos(RC1IE_bit+0) 
;Ascenseur.c,294 :: 		PEIE_bit = 1;
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;Ascenseur.c,295 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Ascenseur.c,296 :: 		T0CON = 0x87;
	MOVLW       135
	MOVWF       T0CON+0 
;Ascenseur.c,298 :: 		UART1_Write_Text("<DATA,ET:0,DIR:0,PT:0,PRT:0,AL:0,URG:0,NB:0,PWM:0,TPS:0>\r\n");
	MOVLW       ?lstr10_Ascenseur+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr10_Ascenseur+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Ascenseur.c,300 :: 		while (1) {
L_main53:
;Ascenseur.c,302 :: 		if (BP_URGENCE && !urg_active) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main57
	MOVF        _urg_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main57
L__main99:
;Ascenseur.c,303 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main58:
	DECFSZ      R13, 1, 1
	BRA         L_main58
	DECFSZ      R12, 1, 1
	BRA         L_main58
	NOP
	NOP
;Ascenseur.c,304 :: 		if (BP_URGENCE) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main59
;Ascenseur.c,305 :: 		urg_active = 1;
	MOVLW       1
	MOVWF       _urg_active+0 
;Ascenseur.c,306 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,307 :: 		urgence_flag = 1;
	MOVLW       1
	MOVWF       _urgence_flag+0 
;Ascenseur.c,308 :: 		}
L_main59:
;Ascenseur.c,309 :: 		}
L_main57:
;Ascenseur.c,311 :: 		if (urgence_flag) {
	MOVF        _urgence_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main60
;Ascenseur.c,312 :: 		urgence_flag = 0;
	CLRF        _urgence_flag+0 
;Ascenseur.c,313 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,316 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L3+0 
;Ascenseur.c,317 :: 		while (acq_recu == 0) {
L_main61:
	MOVF        main_acq_recu_L3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main62
;Ascenseur.c,318 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main63:
	DECFSZ      R13, 1, 1
	BRA         L_main63
	DECFSZ      R12, 1, 1
	BRA         L_main63
	NOP
	NOP
;Ascenseur.c,319 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main64
;Ascenseur.c,320 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,321 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,322 :: 		}
L_main64:
;Ascenseur.c,323 :: 		if (BP_ACQ && !BP_URGENCE) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main67
	BTFSC       PORTB+0, 6 
	GOTO        L_main67
L__main98:
;Ascenseur.c,324 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main68:
	DECFSZ      R13, 1, 1
	BRA         L_main68
	DECFSZ      R12, 1, 1
	BRA         L_main68
	NOP
	NOP
;Ascenseur.c,325 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3+0 
;Ascenseur.c,326 :: 		}
L_main67:
;Ascenseur.c,327 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main69
;Ascenseur.c,328 :: 		if (strstr(cmd, "CMD,ACK") && !BP_URGENCE)
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr11_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr11_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main72
	BTFSC       PORTB+0, 6 
	GOTO        L_main72
L__main97:
;Ascenseur.c,329 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3+0 
L_main72:
;Ascenseur.c,330 :: 		}
L_main69:
;Ascenseur.c,331 :: 		}
	GOTO        L_main61
L_main62:
;Ascenseur.c,332 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main73:
	DECFSZ      R13, 1, 1
	BRA         L_main73
	DECFSZ      R12, 1, 1
	BRA         L_main73
	DECFSZ      R11, 1, 1
	BRA         L_main73
;Ascenseur.c,335 :: 		urg_active = 0;
	CLRF        _urg_active+0 
;Ascenseur.c,336 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,337 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,338 :: 		LED2 = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,339 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,340 :: 		}
L_main60:
;Ascenseur.c,342 :: 		if (al_flag) {
	MOVF        _al_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main74
;Ascenseur.c,343 :: 		al_flag = 0;
	CLRF        _al_flag+0 
;Ascenseur.c,344 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,347 :: 		unsigned char acq_recu = 0;
	CLRF        main_acq_recu_L3_L3+0 
;Ascenseur.c,348 :: 		while (acq_recu == 0) {
L_main75:
	MOVF        main_acq_recu_L3_L3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main76
;Ascenseur.c,349 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main77:
	DECFSZ      R13, 1, 1
	BRA         L_main77
	DECFSZ      R12, 1, 1
	BRA         L_main77
	NOP
	NOP
;Ascenseur.c,350 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main78
;Ascenseur.c,351 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,352 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,353 :: 		}
L_main78:
;Ascenseur.c,354 :: 		if (BP_ACQ) {
	BTFSS       PORTD+0, 4 
	GOTO        L_main79
;Ascenseur.c,355 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main80:
	DECFSZ      R13, 1, 1
	BRA         L_main80
	DECFSZ      R12, 1, 1
	BRA         L_main80
	NOP
	NOP
;Ascenseur.c,356 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3_L3+0 
;Ascenseur.c,357 :: 		}
L_main79:
;Ascenseur.c,358 :: 		if (pop_cmd(cmd)) {
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main81
;Ascenseur.c,359 :: 		if (strstr(cmd, "RST:AL"))
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr12_Ascenseur+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr12_Ascenseur+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main82
;Ascenseur.c,360 :: 		acq_recu = 1;
	MOVLW       1
	MOVWF       main_acq_recu_L3_L3+0 
L_main82:
;Ascenseur.c,361 :: 		}
L_main81:
;Ascenseur.c,362 :: 		}
	GOTO        L_main75
L_main76:
;Ascenseur.c,363 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main83:
	DECFSZ      R13, 1, 1
	BRA         L_main83
	DECFSZ      R12, 1, 1
	BRA         L_main83
	DECFSZ      R11, 1, 1
	BRA         L_main83
;Ascenseur.c,366 :: 		al_active = 0;
	CLRF        _al_active+0 
;Ascenseur.c,367 :: 		LED2 = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,368 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,369 :: 		}
L_main74:
;Ascenseur.c,371 :: 		if (BP_ALARME && !al_active) {
	BTFSS       PORTB+0, 7 
	GOTO        L_main86
	MOVF        _al_active+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main86
L__main96:
;Ascenseur.c,372 :: 		Delay_ms(20);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main87:
	DECFSZ      R13, 1, 1
	BRA         L_main87
	DECFSZ      R12, 1, 1
	BRA         L_main87
	NOP
	NOP
;Ascenseur.c,373 :: 		if (BP_ALARME) {
	BTFSS       PORTB+0, 7 
	GOTO        L_main88
;Ascenseur.c,374 :: 		al_active = 1;
	MOVLW       1
	MOVWF       _al_active+0 
;Ascenseur.c,375 :: 		al_flag = 1;
	MOVLW       1
	MOVWF       _al_flag+0 
;Ascenseur.c,376 :: 		LED2 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;Ascenseur.c,377 :: 		}
L_main88:
;Ascenseur.c,378 :: 		}
L_main86:
;Ascenseur.c,380 :: 		while (pop_cmd(cmd)) {
L_main89:
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_pop_cmd_dest+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_pop_cmd_dest+1 
	CALL        _pop_cmd+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main90
;Ascenseur.c,381 :: 		parser_cmd(cmd);
	MOVLW       main_cmd_L0+0
	MOVWF       FARG_parser_cmd_buf+0 
	MOVLW       hi_addr(main_cmd_L0+0)
	MOVWF       FARG_parser_cmd_buf+1 
	CALL        _parser_cmd+0, 0
;Ascenseur.c,382 :: 		}
	GOTO        L_main89
L_main90:
;Ascenseur.c,384 :: 		if (timer0_flag) {
	MOVF        _timer0_flag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main91
;Ascenseur.c,385 :: 		timer0_flag = 0;
	CLRF        _timer0_flag+0 
;Ascenseur.c,386 :: 		uart_send_data();
	CALL        _uart_send_data+0, 0
;Ascenseur.c,387 :: 		}
L_main91:
;Ascenseur.c,388 :: 		}
	GOTO        L_main53
;Ascenseur.c,389 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
