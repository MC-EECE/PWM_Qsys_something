#ifndef _PWM_H_
#define _PWM_H_
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include "system.h"
#include <stdio.h>
#include <unistd.h>

#define PWM_PULSE_WIDTH_REG 0	//Giving meaningful parameter names to PWM registers
#define PWM_PERIOD_REG 1
#define PWM_ENABLE_REG 2
#endif
