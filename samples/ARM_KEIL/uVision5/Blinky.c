/*----------------------------------------------------------------------------
 * Name:    Blinky.c
 * Purpose: LED Flasher for MCBSTM32E
 *----------------------------------------------------------------------------
 * This file is part of the uVision/ARM development tools.
 * This software may only be used under the terms of a valid, current,
 * end user licence from KEIL for a compatible version of KEIL software
 * development tools. Nothing else gives you the right to use this software.
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2004-2013 Keil - An ARM Company. All rights reserved.
 *----------------------------------------------------------------------------*/

#include "STM32F10x.h"    // Device header
#include <stdio.h>
#include "GLCD.h"         // Keil::Board Support:MCBSTM32E:Graphic LCD
#include "LED.h"          // Keil::Board Support:MCBSTM32E:LED
#include "ADC.h"          // Keil::Board Support:MCBSTM32E:A/D Converter

volatile uint8_t  update_flag;

#define __FI    1                       /* Font index 16x24                  */
uint32_t LEDOn, LEDOff;


/*----------------------------------------------------------------------------
  SysTick IRQ Handler
 *----------------------------------------------------------------------------*/
void SysTick_Handler (void) {
  static uint32_t ticks;
  
  switch (ticks++) {
    case  0: LEDOn  = 1; update_flag = 1; break;
    case  5: LEDOff = 1; break;
    case  9: ticks  = 0; break;
    
    default:
      if (ticks > 10) {
        ticks = 0;
      }
  }
}

#if defined( __COVERAGESCANNER__ )
static int csfputs(const char *s, void *stream) 
{
	#define COVERAGESCANNER_ITM_CHANNEL 10
  if 	(
	      (ITM->TCR & ITM_TCR_ITMENA_Msk)                  &&      /* ITM enabled */
        (ITM->TER & (1UL << COVERAGESCANNER_ITM_CHANNEL)        )                         /* ITM Port  enabled */
	     )
	{
		while ( *s != '\0' )
		{
			while (ITM->PORT[COVERAGESCANNER_ITM_CHANNEL].u32 == 0);
			ITM->PORT[COVERAGESCANNER_ITM_CHANNEL].u8 = (uint8_t) *s;
			s++;
		}
  }	
	return 0;
}

static void *csfopenappend(const char *path)
{
  return (void*)1;
}

static int csfclose(void *fp)        
{
  return 1;
}
#endif

/*----------------------------------------------------------------------------
  Main function
 *----------------------------------------------------------------------------*/
char numStr[] = "01234567";

int main (void) {
	int collect ;
  int32_t max_num = LED_Num() - 1;
  int32_t num = 0;
  int32_t dir = 1;
  int32_t adc = -1, adcVal=0;
  char text[5] = "";

#ifdef __COVERAGESCANNER__
  __coveragescanner_set_custom_io( NULL,
      csfputs,
      csfopenappend,
      NULL,
      NULL,
      csfclose,
      NULL);
  __coveragescanner_filename( "c:\\coverage" );
#endif
  SysTick_Config(SystemCoreClock/100);      /* Generate interrupt each 10 ms  */
  LED_Initialize();                         /* LED Initialization             */
  GLCD_Initialize();                        /* Initialize the GLCD            */
  ADC_Initialize();                         /* A/D Converter Init             */
 
  GLCD_Clear(White);                        /* Clear the GLCD                 */
  
  GLCD_SetBackColor(Blue);
  GLCD_SetTextColor(Red);
  GLCD_DisplayString(0, 0, __FI, "   MCBSTM32E Demo   ");
  GLCD_DisplayString(1, 0, __FI, "      Blinky        ");
  GLCD_DisplayString(2, 0, __FI, "   www.keil.com     ");
  
  GLCD_SetBackColor(White);
  GLCD_SetTextColor(Black);
  GLCD_DisplayString(5, 2, __FI, "LED: ");
  GLCD_SetTextColor(LightGrey);
  GLCD_DisplayString(5, 7, __FI, "01234567");
  GLCD_SetTextColor(Black);
  GLCD_DisplayString(7, 2, __FI, "ADC: ");
  
  for ( collect = 0; collect < 10; collect++ ) {
    if (LEDOn) {
      LEDOn = 0;
      LED_On (num);                         /* Turn specified LED on          */
      GLCD_SetTextColor(Blue);
      GLCD_DisplayChar(5, 7+num, __FI, numStr[num]);
    }

    if (LEDOff) {
      LEDOff = 0;
      LED_Off (num);                        /* Turn specified LED off         */
      GLCD_SetTextColor(LightGrey);
      GLCD_DisplayChar(5, 7+num, __FI, numStr[num]);

      num += dir;                           /* Change LED number              */
      
      if (dir == 1 && num == max_num) {
        dir = -1;                           /* Change direction to down       */
      }
      else if (num == 0) {
        dir =  1;                           /* Change direction to up         */
      }
    }
    
    ADC_StartConversion();                  /* Show A/D conversion bargraph   */
    adcVal = (adc + ADC_GetValue()) >> 1;
    if (adc ^ adcVal) {
      adc = adcVal;
      sprintf(text, "%i ", adcVal);
      GLCD_SetTextColor(Green);
      GLCD_Bargraph (7*16, 7*24, 160, 20, adcVal >> 2);
      GLCD_SetTextColor(Blue);
      GLCD_DisplayString(8, 9, __FI, text);
			if (update_flag) {
				update_flag = 0;

				printf("AD value: %i\r\n", adcVal);
			}
			
    }
  }

}
