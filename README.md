# Computer architecture and low-level programming

This repository contains DOS assembly programs written for educational purposes. Each program demonstrates different aspects of x86 assembly programming.

## Project Structure

- `arithmetic_operations/` - Contains programs demonstrating basic arithmetic operations
- `number_converter/` - Contains a program for number input and conversion

## Requirements

- DOS operating system or DOS emulator (e.g., DOSBox)
- MASM (Microsoft Macro Assembler)
- LINK (Microsoft Linker)

## Building Programs

1. Assemble the program:
```
masm program.asm;
```

2. Link the object file:
```
link program.obj;
```

3. Run the program in DOS:
```
program.exe
```

## Notes

- All programs are written in x86 assembly language
- Programs are designed to run in real mode (16-bit)
- Some programs use 32-bit registers with .386 directive 
