#line 1 "C:/Users/ARGE/Desktop/MicroC_Folder2/DS3231(RTC)/RTC.c"
#line 17 "C:/Users/ARGE/Desktop/MicroC_Folder2/DS3231(RTC)/RTC.c"
struct variables{
 char buffer[15];
 int dd;
}sny, dk, st, gn, date, ay, yl, tp;


void okuvecevir(int adrofres, int *atanan);
int oku(int dgr);
int cevir(int dcevir);
void ilkdegeryaz(int pointeradr, int istenilen);
void gercektarih();
void alarm();
void sonhal();
int bb = 0x00;
int flag = 0x00;

void alarmset(){
 bb = 0x00;
 bb = oku( 0x0e );
 bb = bb | 0x05;
 ilkdegeryaz( 0x0e , bb);
 ilkdegeryaz( 0x07 , 0x00);
 ilkdegeryaz( 0x08 , 0xa3);
 ilkdegeryaz( 0x09 , 0xa3);
 ilkdegeryaz( 0x0a , 0xc7);
}
void temp(){

 tp.dd = oku( 0x11 );
 IntToStr(tp.dd,tp.buffer);
 UART1_Write_Text(tp.buffer);
 UART1_Write_Text("\r\n");
 Delay_ms(1000);

}

void main() {

 OSCCON = 0x72;
 ANSELC = 0;
 ANSELB = 0;
 TRISB = 0;
 LATB = 0X00;
 I2C1_Init(100000);
 UART1_Init(115200);
 Delay_ms(100);
 gercektarih();
 alarmset();
 while(1){
 sonhal();
 temp();
 flag = oku( 0x0f );
 if((flag & 0x01) == 0x01){
 LATB = ~ LATB;
 bb = 0x00;
 bb = oku( 0x0f );
 bb = bb & 0xfe;
 ilkdegeryaz( 0x0f , bb);
 }
 }

}

void sonhal(){


 okuvecevir( 0x00 , &sny.dd);
 okuvecevir( 0x01 , &dk.dd);
 okuvecevir( 0x02 , &st.dd);
 okuvecevir( 0x03 , &gn.dd);
 okuvecevir( 0x04 , &date.dd);
 okuvecevir( 0x05 , &ay.dd);
 okuvecevir( 0x06 , &yl.dd);

 IntToStr(sny.dd,sny.buffer);
 IntToStr(dk.dd,dk.buffer);
 IntToStr(st.dd,st.buffer);
 IntToStr(gn.dd,gn.buffer);
 IntToStr(date.dd,date.buffer);
 IntToStr(ay.dd,ay.buffer);
 IntToStr(yl.dd,yl.buffer);

 UART1_Write_Text(yl.buffer);
 UART1_Write_Text(ay.buffer);
 UART1_Write_Text(date.buffer);
 UART1_Write_Text(gn.buffer);
 UART1_Write_Text(st.buffer);
 UART1_Write_Text(dk.buffer);
 UART1_Write_Text(sny.buffer);

}

void gercektarih(){

 ilkdegeryaz( 0x06 ,0x22);
 ilkdegeryaz( 0x00 ,0x10);
 ilkdegeryaz( 0x01 ,0x54);
 ilkdegeryaz( 0x02 ,0x11);
 ilkdegeryaz( 0x03 ,0x04);
 ilkdegeryaz( 0x04 ,0x05);
 ilkdegeryaz( 0x05 ,0x05);
}

int oku(int dgr){
 int aaa;
 I2C1_Start();
 I2C1_Wr(0xd0);
 I2C1_Wr(dgr);
 I2C1_Repeated_Start();
 I2C1_Wr(0xd1);
 aaa = I2C1_Rd(0);
 I2C1_Stop();
 return aaa;

}

void okuvecevir(int adrofres, int *atanan){
 *atanan = oku(adrofres);
 *atanan = cevir(*atanan);
}

int cevir(int dcevir){
 int donen = dcevir;
 donen = donen >> 4 ;
 donen *= 10;
 dcevir = dcevir & 0x0f;
 donen += dcevir;
 return donen;
}

void ilkdegeryaz(int pointeradr, int istenilen){
 I2C1_Start();
 I2C1_Wr(0xd0);
 I2C1_Wr(pointeradr);
 I2C1_Wr(istenilen);
 I2C1_Stop();
}
