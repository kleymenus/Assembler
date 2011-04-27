@echo off
echo Compiling...
..\TASM %1
echo Linking...
..\TLINK %1 NUMLIB\NUMPROC
echo Running
%1
