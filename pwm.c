
#include "pwm_work.h"
#include "system.h"
 
int main(void)
{ 
    alt_u32 period, pulse_width;					//Declaring variables
    alt_u8 enable = 0;
    alt_u32 pcheck, pwcheck;						//Declaring variables to check passed values
    alt_u8 echeck;
    IOWR(PWM_0_BASE, PWM_ENABLE_REG, enable);
    while(1){
    	enable = (IORD(SLIDER_SWITCHES_BASE, 0)&0x20000)?1:0;	//Reading Switch Values
    	pulse_width = IORD(SLIDER_SWITCHES_BASE, 0)&0xFF;
    	period = (IORD(SLIDER_SWITCHES_BASE,0)&0xFF00) >> 8;

    	IOWR(PWM_0_BASE, PWM_PERIOD_REG, period);		//Setting PWM Period
    	pcheck = IORD(PWM_0_BASE, PWM_PERIOD_REG);

    	IOWR(PWM_0_BASE, PWM_PULSE_WIDTH_REG, pulse_width);	//Setting PWM Pulse Width
    	pwcheck = IORD(PWM_0_BASE, PWM_PULSE_WIDTH_REG);

    	if((pwcheck == pulse_width) && (pcheck == period)){			//Setting PWM Enable if values are correct
    		IOWR(PWM_0_BASE, PWM_ENABLE_REG, enable);
    	}
    }
    return 0;
}
