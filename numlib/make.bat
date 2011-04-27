@echo off
echo Compiling...
..\TASM EXAMPLE

cd NUMLIB
..\..\TASM NUMPROC
cd ..

echo Linking...
..\TLINK EXAMPLE NUMLIB\NUMPROC
echo Running
EXAMPLE
