#include "Vsim.h"
#include "_sdl.h"
#include <vector>
#include <verilated.h>

double sc_time_stamp();

namespace sim {

extern vluint64_t main_time; // Current simulation time

void print_sw(std::vector<bool> sw) {
  SDL_Log("sw=%s-%s\n", sw[1] ? "U" : "D", sw[0] ? "U" : "D");
}

void print_btn(std::vector<bool> btn) {
  SDL_Log("btn=%s-%s-%s-%s\n", btn[3] ? "1" : "0", btn[2] ? "1" : "0",
          btn[1] ? "1" : "0", btn[0] ? "1" : "0");
}

void reset(Vsim &hw) {
  hw.pixel_clk = 0;
  hw.pixel_rst_n = 0;
  hw.eval();

  hw.pixel_clk = 1;
  hw.eval();

  hw.pixel_clk = 0;
  hw.pixel_rst_n = 1;
  hw.eval();

  hw.pixel_clk = 1;
  hw.eval();
}

static inline int _main(int argc, char *argv[]) {
  Verilated::commandArgs(argc, argv);

  auto hw = Vsim();
  reset(hw);

  std::vector<bool> sw(2);
  std::vector<bool> btn = {hw.led & 1, hw.led & 2, hw.led & 4, hw.led & 8};//  {1, 0, 0, 0};

  SDL_Log("hw.h_res=%d, hw.v_res=%d\n", hw.h_res, hw.v_res);
  auto sdl = _sdl::SDL(hw.h_res, hw.v_res);
  bool full_screen = false;

  const Uint8 *keyb_state = (Uint8 *)SDL_GetKeyboardState(NULL);

  if (!keyb_state) {
    return sdl.exit("SDL_GetKeyboardState failed", _sdl::APP_FAILURE);
  }

  SDL_Log("Simulation running. 'S' toggle full screen/window. 'Q' or ESC to "
          "exit.\n");
  SDL_Log("INS/DEL=SW1 UP/DOWN, HOME/END=SW0 UP/DOWN\n");
  SDL_Log("F9-F12=btn[3]-btn[0]\n\n");
  print_sw(sw);
  print_btn(btn);

  uint64_t frame_count = 0;
  uint64_t start_ticks = SDL_GetPerformanceCounter();

  int PREV_SDL_SCANCODE_S = 0;

  while (true) {
    ++main_time;
    // cycle the clock
    hw.pixel_clk = 1;
    hw.eval();
    hw.pixel_clk = 0;
    hw.eval();

    if (hw.de) {
      auto *p = &sdl.screenbuffer[hw.beam_y * hw.h_res + hw.beam_x];
      p->a = 0xFF; // transparency
      p->b = hw.blue;
      p->g = hw.green;
      p->r = hw.red;
    }

    // update texture outside draw window
    // if (sim.v_sync)
    // the above should work, but SDL gets stuck here, so check coords instead
    if (hw.frame_start) {
      // check for quit event
      SDL_Event e;
      if (SDL_PollEvent(&e) && e.type == _sdl::EVENT_QUIT)
        break;
      if (keyb_state[SDL_SCANCODE_Q] || keyb_state[SDL_SCANCODE_ESCAPE])
        break; // quit if user presses 'Q' or 'escape'
      if (keyb_state[SDL_SCANCODE_S] && !PREV_SDL_SCANCODE_S) {
        full_screen = !full_screen;
        SDL_SetWindowFullscreen(sdl._window, full_screen);
      }
      PREV_SDL_SCANCODE_S = keyb_state[SDL_SCANCODE_S];

      auto osw = sw;
      if (keyb_state[SDL_SCANCODE_INSERT]) {
        sw[1] = true;
      }
      if (keyb_state[SDL_SCANCODE_DELETE]) {
        sw[1] = false;
      }
      if (keyb_state[SDL_SCANCODE_HOME]) {
        sw[0] = true;
      }
      if (keyb_state[SDL_SCANCODE_END]) {
        sw[0] = false;
      }
      if (not std::equal(std::begin(sw), std::end(sw), std::begin(osw))) {
        hw.sw = sw[0] + (sw[1] << 1);
        print_sw(sw);
      }

      auto obtn = btn;
      if (keyb_state[SDL_SCANCODE_F12]) {
        btn = {true, false, false, false};
      } else if (keyb_state[SDL_SCANCODE_F11]) {
        btn = {false, true, false, false};
      } else if (keyb_state[SDL_SCANCODE_F10]) {
        btn = {false, false, true, false};
      } else if (keyb_state[SDL_SCANCODE_F9]) {
        btn = {false, false, false, true};
      }

      if (not std::equal(std::begin(btn), std::end(btn), std::begin(obtn))) {
        hw.btn = btn[0] + (btn[1] << 1) + (btn[2] << 2) + (btn[3] << 3);
        print_btn(btn);
      }

      sdl.render();
      frame_count++;
    }
  }
  uint64_t end_ticks = SDL_GetPerformanceCounter();
  double duration =
      ((double)(end_ticks - start_ticks)) / SDL_GetPerformanceFrequency();
  double fps = (double)frame_count / duration;
  SDL_Log("Frames per second: %.1f\n", fps);

  return 0;
}

} // namespace sim
