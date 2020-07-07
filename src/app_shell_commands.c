#include "shell/shell.h"

#include <libopencm3/cm3/scb.h>
#include <stddef.h>
#include <stdio.h>

#include "memfault/panics/assert.h"


#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))

int cli_command_ping(int argc, char *argv[]) {
    shell_put_line("PONG");
    return 0;
}

int cli_command_greet(int argc, char *argv[]) {
    char buf[64];
    snprintf(buf, sizeof(buf), "Hello %s!", argv[1]);
    shell_put_line(buf);
    return 0;
}

int cli_command_fault(int argc, char *argv[]) {
    void (*g_bad_func_call)(void) = (void (*)(void))0x20000002;
    g_bad_func_call();
    return 0;
}

int cli_command_heap_free(int argc, char *argv[]) {
    char buf[64];
    snprintf(buf, sizeof(buf), "2000");
    shell_put_line(buf);
    return 0;
}

static const sShellCommand s_shell_commands[] = {
  {"help", shell_help_handler, "Lists all commands"},
  {"ping", cli_command_ping, "Prints PONG"},
  {"fault", cli_command_fault, "Crash"},
  {"greet", cli_command_greet, "Greet"},
  {"heap_free", cli_command_heap_free, "Heap Free"},
};

const sShellCommand *const g_shell_commands = s_shell_commands;
const size_t g_num_shell_commands = ARRAY_SIZE(s_shell_commands);
