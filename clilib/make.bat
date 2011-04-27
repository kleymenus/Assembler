@echo off
echo Compiling...
..\TASM EXAMPLE

cd CLILIB
..\..\TASM CLIPROC
cd ..

echo Linking...
..\TLINK EXAMPLE CLILIB\CLIPROC NUMLIB\NUMPROC
echo Running
EXAMPLE
