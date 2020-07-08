#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include <libopencm3/cm3/vector.h>
#include <libopencm3/stm32/usart.h>
#include <shell/shell.h>

#include "clock.h"
#include "gpio.h"
#include "usart.h"


int main(void) {
    clock_setup();
    gpio_setup();
    usart_setup();

    printf("App STARTED\n");

    // Configure shell
    sShellImpl shell_impl = {
      .send_char = usart_putc,
    };
    shell_boot(&shell_impl);

    char c;
    while (1) {
        c = usart_getc();
        shell_receive_char(c);
    }

    return 0;
}
