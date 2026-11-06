// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vsim__pch.h"

//============================================================
// Constructors

Vsim::Vsim(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vsim__Syms(contextp(), _vcname__, this)}
    , m_evalLoop{*this, /*convergeLimit:*/ 10000}
    , clk{vlSymsp->TOP.clk}
    , reset{vlSymsp->TOP.reset}
    , video_enable{vlSymsp->TOP.video_enable}
    , v_sync{vlSymsp->TOP.v_sync}
    , h_sync{vlSymsp->TOP.h_sync}
    , frame_start{vlSymsp->TOP.frame_start}
    , line_start{vlSymsp->TOP.line_start}
    , beam_x{vlSymsp->TOP.beam_x}
    , beam_y{vlSymsp->TOP.beam_y}
    , red{vlSymsp->TOP.red}
    , green{vlSymsp->TOP.green}
    , blue{vlSymsp->TOP.blue}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vsim::Vsim(const char* _vcname__)
    : Vsim(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vsim::~Vsim() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vsim___024root___eval_debug_assertions(Vsim___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vsim___024root___eval_static(Vsim___024root* vlSelf);
VL_ATTR_COLD void Vsim___024root___eval_initial(Vsim___024root* vlSelf);
VL_ATTR_COLD bool Vsim___024root___eval_stl(Vsim___024root* vlSelf, CData/*0:0*/ firstIteration);
void Vsim___024root___eval_sample(Vsim___024root* vlSelf);
bool Vsim___024root___eval_ico(Vsim___024root* vlSelf, CData/*0:0*/ firstIteration);
bool Vsim___024root___eval_act(Vsim___024root* vlSelf);
bool Vsim___024root___eval_inact(Vsim___024root* vlSelf);
bool Vsim___024root___eval_nba(Vsim___024root* vlSelf);
bool Vsim___024root___eval_obs(Vsim___024root* vlSelf);
bool Vsim___024root___eval_react(Vsim___024root* vlSelf);
void Vsim___024root___eval_postponed(Vsim___024root* vlSelf);
VL_ATTR_COLD void Vsim___024root___eval_final(Vsim___024root* vlSelf);
VL_ATTR_COLD void Vsim___024root___eval_dump_triggers__stl(Vsim___024root* vlSelf);
VL_ATTR_COLD void Vsim___024root___eval_dump_triggers__ico(Vsim___024root* vlSelf);
VL_ATTR_COLD void Vsim___024root___eval_dump_triggers__act(Vsim___024root* vlSelf);
VL_ATTR_COLD void Vsim___024root___eval_dump_triggers__nba(Vsim___024root* vlSelf);
VL_ATTR_COLD void Vsim___024root___eval_dump_triggers__obs(Vsim___024root* vlSelf);
VL_ATTR_COLD void Vsim___024root___eval_dump_triggers__react(Vsim___024root* vlSelf);

void Vsim::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vsim::eval_step\n"); );
    m_evalLoop.eval();
}

void Vsim::evalBegin() {
#ifdef VL_DEBUG
    // Debug assertions
    Vsim___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
}

void Vsim::evalEnd() {
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

void Vsim::evalStatic() {
    Vsim___024root___eval_static(&(vlSymsp->TOP));
}

void Vsim::evalInitial() {
    Vsim___024root___eval_initial(&(vlSymsp->TOP));
}

bool Vsim::evalStl(bool firstIteration) {
    return Vsim___024root___eval_stl(&(vlSymsp->TOP), firstIteration);
}

void Vsim::evalSample() {
    Vsim___024root___eval_sample(&(vlSymsp->TOP));
}

bool Vsim::evalIco(bool firstIteration) {
    return Vsim___024root___eval_ico(&(vlSymsp->TOP), firstIteration);
}

bool Vsim::evalAct() {
    return Vsim___024root___eval_act(&(vlSymsp->TOP));
}

bool Vsim::evalInact() {
    return Vsim___024root___eval_inact(&(vlSymsp->TOP));
}

bool Vsim::evalNba() {
    return Vsim___024root___eval_nba(&(vlSymsp->TOP));
}

bool Vsim::evalObs() {
    return Vsim___024root___eval_obs(&(vlSymsp->TOP));
}

bool Vsim::evalReact() {
    return Vsim___024root___eval_react(&(vlSymsp->TOP));
}

void Vsim::evalPostponed() {
    Vsim___024root___eval_postponed(&(vlSymsp->TOP));
}

void Vsim::evalFinal() {
    Vsim___024root___eval_final(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vsim::dumpTriggersStl() {
    Vsim___024root___eval_dump_triggers__stl(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vsim::dumpTriggersIco() {
    Vsim___024root___eval_dump_triggers__ico(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vsim::dumpTriggersAct() {
    Vsim___024root___eval_dump_triggers__act(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vsim::dumpTriggersNba() {
    Vsim___024root___eval_dump_triggers__nba(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vsim::dumpTriggersObs() {
    Vsim___024root___eval_dump_triggers__obs(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vsim::dumpTriggersReact() {
    Vsim___024root___eval_dump_triggers__react(&(vlSymsp->TOP));
}

//============================================================
// Events and timing
bool Vsim::eventsPending() { return false; }

uint64_t Vsim::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vsim::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

VL_ATTR_COLD void Vsim::final() {
    contextp()->executingFinal(true);
    evalFinal();
    contextp()->executingFinal(false);
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vsim::hierName() const { return vlSymsp->name(); }
const char* Vsim::modelName() const { return "Vsim"; }
unsigned Vsim::threads() const { return 1; }
void Vsim::prepareClone() const { contextp()->prepareClone(); }
void Vsim::atClone() const {
    contextp()->threadPoolpOnClone();
}
