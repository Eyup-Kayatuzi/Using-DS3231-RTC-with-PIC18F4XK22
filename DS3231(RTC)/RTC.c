#define saniye 0x00
#define dakika 0x01
#define saat 0x02
#define gun 0x03
#define tarih 0x04
#define ayy 0x05
#define yil 0x06
#define alarmsec 0x07
#define alarmmin 0x08
#define alarmhour 0x09
#define alarmda 0x0a
#define control 0x0e
#define status 0x0f
#define temp1 0x11
#define temp2 0x12

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
     bb = oku(control);
     bb = bb | 0x05;
     ilkdegeryaz(control, bb); // INTCN = 1 AND A1IE = 1
     ilkdegeryaz(alarmsec, 0x00); //second
     ilkdegeryaz(alarmmin, 0xa3); // minut
     ilkdegeryaz(alarmhour, 0xa3); // hour
     ilkdegeryaz(alarmda, 0xc7);   // day/date
}
void temp(){

     tp.dd = oku(temp1);
     IntToStr(tp.dd,tp.buffer);
     UART1_Write_Text(tp.buffer);
     UART1_Write_Text("\r\n");
     Delay_ms(1000);

}

void main() {

     OSCCON = 0x72;// for 16Mhz
     ANSELC = 0;
     ANSELB = 0;
     TRISB = 0;
     LATB = 0X00;
     I2C1_Init(100000);// I2C is running at 100khz
     UART1_Init(115200);
     Delay_ms(100);
     gercektarih();
     alarmset();
     while(1){
              sonhal();
              temp();
              flag = oku(status);
              if((flag & 0x01) == 0x01){
                       LATB = ~ LATB;
                       bb = 0x00;
                       bb = oku(status);
                       bb = bb & 0xfe;
                       ilkdegeryaz(status, bb);
              }
      }

}

void sonhal(){


              okuvecevir(saniye, &sny.dd);
              okuvecevir(dakika, &dk.dd);
              okuvecevir(saat, &st.dd);
              okuvecevir(gun, &gn.dd);
              okuvecevir(tarih, &date.dd);
              okuvecevir(ayy, &ay.dd);
              okuvecevir(yil, &yl.dd);

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

     ilkdegeryaz(yil,0x22); // yil degeri 2022
     ilkdegeryaz(saniye,0x10); // saniye degeri
     ilkdegeryaz(dakika,0x54); // dakika degeri
     ilkdegeryaz(saat,0x11); // saat degeri
     ilkdegeryaz(gun,0x04); // gun degeri 5 = cuma
     ilkdegeryaz(tarih,0x05); // tarih degeri  29
     ilkdegeryaz(ayy,0x05); // ay degeri  nisan
}

int oku(int dgr){
     int aaa;
     I2C1_Start();
     I2C1_Wr(0xd0); // writing
     I2C1_Wr(dgr); // pointer address
     I2C1_Repeated_Start();
     I2C1_Wr(0xd1); // reading
     aaa = I2C1_Rd(0); //
     I2C1_Stop();
     return aaa;

}

void okuvecevir(int adrofres, int *atanan){
     *atanan = oku(adrofres);
     *atanan = cevir(*atanan);
}

int cevir(int dcevir){  // saniye ve dakika icin
     int donen = dcevir;
     donen = donen >> 4 ;
     donen *= 10;
     dcevir = dcevir & 0x0f;
     donen += dcevir;
     return donen;
}

void ilkdegeryaz(int pointeradr, int istenilen){
    I2C1_Start();
    I2C1_Wr(0xd0); // writing
    I2C1_Wr(pointeradr); // pointer address
    I2C1_Wr(istenilen); // writing
    I2C1_Stop();
}