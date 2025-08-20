#!/bin/bash
# Kill GDB and other debugging processes
pkill -f gdb
pkill -f ".exe"
exit 0