#pragma once

#include <span>
#include <stdexcept>

#if !defined(MB_SDL_VER_OPT)
#error "you must set MB_SDL_VER_OPT before including this file"
#endif

#if MB_SDL_VER_OPT == 2
#include <SDL.h>
#endif

#if MB_SDL_VER_OPT == 3
#include <SDL3/SDL.h>
#endif

namespace _sdl {

#if MB_SDL_VER_OPT == 2
enum { APP_FAILURE = 0, EVENT_QUIT = SDL_QUIT };
#endif

#if MB_SDL_VER_OPT == 3
enum { APP_FAILURE = SDL_APP_FAILURE, EVENT_QUIT = SDL_EVENT_QUIT };
#endif

typedef struct { // for SDL texture
  uint8_t a;     // transparency
  uint8_t b;     // blue
  uint8_t g;     // green
  uint8_t r;     // red
} Pixel;

struct SDL {
  virtual ~SDL() {
    delete [] screenbuffer;
    exit();
  }

  unsigned int h_res, v_res;

  Pixel *screenbuffer;
  // std::span<Pixel> screenbuffer;

  SDL_Window *_window = NULL;
  SDL_Renderer *_renderer = NULL;
  SDL_Texture *_texture = NULL;

  void exit() {
    SDL_DestroyTexture(_texture);
    _window = NULL;
    SDL_DestroyRenderer(_renderer);
    _renderer = NULL;
    SDL_DestroyWindow(_window);
    _window = NULL;
    SDL_Quit();
  }

  int exit(const char *msg, int error = 0) {
    if (error)
      SDL_Log("%s: %s", msg, SDL_GetError());

    exit();
    return error;
  }

  void error(const char *err) { throw std::runtime_error(err); }

#if MB_SDL_VER_OPT == 2
  SDL(unsigned int h_res = 1920, unsigned int v_res = 1080)
      : h_res(h_res), v_res(v_res) {
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
      error("SDL init failed");
    }
    screenbuffer = new Pixel[h_res * v_res];

    _window = SDL_CreateWindow("verilator_SDL2", SDL_WINDOWPOS_CENTERED,
                               SDL_WINDOWPOS_CENTERED, h_res, v_res,
                               SDL_WINDOW_SHOWN);
    if (!_window) {
      error("Window creation failed");
    }
    // if (FULLSCREEN)
    //   SDL_SetWindowFullscreen(_window, _window_FULLSCREEN);

    _renderer = SDL_CreateRenderer(_window, -1, 0);
    if (!_renderer) {
      error("Renderer creation failed");
    }

    _texture = SDL_CreateTexture(_renderer, SDL_PIXELFORMAT_RGBA8888,
                                 SDL_TEXTUREACCESS_TARGET, h_res, v_res);
    if (!_texture) {
      error("Texture creation failed");
    }
  }

  void render() {
    SDL_UpdateTexture(_texture, NULL, screenbuffer, h_res * sizeof(Pixel));
    SDL_RenderCopy(_renderer, _texture, NULL, NULL);
    SDL_RenderPresent(_renderer);
  }
#endif // MB_SDL_VER_OPT==2

#if MB_SDL_VER_OPT == 3

  SDL(unsigned int h_res = 1920, unsigned int v_res = 1080)
      : h_res(h_res), v_res(v_res) {
    if (!SDL_Init(SDL_INIT_VIDEO)) {
      error("SDL init failed");
    }
    screenbuffer = new Pixel[h_res * v_res];

    // int display = -1;
    // auto pDM = SDL_GetDesktopDisplayMode((++display) + 1);
    // while (!pDM) {
    //   pDM = SDL_GetDesktopDisplayMode((++display) + 1);
    // }
    // auto screen_height = pDM->h;
    // while ((((++SCALING + 1) * VideoHardware::v_res)) <= screen_height)
    //   ;
    // SDL_Log("Display: %d, Scaling: %d, Screen(%d, %d)\n", display, SCALING,
    //         VideoHardware::h_res * SCALING, VideoHardware::v_res * SCALING);

    // if (!SDL_CreateWindowAndRenderer(
    //         "verilator_SDL3", VideoHardware::h_res * SCALING,
    //         VideoHardware::v_res * SCALING, 0, &_window, &_renderer)) {
    //   error("Couldn't create window/renderer");
    // }

    if (!SDL_CreateWindowAndRenderer("verilator_SDL3", h_res, v_res, 0,
                                     &_window, &_renderer)) {
      error("Couldn't create window/renderer");
    }

    _texture = SDL_CreateTexture(_renderer, SDL_PIXELFORMAT_RGBA8888,
                                 SDL_TEXTUREACCESS_TARGET, h_res, v_res);
    if (!_texture) {
      error("Texture creation failed");
    }
  }

  void render() {
    SDL_UpdateTexture(_texture, NULL, screenbuffer, h_res * sizeof(Pixel));
    SDL_RenderTexture(_renderer, _texture, NULL, NULL);
    SDL_RenderPresent(_renderer);
  }
#endif // MB_SDL_VER_OPT==3
};

} // namespace _sdl
