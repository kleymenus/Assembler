@echo off
echo Compiling...
..\TASM EXAMPLE2

cd CLILIB
..\..\TASM CLIPROC
cd ..

echo Linking...
..\TLINK EXAMPLE2 CLILIB\CLIPROC NUMLIB\NUMPROC
echo Running
EXAMPLE2
