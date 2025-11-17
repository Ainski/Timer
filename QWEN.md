# Timer Hardware Module Project

## Overview
This project contains a hardware timer module implemented in Verilog for use with ModelSim. The timer supports both forward counting (stopwatch) and reverse counting (countdown) modes with programmable time values and alarm functionality.

## File Structure
- `timer.v` - Verilog implementation of the timer module (currently empty except for timescale)
- `timer.md` - Main design document with signal specifications and waveform diagrams
- `timer_design.md` - Detailed design document with internal signals and complete waveform analysis
- `timer_waveforms.md` - Waveform diagrams for different operating modes
- `.git` - Git version control directory

## Module Interface

### Input Signals:
- `clk` - Clock signal
- `write` - Write enable signal for loading time values
- `up` - Up/Down counter control (1=count up, 0=count down)
- `cut` - Counter control signal (low as reset or cutin)
- `insec` - Input seconds value
- `inmin` - Input minutes value  
- `inhour` - Input hours value
- `start` - Start/stop control signal

### Output Signals:
- `sec` - Current seconds value (0-59)
- `min` - Current minutes value (0-59)
- `hour` - Current hours value (0-23)
- `alarm` - Alarm output signal
- `buzy_n` / `counting#` - Busy/working status indicator

## Operating Modes

### 1. Simple Forward Counting (Stopwatch)
- Counts up from 00:00:00 to 23:59:59
- Seconds increment on each clock cycle when enabled
- Rolls over from 59 seconds to next minute
- Rolls over from 59 minutes to next hour
- Rolls over from 23 hours back to 00

### 2. Forward Timing with Preset
- Loads initial time value and counts up
- Can be started, stopped, and resumed
- Alarm triggers when reaching preset value

### 3. Countdown Mode
- Counts down from preset time value
- Alarm triggers when reaching 00:00:00
- Can be paused and resumed

### 4. Interrupt/Reset Mode
- Supports resetting the counter to initial values
- Supports pausing and resuming operation

## Design Details

The timer module includes internal registers for:
- `sec_r` - Seconds counter
- `min_r` - Minutes counter  
- `hour_r` - Hours counter
- `buzy_n_r` - Busy status register

The design handles:
- Time value presetting via input signals
- Overflow detection for seconds, minutes, and hours
- Up/down counting direction control
- Start/stop functionality
- Alarm generation at time expiration

## Waveform Analysis
All design documents include WaveDrom waveform diagrams to visualize timing behavior for each operating mode. These diagrams show the relationship between input controls and resulting time values during different operations.

## Hardware Implementation
The project uses Verilog with a 1ps/1ns time scale (as defined in timer.v). The actual implementation logic is not yet in the Verilog file, but the comprehensive documentation describes the expected functionality in detail.

## Development Status
- Design documentation is complete with detailed waveform analysis
- Verilog implementation is empty but the specification is well-documented
- Ready for implementation based on the provided specifications