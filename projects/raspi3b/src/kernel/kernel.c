#include "mini_uart.h"

void kernel_main(void)
{
	uart_init();
	uart_send_string("Hello, kernel world! Love, RPi 3B.\r\n");

	while (1)
	{
		uart_send(uart_recv());
	}
}
