#!/bin/bash
# NetRun sandbox server startup script

cd /home/netrun
log="/home/netrun/sandserv.log"

# Create kill script if it doesn't exist
if [ ! -f "kill_gdb.sh" ]; then
    cat > kill_gdb.sh << 'EOF'
#!/bin/bash
# Kill GDB and other debugging processes
pkill -f gdb
pkill -f ".exe"
exit 0
EOF
    chmod +x kill_gdb.sh
fi

echo "NetRun sandserv starting: $(date) in $(pwd)" >> $log

# Start sandserv directly as netrun user
while true; do
    echo "sandserv starting: $(date)" >> $log
    ./sandserv >> $log 2>&1
    echo "SECURITY: sandserv exited - restarting" >> $log
    sleep 5
    # Clean up any stray processes
    ./kill_gdb.sh 2>/dev/null || true
done