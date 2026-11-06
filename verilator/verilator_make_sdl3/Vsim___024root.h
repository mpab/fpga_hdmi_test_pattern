// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vsim.h for the primary calling header

#ifndef VERILATED_VSIM___024ROOT_H_
#define VERILATED_VSIM___024ROOT_H_  // guard

#include "verilated.h"


class Vsim__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vsim___024root final {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(reset,0,0);
    VL_OUT8(video_enable,0,0);
    VL_OUT8(v_sync,0,0);
    VL_OUT8(h_sync,0,0);
    VL_OUT8(frame_start,0,0);
    VL_OUT8(line_start,0,0);
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__reset__0;
    CData/*0:0*/ __VicoDidInit;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__1;
    VL_OUT16(beam_x,15,0);
    VL_OUT16(beam_y,15,0);
    VL_OUT16(red,9,0);
    VL_OUT16(green,9,0);
    VL_OUT16(blue,9,0);
    SData/*9:0*/ sim__DOT__source__DOT___red;
    SData/*9:0*/ sim__DOT__source__DOT___green;
    SData/*9:0*/ sim__DOT__source__DOT___blue;
    SData/*9:0*/ sim__DOT__source__DOT__fg__DOT__W;
    SData/*9:0*/ sim__DOT__source__DOT__fg__DOT__A;
    SData/*15:0*/ sim__DOT__video_signals__DOT__l_beam_x;
    SData/*15:0*/ sim__DOT__video_signals__DOT__l_beam_y;
    VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
    VlUnpacked<QData/*63:0*/, 2> __VicoTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vsim__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vsim___024root(Vsim__Syms* symsp, const char* namep);
    ~Vsim___024root();
    VL_UNCOPYABLE(Vsim___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
