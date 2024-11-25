/**
 * @file delay.c
 * @brief Delay capabilities.
 * 
 * @author Jason Scott <reachme@jasonpscott.com>
 * @date 2024-11-21
 * @copyright Copyright (c) 2024
 */
#include "delay.h"

void delay(int32_t count)
{
    asm volatile("__delay_%=: subs %[count], %[count], #1; bne __delay_%=\n"
            : "=r"(count): [count]"0"(count) : "cc");
}
