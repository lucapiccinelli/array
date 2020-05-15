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

copy "array.cpy" replacing ==!PREFIX!== by ==w-==. | array data structure
77  w-element pic x(25) value spaces.

linkage section.

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

### Dereference and use it as a table
In order to improve performance an enable **search** and **search all** keywords

```cobol
identification division.
    program-id.  usage-example.
environment division.
working-storage section.

copy "array.cpy" replacing ==!PREFIX!== by ==w-==.
77  w-element pic x(25) value spaces.

linkage section.
01 d-array-tbl.
    03 d-array-element pic x(25)
    occurs 20000000 | use a number big enough but the total must be less then 2GB
    depending on w-array-lenth
    ascending key is d-array-element | this enables the usage of search all keyword
    .

procedure division.
    |each array element is going to be 25 bytes in size
    call "array:new" using w-array length of w-element.
    call "array:append" using w-array "new element".
    call "array:append" using w-array "new element 2".
    call "array:append" using w-array "banana".

    | always set the address after all the appends. Append operation can change the pointer.
    | So every time you append something you have to set address of linkage again
    set address of d-array-tbl to w-array-ptr.
    move d-array-element(1) to w-element. | use it... this is 1 based index, as a usual table

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

## Test driven approach
## Code conventions
## Sorting
## Sorting with comparators
## Assumptions
## Error handling