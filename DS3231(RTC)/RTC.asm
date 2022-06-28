
_alarmset:

;RTC.c,33 :: 		void alarmset(){
;RTC.c,34 :: 		bb = 0x00;
	CLRF        _bb+0 
	CLRF        _bb+1 
;RTC.c,35 :: 		bb = oku(control);
	MOVLW       14
	MOVWF       FARG_oku_dgr+0 
	MOVLW       0
	MOVWF       FARG_oku_dgr+1 
	CALL        _oku+0, 0
	MOVF        R0, 0 
	MOVWF       _bb+0 
	MOVF        R1, 0 
	MOVWF       _bb+1 
;RTC.c,36 :: 		bb = bb | 0x05;
	MOVLW       5
	IORWF       R0, 1 
	MOVLW       0
	IORWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       _bb+0 
	MOVF        R1, 0 
	MOVWF       _bb+1 
;RTC.c,37 :: 		ilkdegeryaz(control, bb); // INTCN = 1 AND A1IE = 1
	MOVLW       14
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVF        R0, 0 
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVF        R1, 0 
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,38 :: 		ilkdegeryaz(alarmsec, 0x00); //second
	MOVLW       7
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	CLRF        FARG_ilkdegeryaz_istenilen+0 
	CLRF        FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,39 :: 		ilkdegeryaz(alarmmin, 0xa3); // minut
	MOVLW       8
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVLW       163
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,40 :: 		ilkdegeryaz(alarmhour, 0xa3); // hour
	MOVLW       9
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVLW       163
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,41 :: 		ilkdegeryaz(alarmda, 0xc7);   // day/date
	MOVLW       10
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVLW       199
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,42 :: 		}
L_end_alarmset:
	RETURN      0
; end of _alarmset

_temp:

