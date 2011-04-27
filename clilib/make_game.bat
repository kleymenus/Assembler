@echo off
echo Compiling...
..\TASM PINGPONG

cd CLILIB
..\..\TASM CLIPROC
cd ..

echo Linking...
..\TLINK PINGPONG CLILIB\CLIPROC NUMLIB\NUMPROC
echo Running
PINGPONG
