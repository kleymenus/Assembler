@echo off
echo Compiling...
..\TASM %1

cd FSLIB
..\..\TASM FSPROC
cd ..

echo Linking...
..\TLINK %1 NUMLIB\NUMPROC FSLIB\FSPROC CLILIB\CLIPROC
echo Running
.\%1
