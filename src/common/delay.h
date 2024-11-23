/**
 * @file delay.h
 * @brief Delay capabilities.
 * 
 * @author Jason Scott <reachme@jasonpscott.com>
 * @date 2024-11-21
 * @copyright Copyright (c) 2024
 */
#ifndef KERNEL_2B_INC_COMMON_DELAY_H
#define KERNEL_2B_INC_COMMON_DELAY_H

#include <stddef.h>
#include <stdint.h>

/**
 * @brief Delay by minimally busy-wait looping of clock cycles.
 * 
 * Delays execution by `count_cycles` number of clock cycles. This function
 * is clock frequency-dependent, so the real time of delay is dependent on the
 * frequency at which the CPU/MCU is running.    
 * 
 * @param count_cycles
 */
void delay(int32_t count_cycles);

#endif // End include guard.
