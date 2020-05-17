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

For a complete usage examples of all the functionalities of the library, refer to [test-array.cbl](test-array.cbl)

### Declaring and allocating

You can include as many arrays as you want, copying `copy "array.cpy" replacing ==!PREFIX!== by ==w-==.` in your working storage section.

Then you should allocate a new array with

```cobol
call "array:new" using w-array length of w-element.
```

There is a third optional parameter that is the type of the array. Default is **alphanumeric**, but you can specify to have a pure numeric array declaring

```cobol
call "array:new" using w-array length of w-element "9".
```

or if you `copy definitions.cpy`

```cobol
call "array:new" using w-array length of w-element NUMERIC.
```

You **MUST** free the array manually in order to prevent memory leak:

```cobol
call "array:free" using w-array.
```

### Complete basic usage example

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

In order to improve performance and allow the use of  **search** and **search all** keywords

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
    depending on w-array-length
    ascending key is d-array-element | this enables the usage of search all keyword
    .

procedure division.
    |each array element is going to be 25 bytes in size
    call "array:new" using w-array length of w-element.

    | add 3 elements to the array
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

### Sorting

Sorting is implemented with iterative quicksort.

It can be as simple as

```cobol
call "array:sort" using w-array.
```

but if you need to sort with only a part of you data structure, then you can do

```cobol
call "array:sort"
    using w-array
        record-position of w-your-record-part | offset
        length of w-your-record-part | length
        .
```

### Sorting with comparators

If you need more complex ordering logic you can implement your own comparator.

**A complete example of a comparator** can be found here [testcomparator.cbl](testcomparator.cbl)

Comparators receive two elements and return -1 if the first is smaller then the second, 0 if they are equal or 1 it the first is greater then the second.

Comparators linkage is declared as follows

```cobol
identification division.
    program-id.  mycomparator.

...

linkage section.
    77  l-first pic x(MAX-LINKAGE).
    77  l-second pic x(MAX-LINKAGE).
    copy "array.cpy" replacing ==!PREFIX!== by ==l-==.

procedure division using l-first l-second l-array.

...
```

then use it in this way

```cobol
call "array:sort"
    using w-array
        record-position of w-your-record
        length of w-your-record
        "mycomparator"
        .
```

## How to Compile

A **compile.bat** script is provided for convenience. On Windows open a command prompt and run

```bash
compile.bat
```

In order to run it succesfully, it is supposed that you have set the **ccbl32** compiler in your Windows **PATH** environment variable.

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

## Code conventions

The following conventions are applied in the code:

* working storage variables start with **w-**
* linkage variables start with **l-**
* linkage variables used to dereference pointers start with **d-** (dynamic)

Called programs that receives a linkage (like array itself) handles the linkage and move it in a safe corresponding working storage variable.

This is done using:

* **$CATCHPARAMS** macro declared in [macros.cpy](copy/macros.cpy) and copied in [definitions.cpy](copy/definitions.cpy)
* copy [catchx.cpy](copy/catchx.cpy)/[catch9.cpy](copy/catch9.cpy) safely moves linkage in working
* **linkage variables are declared as the maximum size** allowed for the corresponding picture type.

This approach simplifies the use of libraries, so that it is not required that variables used to call a program, match the format declared in the corresponding linkage section.

## Test driven approach

This library is developed following the test driven development approach (TDD).
Tests are in [test-array.cbl](test-array.cbl).

By the way this file represents also a complete specification of the library, as well as an extensive usage examples documentation. **If you are interested in this library I would suggest to have a look at it**.

I implemented the minimum assertion logic needed in this development

* [assert.cbl](assert.cbl)
* [assert-logic.cbl](assert-logic.cbl)

## Error handling

There is no error handling :fearful:. Yes this is quite an extreme choice, then I will try to argument.

This is the second version of this library. I wrote the first one exacly 9 years ago. There was an error handling system in that case, but no one never actually used it. In 9 years of a really intensive usage of this library... it has never been a problem. (In our code base the word "array:" has **23954 hits in 1918 files**)

I think that there is one main reasons for this: the cost/benefits ratio: doing a proper error handling in a procedural programming language, comes at the cost of explicitly check some kind of error code. You are going to write a lot of boilerplate code that, **given the relative low level of this library**, has the only effect to negatively affect the readability of your code.

However if you are concerned about the fact that a `m$alloc` could eventually go out of memory, you can always check that the value of the pointer of the array returned different than zero, after an allocation or an element insertion.
