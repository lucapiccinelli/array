@echo off
set BIN=bin

if not exist %BIN% mkdir %BIN%

for %%f in (*.cbl) do ccbl32.exe -Sp copy -o bin\%%~nf.acu %%f