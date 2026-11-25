#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <cstdlib>
#include <verilated.h>
#include "Vtest.h"

double sc_time_stamp() { return 0.0; }

static void print_row(long long tick, const Vtest& hw) {
    std::cout << tick << ',' << (unsigned)hw.beam_x << ',' << (unsigned)hw.beam_y << ','
              << (unsigned)hw.h_sync << ',' << (unsigned)hw.v_sync << ','
              << (unsigned)hw.h_blank << ',' << (unsigned)hw.v_blank << ','
              << (unsigned)hw.de << ',' << (unsigned)hw.frame_start << ','
              << (unsigned)hw.line_start << ',' << (unsigned)hw.beam_at_zero << ','
              << (unsigned)hw.rgb_data << '\n';
}

int main(int argc, char** argv) {
    int res = -1;
    int pattern = 0;
    bool reset = false;
    std::vector<long long> ticks;

    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--res") {
            if (i + 1 < argc) res = std::atoi(argv[++i]);
        } else if (arg == "--pattern") {
            if (i + 1 < argc) pattern = std::atoi(argv[++i]);
        } else if (arg == "--ticks") {
            if (i + 1 < argc) {
                std::string list = argv[++i];
                std::size_t pos = 0;
                while (pos < list.size()) {
                    std::size_t comma = list.find(',', pos);
                    std::string item = list.substr(
                        pos, comma == std::string::npos ? std::string::npos : comma - pos
                    );
                    if (!item.empty()) ticks.push_back(std::strtoll(item.c_str(), nullptr, 10));
                    if (comma == std::string::npos) break;
                    pos = comma + 1;
                }
            }
        } else if (arg == "--reset") {
            reset = true;
        } else if (arg == "--help") {
            std::cout << "usage: test.exe --res 0..3 --pattern 0..3 --ticks t1,t2,... [--reset]\n";
            return 0;
        } else {
            std::cerr << "unknown option: " << arg << '\n';
            return 2;
        }
    }

    if (res < 0 || res > 3 || pattern < 0 || pattern > 3 || (ticks.empty() && !reset)) {
        std::cerr << "usage: test.exe --res 0..3 --pattern 0..3 --ticks t1,t2,... [--reset]\n";
        return 2;
    }

    std::sort(ticks.begin(), ticks.end());
    ticks.erase(std::unique(ticks.begin(), ticks.end()), ticks.end());

    Verilated::commandArgs(0, static_cast<const char**>(nullptr));
    VerilatedContext contextp;
    Vtest hw(&contextp, "TOP");

    hw.pixel_clk = 0;
    hw.pixel_rst_n = 1;
    hw.res_sel = res;
    hw.pattern_sel = pattern;
    hw.eval();

    if (reset) {
        hw.pixel_rst_n = 0;
        hw.eval();
        print_row(-1, hw);
        hw.pixel_rst_n = 1;
        hw.eval();
    }

    if (ticks.empty()) return 0;

    long long max_tick = ticks.back();
    std::size_t next = 0;

    for (long long n = 0; n <= max_tick; ++n) {
        hw.pixel_clk = 0;
        hw.eval();
        hw.pixel_clk = 1;
        hw.eval();

        while (next < ticks.size() && ticks[next] == n) {
            print_row(n, hw);
            ++next;
        }

        if (next == ticks.size()) break;
    }

    return 0;
}
