# Ultimate Battleship

## Overview
**Ultimate Battleship** is an FPGA-based implementation of the classic Battleship game, developed as a term project for the **CS 303: Logic & Digital System Design** course (Fall 2024). The project is designed to be played by two players on an FPGA board using LEDs, seven-segment displays (SSDs), and input switches. The game involves ship placement, turn-based attacks, and real-time score tracking.

## Features
- **Two-Player Mode**: Players take turns to place ships and attack each other's fleet.
- **4x4 Grid for Each Player**: The battlefield is a 4x4 grid, and each player places four ships.
- **FPGA-Based Display**:
  - SSDs show player turns, input coordinates, and scores.
  - LEDs indicate turn status, hits, misses, and the winner.
- **Button & Switch Controls**:
  - **BTN3** (Player A) & **BTN0** (Player B) for gameplay actions.
  - **BTN2** (Reset) & **BTN1** (Start) for game control.
  - **Switches 3-2** for X-coordinates, **Switches 1-0** for Y-coordinates.
- **Game Logic**:
  - Players enter ship positions without overlap.
  - Players take turns attacking by selecting coordinates.
  - When a ship is hit, the score updates in real-time.
  - The game ends when a player sinks all four opponent ships, displaying the winner and triggering an LED celebration.

## Implementation Details
This project was implemented in **Verilog** and tested using a **testbench** before being deployed on the FPGA. The design follows an **Algorithmic State Machine (ASM) Chart**, ensuring smooth state transitions and accurate gameplay.

### Modules Used
- **battleship.v**: Core game logic, including ship placement, attack validation, and score management.
- **top.v**: Top module that combines all the other modules.
- **clk_divider.v**: Generates a 50 Hz clock from a 100 MHz input.
- **debouncer.v**: Handles push-button debouncing.
- **ssd.v**: Controls the seven-segment display.

**Only battleship and top modules are written by me, we were given the other ones ready to use.**

## Author
Fatih Sarıoğlu

---
**Note:** This project was developed as an academic term project and adheres to university guidelines.