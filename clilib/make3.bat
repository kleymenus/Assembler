@echo off
echo Compiling...
..\TASM EXAMPLE3

cd CLILIB
..\..\TASM CLIPROC
cd ..

echo Linking...
..\TLINK EXAMPLE3 CLILIB\CLIPROC NUMLIB\NUMPROC
echo Running
EXAMPLE3
