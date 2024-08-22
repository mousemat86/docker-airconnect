#!/bin/bash

# Default command for aircast
AIRCAST_CMD="/opt/airconnect/aircast-docker"

# Default command for airupnp with appended "-l 1000:2000"
AIRUPNP_CMD="/opt/airconnect/airupnp-docker"
AIRUPNP_CMD_VAR="-l 1000:2000"

# Check if the environment variable AIRCAST_VAR is set
echo "===== Configuring aircast using $ARCH_VAR binary ====="
if [ -n "$AIRCAST_VAR" ]; then
    if [ "$AIRCAST_VAR" = "kill" ]; then
        echo "===== AIRCAST_VAR set to kill, skipping aircast service launch ====="
        AIRCAST_CMD=""
    else
        echo "===== AIRCAST_VAR present, using custom user aircast launch variables ====="
        AIRCAST_CMD="$AIRCAST_CMD $AIRCAST_VAR"
    fi
else
    echo "===== No AIRCAST_VAR present, continuing with standard aircast launch variables ====="
fi

# Check if the environment variable AIRUPNP_VAR is set
echo "===== Configuring airupnp using $ARCH_VAR binary ====="
if [ -n "$AIRUPNP_VAR" ]; then
    if [ "$AIRUPNP_VAR" = "kill" ]; then
        echo "===== AIRUPNP_VAR set to kill, skipping aircast service launch ====="
        AIRUPNP_CMD=""
    else
        echo "===== AIRUPNP_VAR present, using custom user aircast launch variables ====="
        AIRUPNP_CMD="$AIRUPNP_VAR"
    fi
else
    echo "===== No AIRUPNP_VAR present, continuing with standard aircast launch variables ====="
    $AIRUPNP_CMD="$AIRUPNP_CMD $AIRUPNP_CMD_VAR"
fi

# Run the services if not "killed"
if [ -n "$AIRCAST_CMD" ]; then
    $AIRCAST_CMD &
fi

if [ -n "$AIRUPNP_CMD" ]; then
    $AIRUPNP_CMD &
fi

# Wait for background processes to finish
wait -n
