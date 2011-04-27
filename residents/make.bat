@echo off
echo Compiling...
..\TASM %1
echo Linking...
..\TLINK /t %1
echo Running
%1
