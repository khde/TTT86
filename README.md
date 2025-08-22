# TicTacToe in x86

## Overview
This repository contains code for a TicTacToe game written in x86 for the NASM assembler targeting Unix/Linux machines. It directly uses syscalls and does not need any other dependencies.

## Prerequisites
To assemble and run the game, you need the following tools:
- **NASM**: The Netwide Assembler to compile the x86 assembly code.

## Installing Prerequisites
- **NASM**:
  - On Ubuntu/Debian: `sudo apt-get install nasm`

## Setup
1. Clone the repository:
   ```bash
   https://github.com/khde/TTT86.git
   cd TTT86
   ```
2. Build the game using the Makefile:
   ```bash
   make
   ```
3. Run the game using Makefile:
   ```bash
   make run
   ```
   or directly
   ```bash
   ./ttt86
   ```

## Usage
- Type a number from 1 - 9 to place the current players mark in the respectiv field
