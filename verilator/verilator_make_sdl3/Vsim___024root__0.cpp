// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsim.h for the primary calling header

#include "Vsim__pch.h"

void Vsim___024root___eval_sample(Vsim___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___eval_sample\n"); );
    Vsim__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsim___024root___dump_triggers__ico(const VlUnpacked<QData/*63:0*/, 2> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vsim___024root___eval_ico(Vsim___024root* vlSelf, CData/*0:0*/ firstIteration) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___eval_ico\n"); );
    Vsim__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VicoTriggered[1U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VicoTriggered[1U]) 
                                     | (IData)((IData)(firstIteration)));
    {
        // Inlined CFunc: _eval_triggers_vec__ico
        vlSelfRef.__VicoTriggered[0U] = (QData)((IData)(
                                                        ((((IData)(vlSelfRef.reset) 
                                                           != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__reset__0)) 
                                                          << 1U) 
                                                         | ((IData)(vlSelfRef.clk) 
                                                            != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__0)))));
        vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
        vlSelfRef.__Vtrigprevexpr___TOP__reset__0 = vlSelfRef.reset;
        if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.__VicoDidInit)))))) {
            vlSelfRef.__VicoDidInit = 1U;
            vlSelfRef.__VicoTriggered[0U] = (1ULL | vlSelfRef.__VicoTriggered[0U]);
            vlSelfRef.__VicoTriggered[0U] = (2ULL | vlSelfRef.__VicoTriggered[0U]);
        }
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vsim___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
    }
#endif
    return (0U);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsim___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
void Vsim___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in);

bool Vsim___024root___eval_act(Vsim___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___eval_act\n"); );
    Vsim__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__act
        vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                        ((IData)(vlSelfRef.clk) 
                                                         & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__1)))));
        vlSelfRef.__Vtrigprevexpr___TOP__clk__1 = vlSelfRef.clk;
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vsim___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vsim___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    return (0U);
}

bool Vsim___024root___eval_inact(Vsim___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___eval_inact\n"); );
    Vsim__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    return (0U);
}

bool Vsim___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);
void Vsim___024root___nba_sequent__TOP__0(Vsim___024root* vlSelf);
void Vsim___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out);

bool Vsim___024root___eval_nba(Vsim___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___eval_nba\n"); );
    Vsim__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vsim___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        {
            // Inlined CFunc: _eval_body__nba
            if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
                Vsim___024root___nba_sequent__TOP__0(vlSelf);
            }
        }
        Vsim___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

bool Vsim___024root___eval_obs(Vsim___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___eval_obs\n"); );
    Vsim__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    return (0U);
}

bool Vsim___024root___eval_react(Vsim___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___eval_react\n"); );
    Vsim__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    return (0U);
}

