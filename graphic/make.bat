@echo off
echo Compiling...
..\TASM %1

cd GRAPH
..\..\TASM GRAPHP
cd ..

echo Linking...
..\TLINK %1 NUMLIB\NUMPROC GRAPH\GRAPHP
echo Running
.\%1