;RTC.c,43 :: 		void temp(){
;RTC.c,45 :: 		tp.dd = oku(temp1);
	MOVLW       17
	MOVWF       FARG_oku_dgr+0 
	MOVLW       0
	MOVWF       FARG_oku_dgr+1 
	CALL        _oku+0, 0
	MOVF        R0, 0 
	MOVWF       _tp+15 
	MOVF        R1, 0 
	MOVWF       _tp+16 
;RTC.c,46 :: 		IntToStr(tp.dd,tp.buffer);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _tp+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_tp+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;RTC.c,47 :: 		UART1_Write_Text(tp.buffer);
	MOVLW       _tp+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_tp+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,48 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr1_RTC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_RTC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,49 :: 		Delay_ms(1000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_temp0:
	DECFSZ      R13, 1, 1
	BRA         L_temp0
	DECFSZ      R12, 1, 1
	BRA         L_temp0
	DECFSZ      R11, 1, 1
	BRA         L_temp0
	NOP
;RTC.c,51 :: 		}
L_end_temp:
	RETURN      0
; end of _temp

_main:

;RTC.c,53 :: 		void main() {
;RTC.c,55 :: 		OSCCON = 0x72;// for 16Mhz
	MOVLW       114
	MOVWF       OSCCON+0 
;RTC.c,56 :: 		ANSELC = 0;
	CLRF        ANSELC+0 
;RTC.c,57 :: 		ANSELB = 0;
	CLRF        ANSELB+0 
;RTC.c,58 :: 		TRISB = 0;
	CLRF        TRISB+0 
;RTC.c,59 :: 		LATB = 0X00;
	CLRF        LATB+0 
;RTC.c,60 :: 		I2C1_Init(100000);// I2C is running at 100khz
	MOVLW       40
	MOVWF       SSP1ADD+0 
	CALL        _I2C1_Init+0, 0
;RTC.c,61 :: 		UART1_Init(115200);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       34
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;RTC.c,62 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main1:
	DECFSZ      R13, 1, 1
	BRA         L_main1
	DECFSZ      R12, 1, 1
	BRA         L_main1
	DECFSZ      R11, 1, 1
	BRA         L_main1
;RTC.c,63 :: 		gercektarih();
	CALL        _gercektarih+0, 0
;RTC.c,64 :: 		alarmset();
	CALL        _alarmset+0, 0
;RTC.c,65 :: 		while(1){
L_main2:
;RTC.c,66 :: 		sonhal();
	CALL        _sonhal+0, 0
;RTC.c,67 :: 		temp();
	CALL        _temp+0, 0
;RTC.c,68 :: 		flag = oku(status);
	MOVLW       15
	MOVWF       FARG_oku_dgr+0 
	MOVLW       0
	MOVWF       FARG_oku_dgr+1 
	CALL        _oku+0, 0
	MOVF        R0, 0 
	MOVWF       _flag+0 
	MOVF        R1, 0 
	MOVWF       _flag+1 
;RTC.c,69 :: 		if((flag & 0x01) == 0x01){
	MOVLW       1
	ANDWF       R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVLW       0
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main8
	MOVLW       1
	XORWF       R2, 0 
L__main8:
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
;RTC.c,70 :: 		LATB = ~ LATB;
	COMF        LATB+0, 1 
;RTC.c,71 :: 		bb = 0x00;
	CLRF        _bb+0 
	CLRF        _bb+1 
;RTC.c,72 :: 		bb = oku(status);
	MOVLW       15
	MOVWF       FARG_oku_dgr+0 
	MOVLW       0
	MOVWF       FARG_oku_dgr+1 
	CALL        _oku+0, 0
	MOVF        R0, 0 
	MOVWF       _bb+0 
	MOVF        R1, 0 
	MOVWF       _bb+1 
;RTC.c,73 :: 		bb = bb & 0xfe;
	MOVLW       254
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       _bb+0 
	MOVF        R1, 0 
	MOVWF       _bb+1 
;RTC.c,74 :: 		ilkdegeryaz(status, bb);
	MOVLW       15
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVF        R0, 0 
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVF        R1, 0 
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,75 :: 		}
L_main4:
;RTC.c,76 :: 		}
	GOTO        L_main2
;RTC.c,78 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_sonhal:

;RTC.c,80 :: 		void sonhal(){
;RTC.c,83 :: 		okuvecevir(saniye, &sny.dd);
	CLRF        FARG_okuvecevir_adrofres+0 
	CLRF        FARG_okuvecevir_adrofres+1 
	MOVLW       _sny+15
	MOVWF       FARG_okuvecevir_atanan+0 
	MOVLW       hi_addr(_sny+15)
	MOVWF       FARG_okuvecevir_atanan+1 
	CALL        _okuvecevir+0, 0
;RTC.c,84 :: 		okuvecevir(dakika, &dk.dd);
	MOVLW       1
	MOVWF       FARG_okuvecevir_adrofres+0 
	MOVLW       0
	MOVWF       FARG_okuvecevir_adrofres+1 
	MOVLW       _dk+15
	MOVWF       FARG_okuvecevir_atanan+0 
	MOVLW       hi_addr(_dk+15)
	MOVWF       FARG_okuvecevir_atanan+1 
	CALL        _okuvecevir+0, 0
;RTC.c,85 :: 		okuvecevir(saat, &st.dd);
	MOVLW       2
	MOVWF       FARG_okuvecevir_adrofres+0 
	MOVLW       0
	MOVWF       FARG_okuvecevir_adrofres+1 
	MOVLW       _st+15
	MOVWF       FARG_okuvecevir_atanan+0 
	MOVLW       hi_addr(_st+15)
	MOVWF       FARG_okuvecevir_atanan+1 
	CALL        _okuvecevir+0, 0
;RTC.c,86 :: 		okuvecevir(gun, &gn.dd);
	MOVLW       3
	MOVWF       FARG_okuvecevir_adrofres+0 
	MOVLW       0
	MOVWF       FARG_okuvecevir_adrofres+1 
	MOVLW       _gn+15
	MOVWF       FARG_okuvecevir_atanan+0 
	MOVLW       hi_addr(_gn+15)
	MOVWF       FARG_okuvecevir_atanan+1 
	CALL        _okuvecevir+0, 0
;RTC.c,87 :: 		okuvecevir(tarih, &date.dd);
	MOVLW       4
	MOVWF       FARG_okuvecevir_adrofres+0 
	MOVLW       0
	MOVWF       FARG_okuvecevir_adrofres+1 
	MOVLW       _date+15
	MOVWF       FARG_okuvecevir_atanan+0 
	MOVLW       hi_addr(_date+15)
	MOVWF       FARG_okuvecevir_atanan+1 
	CALL        _okuvecevir+0, 0
;RTC.c,88 :: 		okuvecevir(ayy, &ay.dd);
	MOVLW       5
	MOVWF       FARG_okuvecevir_adrofres+0 
	MOVLW       0
	MOVWF       FARG_okuvecevir_adrofres+1 
	MOVLW       _ay+15
	MOVWF       FARG_okuvecevir_atanan+0 
	MOVLW       hi_addr(_ay+15)
	MOVWF       FARG_okuvecevir_atanan+1 
	CALL        _okuvecevir+0, 0
;RTC.c,89 :: 		okuvecevir(yil, &yl.dd);
	MOVLW       6
	MOVWF       FARG_okuvecevir_adrofres+0 
	MOVLW       0
	MOVWF       FARG_okuvecevir_adrofres+1 
	MOVLW       _yl+15
	MOVWF       FARG_okuvecevir_atanan+0 
	MOVLW       hi_addr(_yl+15)
	MOVWF       FARG_okuvecevir_atanan+1 
	CALL        _okuvecevir+0, 0
;RTC.c,91 :: 		IntToStr(sny.dd,sny.buffer);
	MOVF        _sny+15, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _sny+16, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _sny+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_sny+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;RTC.c,92 :: 		IntToStr(dk.dd,dk.buffer);
	MOVF        _dk+15, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _dk+16, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _dk+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_dk+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;RTC.c,93 :: 		IntToStr(st.dd,st.buffer);
	MOVF        _st+15, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _st+16, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _st+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_st+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;RTC.c,94 :: 		IntToStr(gn.dd,gn.buffer);
	MOVF        _gn+15, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _gn+16, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _gn+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_gn+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;RTC.c,95 :: 		IntToStr(date.dd,date.buffer);
	MOVF        _date+15, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _date+16, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _date+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_date+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;RTC.c,96 :: 		IntToStr(ay.dd,ay.buffer);
	MOVF        _ay+15, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _ay+16, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _ay+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_ay+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;RTC.c,97 :: 		IntToStr(yl.dd,yl.buffer);
	MOVF        _yl+15, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _yl+16, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _yl+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_yl+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;RTC.c,99 :: 		UART1_Write_Text(yl.buffer);
	MOVLW       _yl+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_yl+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,100 :: 		UART1_Write_Text(ay.buffer);
	MOVLW       _ay+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_ay+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,101 :: 		UART1_Write_Text(date.buffer);
	MOVLW       _date+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_date+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,102 :: 		UART1_Write_Text(gn.buffer);
	MOVLW       _gn+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_gn+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,103 :: 		UART1_Write_Text(st.buffer);
	MOVLW       _st+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_st+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,104 :: 		UART1_Write_Text(dk.buffer);
	MOVLW       _dk+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_dk+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,105 :: 		UART1_Write_Text(sny.buffer);
	MOVLW       _sny+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_sny+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,107 :: 		}
L_end_sonhal:
	RETURN      0
; end of _sonhal

_gercektarih:

;RTC.c,109 :: 		void gercektarih(){
;RTC.c,111 :: 		ilkdegeryaz(yil,0x22); // yil degeri 2022
	MOVLW       6
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVLW       34
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,112 :: 		ilkdegeryaz(saniye,0x10); // saniye degeri
	CLRF        FARG_ilkdegeryaz_pointeradr+0 
	CLRF        FARG_ilkdegeryaz_pointeradr+1 
	MOVLW       16
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,113 :: 		ilkdegeryaz(dakika,0x54); // dakika degeri
	MOVLW       1
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVLW       84
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,114 :: 		ilkdegeryaz(saat,0x11); // saat degeri
	MOVLW       2
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVLW       17
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,115 :: 		ilkdegeryaz(gun,0x04); // gun degeri 5 = cuma
	MOVLW       3
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVLW       4
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,116 :: 		ilkdegeryaz(tarih,0x05); // tarih degeri  29
	MOVLW       4
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVLW       5
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,117 :: 		ilkdegeryaz(ayy,0x05); // ay degeri  nisan
	MOVLW       5
	MOVWF       FARG_ilkdegeryaz_pointeradr+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_pointeradr+1 
	MOVLW       5
	MOVWF       FARG_ilkdegeryaz_istenilen+0 
	MOVLW       0
	MOVWF       FARG_ilkdegeryaz_istenilen+1 
	CALL        _ilkdegeryaz+0, 0
;RTC.c,118 :: 		}
L_end_gercektarih:
	RETURN      0
; end of _gercektarih

_oku:

;RTC.c,120 :: 		int oku(int dgr){
;RTC.c,122 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;RTC.c,123 :: 		I2C1_Wr(0xd0); // writing
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,124 :: 		I2C1_Wr(dgr); // pointer address
	MOVF        FARG_oku_dgr+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,125 :: 		I2C1_Repeated_Start();
	CALL        _I2C1_Repeated_Start+0, 0
;RTC.c,126 :: 		I2C1_Wr(0xd1); // reading
	MOVLW       209
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,127 :: 		aaa = I2C1_Rd(0); //
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       oku_aaa_L0+0 
	MOVLW       0
	MOVWF       oku_aaa_L0+1 
;RTC.c,128 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;RTC.c,129 :: 		return aaa;
	MOVF        oku_aaa_L0+0, 0 
	MOVWF       R0 
	MOVF        oku_aaa_L0+1, 0 
	MOVWF       R1 
;RTC.c,131 :: 		}
L_end_oku:
	RETURN      0
; end of _oku

_okuvecevir:

;RTC.c,133 :: 		void okuvecevir(int adrofres, int *atanan){
;RTC.c,134 :: 		*atanan = oku(adrofres);
	MOVF        FARG_okuvecevir_adrofres+0, 0 
	MOVWF       FARG_oku_dgr+0 
	MOVF        FARG_okuvecevir_adrofres+1, 0 
	MOVWF       FARG_oku_dgr+1 
	CALL        _oku+0, 0
	MOVFF       FARG_okuvecevir_atanan+0, FSR1L+0
	MOVFF       FARG_okuvecevir_atanan+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;RTC.c,135 :: 		*atanan = cevir(*atanan);
	MOVFF       FARG_okuvecevir_atanan+0, FSR0L+0
	MOVFF       FARG_okuvecevir_atanan+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_cevir_dcevir+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_cevir_dcevir+1 
	CALL        _cevir+0, 0
	MOVFF       FARG_okuvecevir_atanan+0, FSR1L+0
	MOVFF       FARG_okuvecevir_atanan+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;RTC.c,136 :: 		}
L_end_okuvecevir:
	RETURN      0
; end of _okuvecevir

_cevir:

;RTC.c,138 :: 		int cevir(int dcevir){  // saniye ve dakika icin
;RTC.c,140 :: 		donen = donen >> 4 ;
	MOVLW       4
	MOVWF       R2 
	MOVF        FARG_cevir_dcevir+0, 0 
	MOVWF       R0 
	MOVF        FARG_cevir_dcevir+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
L__cevir14:
	BZ          L__cevir15
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	BTFSC       R1, 6 
	BSF         R1, 7 
	ADDLW       255
	GOTO        L__cevir14
L__cevir15:
;RTC.c,141 :: 		donen *= 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
;RTC.c,142 :: 		dcevir = dcevir & 0x0f;
	MOVLW       15
	ANDWF       FARG_cevir_dcevir+0, 0 
	MOVWF       R2 
	MOVF        FARG_cevir_dcevir+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	MOVWF       FARG_cevir_dcevir+0 
	MOVF        R3, 0 
	MOVWF       FARG_cevir_dcevir+1 
;RTC.c,143 :: 		donen += dcevir;
	MOVF        R2, 0 
	ADDWF       R0, 1 
	MOVF        R3, 0 
	ADDWFC      R1, 1 
;RTC.c,144 :: 		return donen;
;RTC.c,145 :: 		}
L_end_cevir:
	RETURN      0
; end of _cevir

_ilkdegeryaz:

;RTC.c,147 :: 		void ilkdegeryaz(int pointeradr, int istenilen){
;RTC.c,148 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;RTC.c,149 :: 		I2C1_Wr(0xd0); // writing
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,150 :: 		I2C1_Wr(pointeradr); // pointer address
	MOVF        FARG_ilkdegeryaz_pointeradr+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,151 :: 		I2C1_Wr(istenilen); // writing
	MOVF        FARG_ilkdegeryaz_istenilen+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,152 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;RTC.c,153 :: 		}
L_end_ilkdegeryaz:
	RETURN      0
; end of _ilkdegeryaz
