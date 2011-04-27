@echo off
echo Compiling...
TASM %1
echo Linking...
TLINK %1 IOPROC
echo Running
%1
