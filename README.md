# (Acu) COBOL dynamic Arrays library

## Introduction

The purpose of this project is to **provide a usable COBOL implementation of dynamic arrays**.

Unfortunately it is written in **Acu dialect**. Syncerely I completely ignore if it can compile in any other COBOL dialect or not.

However even if not, you can always fork this repo and provide your own.

## Why?

I worked exlusively in Acu COBOL for 4 years consecutively. Unfortunately I discovered that Acu didn't provide any dynamic array implementation.

Actually, as far as i know, no COBOL implementation provide dynamic arrays out of the box.

**So here it is my COBOL implementation of dynamic arrays**.

## Getting Started

### Basic usage example

```cobol
identification division.
    program-id.  usage-example.
environment division.
working-storage section.
copy "array.cpy" replacing ==!PREFIX!== by ==w-==.
linkage section.

77  w-element pic x(25) value spaces.

procedure division.
    | each array element is going to be 25 bytes in size
    call "array:new" using w-array length of w-element.

    | add 3 elements to the array
    call "array:append" using w-array "new element".
    call "array:append" using w-array "new element 2".
    call "array:append" using w-array "banana".

    | get the first
    call "array:get" using w-array w-element 0. | this gets "new element" into w-element

    | free dynamic memory
    call "array:free" using w-array.

    goback.
```

## How to Compile

A **compile.bat** script is provided for convenience. On Windows open a command prompt and run

```bash
compile.bat
```

In order to run it succesfully, it is supposed that you have set the ccbl32 compiler in your Windows **PATH** environment variable.

This is going to compile in a directory named **bin**, in same path of the repo.

If you want to compile only the **array** library, then run

```bash
ccbl32.exe -Sp copy array.cbl
```

## Test

If you want to test if it is working properly, then you can open a prompt and run

```bash
crun32.exe -b test-array.acu
```

If the output ends with

```bash
Test is OK
```

then it is working properly.
