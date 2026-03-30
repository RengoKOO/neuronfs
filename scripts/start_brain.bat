@echo off
title NeuronFS Brain API - :9090
cd /d "%~dp0runtime"
echo [NeuronFS] Starting brain server...
neuronfs.exe "%~dp0brain_v4" --api
pause
