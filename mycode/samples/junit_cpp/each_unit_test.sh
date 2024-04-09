#!/bin/bash
make -f unix.mak clean
make -f unix.mak each_unit_test