void Vsim___024root___eval_postponed(Vsim___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___eval_postponed\n"); );
    Vsim__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

bool Vsim___024root___trigger_anySet__ico(const VlUnpacked<QData/*63:0*/, 2> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___trigger_anySet__ico\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((2U > n));
    return (0U);
}

bool Vsim___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vsim___024root___nba_sequent__TOP__0(Vsim___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___nba_sequent__TOP__0\n"); );
    Vsim__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    SData/*15:0*/ __Vdly__sim__DOT__video_signals__DOT__l_beam_y;
    __Vdly__sim__DOT__video_signals__DOT__l_beam_y = 0;
    SData/*15:0*/ __Vdly__sim__DOT__video_signals__DOT__l_beam_x;
    __Vdly__sim__DOT__video_signals__DOT__l_beam_x = 0;
    // Body
    __Vdly__sim__DOT__video_signals__DOT__l_beam_y 
        = vlSelfRef.sim__DOT__video_signals__DOT__l_beam_y;
    __Vdly__sim__DOT__video_signals__DOT__l_beam_x 
        = vlSelfRef.sim__DOT__video_signals__DOT__l_beam_x;
    if ((1U & (~ (IData)(vlSelfRef.reset)))) {
        if ((0x0000027fU == VL_EXTENDS_II(32,16, (IData)(vlSelfRef.sim__DOT__video_signals__DOT__l_beam_x)))) {
            __Vdly__sim__DOT__video_signals__DOT__l_beam_y 
                = ((0x000001dfU == VL_EXTENDS_II(32,16, (IData)(vlSelfRef.sim__DOT__video_signals__DOT__l_beam_y)))
                    ? 0x0000ffd3U : (0x0000ffffU & 
                                     ((IData)(1U) + 
                                      VL_EXTENDS_II(32,16, (IData)(vlSelfRef.sim__DOT__video_signals__DOT__l_beam_y)))));
            __Vdly__sim__DOT__video_signals__DOT__l_beam_x = 0xff60U;
        } else {
            __Vdly__sim__DOT__video_signals__DOT__l_beam_x 
                = (0x0000ffffU & ((IData)(1U) + VL_EXTENDS_II(16,16, (IData)(vlSelfRef.sim__DOT__video_signals__DOT__l_beam_x))));
        }
    }
    if (vlSelfRef.video_enable) {
        vlSelfRef.blue = vlSelfRef.sim__DOT__source__DOT___blue;
        vlSelfRef.red = vlSelfRef.sim__DOT__source__DOT___red;
        vlSelfRef.green = vlSelfRef.sim__DOT__source__DOT___green;
    } else {
        vlSelfRef.blue = 0U;
        vlSelfRef.red = 0U;
        vlSelfRef.green = 0U;
    }
    vlSelfRef.sim__DOT__source__DOT___blue = (0x000003ffU 
                                              & (((IData)(vlSelfRef.beam_y) 
                                                  | (IData)(vlSelfRef.sim__DOT__source__DOT__fg__DOT__W)) 
                                                 | (IData)(vlSelfRef.sim__DOT__source__DOT__fg__DOT__A)));
    vlSelfRef.sim__DOT__source__DOT___red = (((0x000003f0U 
                                               & (((IData)(vlSelfRef.beam_x) 
                                                   & (- (IData)(
                                                                ((3U 
                                                                  & ((IData)(vlSelfRef.beam_y) 
                                                                     >> 3U)) 
                                                                 == 
                                                                 (3U 
                                                                  & (~ 
                                                                     ((IData)(vlSelfRef.beam_x) 
                                                                      >> 3U))))))) 
                                                  << 4U)) 
                                              | (IData)(vlSelfRef.sim__DOT__source__DOT__fg__DOT__W)) 
                                             & (~ (IData)(vlSelfRef.sim__DOT__source__DOT__fg__DOT__A)));
    vlSelfRef.sim__DOT__source__DOT___green = (0x000003ffU 
                                               & ((((IData)(vlSelfRef.beam_x) 
                                                    & (- (IData)(
                                                                 (1U 
                                                                  & ((IData)(vlSelfRef.beam_y) 
                                                                     >> 6U))))) 
                                                   | (IData)(vlSelfRef.sim__DOT__source__DOT__fg__DOT__W)) 
                                                  & (~ (IData)(vlSelfRef.sim__DOT__source__DOT__fg__DOT__A))));
    if (vlSelfRef.reset) {
        vlSelfRef.beam_y = 0U;
        vlSelfRef.beam_x = 0U;
    } else {
        vlSelfRef.beam_y = vlSelfRef.sim__DOT__video_signals__DOT__l_beam_y;
        vlSelfRef.beam_x = vlSelfRef.sim__DOT__video_signals__DOT__l_beam_x;
    }
    vlSelfRef.sim__DOT__video_signals__DOT__l_beam_y 
        = __Vdly__sim__DOT__video_signals__DOT__l_beam_y;
    vlSelfRef.sim__DOT__video_signals__DOT__l_beam_x 
        = __Vdly__sim__DOT__video_signals__DOT__l_beam_x;
    vlSelfRef.v_sync = (1U & (~ (VL_LTES_III(32, 0x000001eaU, 
                                             ((IData)(0x0000020dU) 
                                              + VL_EXTENDS_II(32,16, (IData)(vlSelfRef.beam_y)))) 
                                 & VL_GTS_III(32, 0x000001ecU, 
                                              ((IData)(0x0000020dU) 
                                               + VL_EXTENDS_II(32,16, (IData)(vlSelfRef.beam_y)))))));
    vlSelfRef.h_sync = (1U & (~ (VL_LTES_III(32, 0x00000290U, 
                                             ((IData)(0x00000320U) 
                                              + VL_EXTENDS_II(32,16, (IData)(vlSelfRef.beam_x)))) 
                                 & VL_GTS_III(32, 0x000002f0U, 
                                              ((IData)(0x00000320U) 
                                               + VL_EXTENDS_II(32,16, (IData)(vlSelfRef.beam_x)))))));
    vlSelfRef.video_enable = (VL_LTES_III(32, 0U, VL_EXTENDS_II(32,16, (IData)(vlSelfRef.beam_x))) 
                              & (VL_GTS_III(32, 0x00000280U, 
                                            VL_EXTENDS_II(32,16, (IData)(vlSelfRef.beam_x))) 
                                 & (VL_LTES_III(32, 0U, 
                                                VL_EXTENDS_II(32,16, (IData)(vlSelfRef.beam_y))) 
                                    & VL_GTS_III(32, 0x000001e0U, 
                                                 VL_EXTENDS_II(32,16, (IData)(vlSelfRef.beam_y))))));
    vlSelfRef.sim__DOT__source__DOT__fg__DOT__W = (0x000003ffU 
                                                   & (- (IData)(
                                                                ((0x000000ffU 
                                                                  & (IData)(vlSelfRef.beam_y)) 
                                                                 == 
                                                                 (0x000000ffU 
                                                                  & (IData)(vlSelfRef.beam_x))))));
    vlSelfRef.sim__DOT__source__DOT__fg__DOT__A = (0x000003ffU 
                                                   & (- (IData)((IData)(
                                                                        ((0x0040U 
                                                                          == 
                                                                          (0x00e0U 
                                                                           & (IData)(vlSelfRef.beam_x))) 
                                                                         & (0x0040U 
                                                                            == 
                                                                            (0x00e0U 
                                                                             & (IData)(vlSelfRef.beam_y))))))));
    vlSelfRef.line_start = (0xffffff60U == VL_EXTENDS_II(32,16, (IData)(vlSelfRef.beam_x)));
    vlSelfRef.frame_start = ((0xffffffd3U == VL_EXTENDS_II(32,16, (IData)(vlSelfRef.beam_y))) 
                             & (IData)(vlSelfRef.line_start));
}

void Vsim___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

void Vsim___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

#ifdef VL_DEBUG
void Vsim___024root___eval_debug_assertions(Vsim___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsim___024root___eval_debug_assertions\n"); );
    Vsim__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk & 0xfeU)))) {
        Verilated::overWidthError("clk");
    }
    if (VL_UNLIKELY(((vlSelfRef.reset & 0xfeU)))) {
        Verilated::overWidthError("reset");
    }
}
#endif  // VL_DEBUG
