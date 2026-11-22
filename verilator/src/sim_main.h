#include "Vsim.h"
#include "_sdl.h"
#include <vector>
#include <verilated.h>

double sc_time_stamp();

namespace sim {

extern vluint64_t main_time; // Current simulation time

inline void print_sw_btn(std::vector<bool> sw, std::vector<bool> btn) {
  // SDL_Log("\033[1;1H");
  SDL_Log("\033[3A");
  SDL_Log("switches %s-%s\n", sw[1] ? "U" : "D", sw[0] ? "U" : "D");
  SDL_Log("buttons  %s-%s-%s-%s\n", btn[3] ? "1" : "0", btn[2] ? "1" : "0",
          btn[1] ? "1" : "0", btn[0] ? "1" : "0");
}

inline void cycle(Vsim &hw) {
  hw.pixel_clk = 0;
  hw.eval();
  hw.pixel_clk = 1;
  hw.eval();
}

inline void reset(Vsim &hw) {
  hw.pixel_rst_n = 0;
  cycle(hw);
  hw.pixel_rst_n = 1;
}

static inline int _main(int argc, char *argv[]) {
  Verilated::commandArgs(argc, argv);

  auto hw = Vsim();
  reset(hw);

  std::vector<bool> sw(2);
  std::vector<bool> btn = {
      static_cast<bool>(hw.led & 1), static_cast<bool>(hw.led & 2),
      static_cast<bool>(hw.led & 4), static_cast<bool>(hw.led & 8)};

  SDL_Log("hw.h_res=%d, hw.v_res=%d\n", hw.h_res, hw.v_res);
  SDL_Log("hw.h_total=%d, hw.v_total=%d\n", hw.h_total, hw.v_total);
  auto sdl = _sdl::SDL(hw.h_res, hw.v_res);
  bool full_screen = false;

  const Uint8 *keyb_state = (Uint8 *)SDL_GetKeyboardState(NULL);

  if (!keyb_state) {
    return sdl.exit("SDL_GetKeyboardState failed", _sdl::APP_FAILURE);
  }

  SDL_Log("Control the simulation using the following keys:\n");
  SDL_Log("'S' toggle full screen/window. 'Q' or ESC to exit.\n");
  SDL_Log("I/K=switch 1 UP/DOWN, O/L=switch 2 UP/DOWN\n");
  SDL_Log("7,8,9,0=button[3]-button[0]\n\n");
  SDL_Log("\n\n");
  print_sw_btn(sw, btn);

  uint64_t frame_count = 0;
  uint64_t start_ticks = SDL_GetPerformanceCounter();

  int PREV_SDL_SCANCODE_S = 0;
  // int minx = 1000;
  // int maxx = -1000;
  // int miny = 1000;
  // int maxy = -1000;

  while (true) {
    ++main_time;
    // cycle the clock
    cycle(hw);

    // SDL_Log("hw.de: %d, hw.beam_x: %d, hw.beam_y: %d", hw.de, hw.beam_x,
    // hw.beam_y);
    if (hw.de) {
      // minx = (hw.beam_x > minx) ? minx : hw.beam_x;
      // maxx = (hw.beam_x < maxx) ? maxx : hw.beam_x;
      // miny = (hw.beam_y > miny) ? miny : hw.beam_y;
      // maxy = (hw.beam_y < maxy) ? maxy : hw.beam_y;
      auto *p = &sdl.screenbuffer[hw.beam_y * hw.h_res + hw.beam_x];
      p->a = 0xFF; // transparency
      p->b = hw.blue;
      p->g = hw.green;
      p->r = hw.red;

      // p = &sdl.screenbuffer[0];
      // p->a = 0xFF; // transparency
      // p->b = 0xFF;
      // p->g = 0xAA;
      // p->r = 0xAA;
      // p = &sdl.screenbuffer[hw.h_res * hw.v_res -1];
      // p->a = 0xFF; // transparency
      // p->b = 0xAA;
      // p->g = 0xFF;
      // p->r = 0xAA;
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
      if (keyb_state[SDL_SCANCODE_I]) {
        sw[1] = true;
      }
      if (keyb_state[SDL_SCANCODE_K]) {
        sw[1] = false;
      }
      if (keyb_state[SDL_SCANCODE_O]) {
        sw[0] = true;
      }
      if (keyb_state[SDL_SCANCODE_L]) {
        sw[0] = false;
      }
      if (not std::equal(std::begin(sw), std::end(sw), std::begin(osw))) {
        hw.sw = sw[0] + (sw[1] << 1);
        print_sw_btn(sw, btn);
      }

      auto obtn = btn;
      if (keyb_state[SDL_SCANCODE_0]) {
        btn = {true, false, false, false};
      } else if (keyb_state[SDL_SCANCODE_9]) {
        btn = {false, true, false, false};
      } else if (keyb_state[SDL_SCANCODE_8]) {
        btn = {false, false, true, false};
      } else if (keyb_state[SDL_SCANCODE_7]) {
        btn = {false, false, false, true};
      }

      if (not std::equal(std::begin(btn), std::end(btn), std::begin(obtn))) {
        hw.btn = btn[0] + (btn[1] << 1) + (btn[2] << 2) + (btn[3] << 3);
        print_sw_btn(sw, btn);
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
  // SDL_Log("minx=%d, maxx=%d\n", minx, maxx);
  // SDL_Log("miny=%d, maxy=%d\n", miny, maxy);

  return 0;
}

} // namespace sim
