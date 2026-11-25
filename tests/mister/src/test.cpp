#include <iostream>
#include <string>
#include <verilated.h>
#include "Vtest.h"
#include "Vtest___024root.h"

double sc_time_stamp() { return 0.0; }

int main(int argc, char** argv) {
    Verilated::commandArgs(0, static_cast<const char**>(nullptr));
    VerilatedContext ctx;
    Vtest hw(&ctx, "TOP");

    int ticks = 400;
    bool scandouble = false;
    bool showBeam = false;

    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--ticks") {
            if (i + 1 < argc) ticks = std::stoi(argv[++i]);
        } else if (arg == "--scandouble") {
            scandouble = true;
        } else if (arg == "--beam") {
            showBeam = true;
        } else if (arg == "--help") {
            std::cout << "usage: " << argv[0] << " [--ticks N] [--scandouble] [--beam]\n";
            return 0;
        }
    }

    auto tick = [&](int clk) {
        hw.clk = clk;
        hw.eval();
    };

    auto printState = [&](const char* label) {
        std::cout << label
                  << " HBlank=" << int(hw.HBlank)
                  << " VBlank=" << int(hw.VBlank)
                  << " HSync=" << int(hw.HSync)
                  << " VSync=" << int(hw.VSync)
                  << " ce_pix=" << int(hw.ce_pix)
                  << " atzero=" << int(hw.hvcnt_atzero)
                  << " rgb=0x" << std::hex << hw.rgb_data << std::dec;
        if (showBeam) {
            std::cout << " beam=("
                      << hw.rootp->test__DOT__u_mycore__DOT__beam_x << ","
                      << hw.rootp->test__DOT__u_mycore__DOT__beam_y << ")";
        }
        std::cout << "\n";
    };

    // Reset held
    hw.reset = 1;
    hw.pal = 0;
    hw.scandouble = 0;
    hw.buttons = 0;
    tick(0);
    tick(1);
    printState("reset held:");

    // Reset released
    hw.reset = 0;
    hw.scandouble = scandouble ? 1 : 0;

    unsigned prev = hw.rgb_data;
    int changes = 0;
    for (int i = 0; i < ticks; ++i) {
        tick(i & 1);
        if (hw.rgb_data != prev) {
            ++changes;
            prev = hw.rgb_data;
        }
        if (showBeam && (i % 20 == 0)) {
            std::cout << "i=" << i << " ";
            printState("active");
        }
    }

    printState(scandouble ? "active scandouble:" : "active non-scandouble:");
    std::cout << "rgb_changes=" << changes << "\n";

    return 0;
}
