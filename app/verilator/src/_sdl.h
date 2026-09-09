#pragma once

#if !defined(_SDL_USE_VERSION)
#error "you must set _SDL_USE_VERSION before including this file"
#endif

#if _SDL_USE_VERSION == 2
#include <SDL.h>
#endif

#if _SDL_USE_VERSION == 3
#include <SDL3/SDL.h>
#endif

#include <stdexcept>

namespace _sdl {

  #if _SDL_USE_VERSION == 2
  enum { APP_FAILURE = 0, EVENT_QUIT = SDL_QUIT };
  #endif

  #if _SDL_USE_VERSION == 3
  enum { APP_FAILURE = SDL_APP_FAILURE, EVENT_QUIT = SDL_EVENT_QUIT };
  #endif

typedef struct { // for SDL texture
  uint8_t a;     // transparency
  uint8_t b;     // blue
  uint8_t g;     // green
  uint8_t r;     // red
} Pixel;

// hardware currently restricted to 640x480
const unsigned int H_RES = 640;
const unsigned int V_RES = 480;

struct SDL {
  Pixel screenbuffer[H_RES * V_RES];
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

  ~SDL() { exit(); }

  void error(const char *err) { throw std::runtime_error(err); }

#if _SDL_USE_VERSION == 2
  SDL() {
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
      error("SDL init failed");
    }

    _window =
        SDL_CreateWindow("verilator_SDL2", SDL_WINDOWPOS_CENTERED,
                         SDL_WINDOWPOS_CENTERED, H_RES, V_RES, SDL_WINDOW_SHOWN);
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
                                 SDL_TEXTUREACCESS_TARGET, H_RES, V_RES);
    if (!_texture) {
      error("Texture creation failed");
    }
  }

  void render() {
    SDL_UpdateTexture(_texture, NULL, screenbuffer, H_RES * sizeof(Pixel));
    SDL_RenderCopy(_renderer, _texture, NULL, NULL);
    SDL_RenderPresent(_renderer);
  }
#endif //_SDL_USE_VERSION==2

#if _SDL_USE_VERSION == 3

  SDL() {
    if (!SDL_Init(SDL_INIT_VIDEO)) {
      error("SDL init failed");
    }

    // int display = -1;
    // auto pDM = SDL_GetDesktopDisplayMode((++display) + 1);
    // while (!pDM) {
    //   pDM = SDL_GetDesktopDisplayMode((++display) + 1);
    // }
    // auto screen_height = pDM->h;
    // while ((((++SCALING + 1) * VideoHardware::V_RES)) <= screen_height)
    //   ;
    // SDL_Log("Display: %d, Scaling: %d, Screen(%d, %d)\n", display, SCALING,
    //         VideoHardware::H_RES * SCALING, VideoHardware::V_RES * SCALING);

    // if (!SDL_CreateWindowAndRenderer(
    //         "verilator_SDL3", VideoHardware::H_RES * SCALING,
    //         VideoHardware::V_RES * SCALING, 0, &_window, &_renderer)) {
    //   error("Couldn't create window/renderer");
    // }

    if (!SDL_CreateWindowAndRenderer("verilator_SDL3", H_RES, V_RES, 0, &_window,
                                     &_renderer)) {
      error("Couldn't create window/renderer");
    }

    _texture = SDL_CreateTexture(_renderer, SDL_PIXELFORMAT_RGBA8888,
                                 SDL_TEXTUREACCESS_TARGET, H_RES, V_RES);
    if (!_texture) {
      error("Texture creation failed");
    }
  }

  void render() {
    SDL_UpdateTexture(_texture, NULL, screenbuffer, H_RES * sizeof(Pixel));
    SDL_RenderTexture(_renderer, _texture, NULL, NULL);
    SDL_RenderPresent(_renderer);
  }
#endif //_SDL_USE_VERSION==3
};

} // namespace _sdl
