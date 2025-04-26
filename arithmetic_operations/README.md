# Arithmetic Operations

This directory contains programs demonstrating basic arithmetic operations in assembly language.

## Programs

### Basic Arithmetic (zad1-4e.asm)
- Calculates the formula: a*(b-c)/d
- Uses 16-bit registers
- Demonstrates basic arithmetic operations: subtraction, multiplication, and division
- Input values are hardcoded in the program

## Building

1. Assemble the program:
```
masm zad1-4e.asm;
```

2. Link the object file:
```
link zad1-4e.obj;
```

3. Run the program:
```
zad1-4e.exe
```

## Notes

- The program uses the SMALL memory model
- All variables are defined as 16-bit words (DW)
- The program demonstrates proper segment handling and stack setup 