# MAPD - FPGA Laboratory

## General Information

### Useful links

- [GDrive](https://drive.google.com/drive/u/0/folders/1EuG9C9qOo1bofLXjlRznqDQ_bxCg3eso)
- [Filter code](https://surf-vhdl.com/how-to-implement-fir-filter-in-vhdl/)
- [Fir](http://vhdlguru.blogspot.com/2011/06/vhdl-code-for-4-tap-fir-filter.html)
- [Github Vincenzo](https://github.com/Schimmenti)

### Starting "Vivado"

To start the program **Vivado** on the pc in the Lab, digit from the terminal:

```bash
. /opt/Xilinx/setup
vivado
```

**FPGA Serial Number**: xc7a35tcsg324-1

### Lessons

| #   | Project    | Notes                                                                      |
| --- | ---------- | -------------------------------------------------------------------------- |
| 1   | hello_word | Source file, Synthesis, Implementation (constraints), Programming the FPGA |
| 2   | multiplex  | Testbench, Simulation                                                      |
| 3   | counter    | Memory configuration                                                       |
| 4   | debugg     | Debug tools (VIO, ILA)                                                     |
| 5   | filter     | Arithmetic operations                                                      |
| 6   | fsm        | Finite State Machine                                                       |
| 7   | fsm        | FSM with VIO and ILA                                                       |
| 8   | spi        | SPI protocol |
|     |            |                                                                            |

### VHDL naming convention

| Signal/Component       | Name              |
| ---------------------- | ----------------- |
| Clock                  | clk               |
| Reset                  | rst               |
| Input Port             | port_in           |
| Output Port            | port_out          |
| VHDL file name         | entityname.vhd    |
| Test bench file name   | tb_entityname.vhd |
| Constraint file        | mapping.xdc       |
| Signal between 2 comps | sign_cmp1_cmp2    |
| Process name           | p_name            |
| ila signal             | ila_signal        |
| vio signal             | vio_signal        |
| state name             | s_name            |
|                        |                   |

## VHDL Notes

### Entity

Defines I/O terminals and the name of the circuit.

```vhdl
entity FULL_ADDER is
  port(
    A, B, C_in : in bit;
    C_out, S   : out in bit
  );
end FULL_ADDER
```

### Architecture

Defines the box functionalities; includes:

- **Declaration** (before `begin`) of internal signals and variables
- **Assertion** (`begin` to `end`)> describe circuit behaviour

```vhdl
archtecture BHV of FULL_ADDER is
  signal P, G: bit;
begin
  P     <= A xor B;
  G     <= A and B;
  S     <= P and C_in;
  C_out <= (P and C_in) or G;
end BPV
```

### Signal, Process, Event

- A **process** is a block of code that describe operation of a logic module
- Different processes communicate with each other through **signals**
- An **event** is achange in value of one of the signals; a process sensitive to it is activated and executes its function in response to an event

#### Signal

Signals are data structures able to represent (digital) waveforms in time.
They can be declared:

- in the `architecture`
- in the clause `port` of the `entity`

### Assignment operator

```vhdl
target <= value
```

The `target` must be a signal.

- the assignment establishes a link between its inputs (the signals contained in the driver) and its output (the target) so it is activated only when there is an event (ie a change in value) of one of the inputs
- the order with which assignments are written inside of the architecture does not matter

### Concurrent instructions

- used within the architecture to describe the signal behavior
- activated (or executed) only after an event on one of the signals to which they are sensitive
- the order of execution does not depend from the order with which they appear in the model: **_parallel_ signal processing**
