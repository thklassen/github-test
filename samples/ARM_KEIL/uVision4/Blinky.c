/*----------------------------------------------------------------------------
 * Name:    Blinky.c
 * Purpose: LED Flasher
 * Note(s):
 *----------------------------------------------------------------------------
 * This file is part of the uVision/ARM development tools.
 * This software may only be used under the terms of a valid, current,
 * end user licence from KEIL for a compatible version of KEIL software
 * development tools. Nothing else gives you the right to use this software.
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2012 Keil - An ARM Company. All rights reserved.
 *----------------------------------------------------------------------------*/

#include <stm32f10x.h>                       /* STM32F103 definitions         */
#include <stdio.h>
#include <stdlib.h>

/*----------------------------------------------------------------------------
  wait function
 *----------------------------------------------------------------------------*/
void wait (void)  {
  int  d;

  for (d = 0; d < 20000; d++);             /* only to delay for LED flashes */
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
  Main Program
 *----------------------------------------------------------------------------*/
int main (void) {
  unsigned int i;                            /* LED variable                  */
	int loop;
	int max_loop = 10;

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

  RCC->APB2ENR |= (1UL << 3);                /* Enable GPIOB clock            */

  GPIOB->CRH    =  0x33333333;               /* PB.8..16 defined as Outputs   */

  for ( loop = 0; loop < max_loop ; loop++ )  {                               /* Loop forever                  */
    printf( "Let LED blinking (%i/%i)...\n", loop, max_loop );
    for (i = 1<<8; i < 1<<15; i <<= 1) {     /* Blink LED 0,1,2,3,4,5,6       */
      GPIOB->BSRR = i;                       /* Turn LED on                   */
      wait ();                               /* call wait function            */
      GPIOB->BRR = i;                        /* Turn LED off                  */
    }
    for (i = 1<<15; i > 1<<8; i >>=1 ) {     /* Blink LED 7,6,5,4,3,2,1       */
      GPIOB->BSRR = i;                       /* Turn LED on                   */
      wait ();                               /* call wait function            */
      GPIOB->BRR = i;                        /* Turn LED off                  */
    }
  }

  return 0;
}
