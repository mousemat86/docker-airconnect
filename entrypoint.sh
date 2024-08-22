#!/bin/bash

# Default command for aircast
AIRCAST_CMD="./aircast-x86-64"

# Default command for airupnp with appended "-l 1000:2000"
AIRUPNP_CMD="./airupnp-x86-64"
AIRUPNP_CMD_VAR="-l 1000:2000"

# Check if the environment variable AIRCAST_VAR is set
if [ -n "$AIRCAST_VAR" ]; then
    if [ "$AIRCAST_VAR" = "kill" ]; then
        AIRCAST_CMD=""
    else
        AIRCAST_CMD="$AIRCAST_CMD $AIRCAST_VAR"
    fi
fi

# Check if the environment variable AIRUPNP_VAR is set
if [ -n "$AIRUPNP_VAR" ]; then
    if [ "$AIRUPNP_VAR" = "kill" ]; then
        AIRUPNP_CMD=""
    else
        AIRUPNP_CMD="$AIRUPNP_VAR"
    fi
else
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
