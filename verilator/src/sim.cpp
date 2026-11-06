#include "sim_main.h"

vluint64_t sim::main_time = 0; // Current simulation time
double sc_time_stamp() {
    return sim::main_time; // Converts to double to match SystemC expectations
}

int main(int argc, char *argv[]) {
  return sim::_main(argc, argv);
}
