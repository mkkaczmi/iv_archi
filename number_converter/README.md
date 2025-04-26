# Number Converter

This directory contains a program that demonstrates number input and conversion in assembly language.

## Program Description

### Number Input and Addition (z2_Grala_Kaczmarek.asm)
- Accepts two numbers from the user in the range [-32768, 32767]
- Performs input validation
- Converts ASCII input to binary numbers
- Adds the numbers and displays the result
- Supports both positive and negative numbers

## Features
- Input validation
- Error handling for invalid input
- Support for negative numbers
- 32-bit arithmetic operations
- User-friendly interface with prompts and error messages

## Building

1. Assemble the program:
```
masm z2_Grala_Kaczmarek.asm;
```

2. Link the object file:
```
link z2_Grala_Kaczmarek.obj;
```

3. Run the program:
```
z2_Grala_Kaczmarek.exe
```

## Notes
- Uses .386 directive for 32-bit register support
- Implements TINY memory model
- Demonstrates string input/output using DOS interrupts
- Shows proper error handling and input validation 