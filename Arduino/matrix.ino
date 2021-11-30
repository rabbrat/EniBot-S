#include <LedControl.h>
int DIN=51;
int CS=53;
int CLk=52;
/*
 Now we need a LedControl to work with.
 ***** These pin numbers will probably not work with your hardware *****
 pin 11 (UNO), 51 MEGA is connected to the DataIn (DIN)
 pin 13 (UNO), 52 MEGA is connected to the CLK 
 pin 10 (UNO), 53 MEGA is connected to LOAD (CS)
 We have only a single MAX72XX.
 */
LedControl lc=LedControl(12,11,10,1);
/* we always wait a bit between updates of the display */
unsigned long delaytime=100;
void setup() {
  lc.shutdown(0,false);/*The MAX72XX is in power-saving mode on startup,we have to do a wakeup call*/
  lc.setIntensity(0,8);/* Set the brightness to a medium values */
  lc.clearDisplay(0);
}
  /* here is the data for the characters */
  byte Prueba[8]={B01000010,B11100111,B11111111,B11111111,B01111110,B00111100,B00011000,B00000000};
  byte RightArrow[8]={B00001000,B00001100,B11111110,B11111111,B11111110,B00001100,B00001000,B00000000};
  byte LeftArrow[8]={B00010000,B00110000,B01111111,B11111111,B01111111,B00110000,B00010000,B00000000};
  byte ForwardArrow[8]={B00001000,B00011100,B00111110,B01111111,B00011100,B00011100,B00011100,B00011100};
  byte BackwardArrow[8]={B00111000,B00111000,B00111000,B00111000,B11111110,B01111100,B00111000,B00010000};
 
void loop()
{
  printByte(Prueba);
  delay(delaytime);
}

void printByte(byte Arrow[]) 
{ 
  int i=0;
  for(i=0; i<8; i++) 
  {
    lc.setRow(0,i, Arrow[i]); 
  }
}



  

  
 
