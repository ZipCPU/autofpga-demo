#!/bin/bash

./sim/main_tb &
sleep 1
./sw/testtb
