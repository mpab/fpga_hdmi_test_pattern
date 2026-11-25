#include <iostream>
#include <string>
#include <verilated.h>
#include "Vtest.h"

double sc_time_stamp() { return 0.0; }

int main(int argc, char** argv) {
    Verilated::commandArgs(0, static_cast<const char**>(nullptr));
    VerilatedContext contextp;
    Vtest hw(&contextp, "TOP");

    int ticks = 4000;

    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--ticks") {
            if (i + 1 < argc) ticks = std::stoi(argv[++i]);
        } else if (arg == "--help") {
            std::cout << "usage: " << argv[0] << " [--ticks N]\n";
            return 0;
        }
    }

    hw.pixel_rst_n = 1;
    hw.res_sel = 3;

    for (int n = 0; n < ticks; ++n) {
        hw.pixel_clk = 0;
        hw.eval();
        hw.pixel_clk = 1;
        hw.eval();

        if (hw.rgb_data != 0) {
            std::cout << n << " beam=(" << hw.beam_x << "," << hw.beam_y << ")\n";
        }
    }

    return 0;
}
