# CoCo 6809 Assembly Snippets

This repository collects short, working assembly language examples for the TRS-80 Color Computer (CoCo), written for the Motorola 6809 CPU.

Each program is a minimal demonstration of a specific task: clearing the screen, printing text, waiting for input, or performing disk operations. All examples are designed for use with Color BASIC / Extended BASIC / Disk BASIC ROM entry points and assume a working assembler such as **lwasm**.

## Contents

- **hello-world/**  
  Clears the screen, prints "HELLO WORLD!", and waits for a key.

- **disk-file-create/**  
  Creates a file named `DATA.DAT` on a Disk BASIC drive.

- **utils/**  
  Small reusable routines (print string with bit 6 set, ROM key input, etc.).

## Notes
These examples are intended for hobbyists already familiar with assembling and loading machine language programs on the CoCo. If you’re here, you probably know how to use them.

Contributions welcome — feel free to add your own snippets.

Credits

Author: William Mikrut
Thanks to the CoCo community at https://colorcomputerarchive.com and the classic “Unravelled” series for documentation context.