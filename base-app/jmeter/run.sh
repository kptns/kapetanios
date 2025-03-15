#!/bin/bash

# Set timezone to Mexico City
export TZ="America/Mexico_City"

# Function to get random number between two values
get_random_number() {
    local min=$1
    local max=$2
    echo $((RANDOM % (max - min + 1) + min))
}

# Function to get next interval hour based on current hour
get_next_interval() {
    local hour=$1
    
    if [ $hour -lt 7 ]; then
        echo "7"  # Next interval is 7 AM
    elif [ $hour -lt 10 ]; then
        echo "10" # Next interval is 10 AM
    elif [ $hour -lt 13 ]; then
        echo "13" # Next interval is 1 PM
    elif [ $hour -lt 15 ]; then
        echo "15" # Next interval is 3 PM
    elif [ $hour -lt 18 ]; then
        echo "18" # Next interval is 6 PM
    elif [ $hour -lt 21 ]; then
        echo "21" # Next interval is 9 PM
    else
        echo "31" # Next interval is 7 AM next day (24 + 7)
    fi
}

# Function to calculate seconds until next interval
calculate_on_hold_time() {
    local current_hour=$(date +%H)
    local current_min=$(date +%M)
    local current_sec=$(date +%S)
    
    local next_hour=$(get_next_interval $current_hour)
    local seconds_now=$((current_hour * 3600 + current_min * 60 + current_sec))
    local seconds_next
    
    if [ $next_hour -eq 31 ]; then
        # If next interval is tomorrow 7 AM
        seconds_next=$((31 * 3600)) # 7 AM next day
    else
        seconds_next=$((next_hour * 3600))
    fi
    
    local diff=$((seconds_next - seconds_now))
    if [ $diff -lt 0 ]; then
        diff=$((diff + 86400)) # Add 24 hours in seconds if negative
    fi
    
    echo $diff
}

# Function to get threads based on time and day type
get_threads() {
    local hour=$1
    local is_weekend=$2

    if $is_weekend; then
        # Weekend logic
        if [ $hour -ge 7 ] && [ $hour -lt 10 ]; then
            # 7 AM - 10 AM: 3 threads
            echo "3"
        elif [ $hour -ge 10 ] && [ $hour -lt 13 ]; then
            # 10 AM - 1 PM: 4 threads
            echo "4"
        elif [ $hour -ge 13 ] && [ $hour -lt 15 ]; then
            # 1 PM - 3 PM: 3 threads
            echo "3"
        elif [ $hour -ge 15 ] && [ $hour -lt 18 ]; then
            # 3 PM - 6 PM: 2 threads
            echo "2"
        elif [ $hour -ge 18 ] && [ $hour -lt 21 ]; then
            # 6 PM - 9 PM: 1 thread
            echo "1"
        else
            # 9 PM - 7 AM: 1 thread
            echo "1"
        fi
    else
        # Weekday logic
        if [ $hour -ge 7 ] && [ $hour -lt 10 ]; then
            # 7 AM - 10 AM: random between 6 and 7
            get_random_number 6 7
        elif [ $hour -ge 10 ] && [ $hour -lt 13 ]; then
            # 10 AM - 1 PM: 12 threads
            echo "12"
        elif [ $hour -ge 13 ] && [ $hour -lt 15 ]; then
            # 1 PM - 3 PM: 7 threads
            echo "7"
        elif [ $hour -ge 15 ] && [ $hour -lt 18 ]; then
            # 3 PM - 6 PM: 5 threads
            echo "5"
        elif [ $hour -ge 18 ] && [ $hour -lt 21 ]; then
            # 6 PM - 9 PM: 3 threads
            echo "3"
        else
            # 9 PM - 7 AM: 1 thread
            echo "1"
        fi
    fi
}

while true; do
    # Get current hour (24-hour format)
    current_hour=$(date +%H)
    
    # Check if it's weekend (6 = Saturday, 0 = Sunday)
    current_day=$(date +%u)
    is_weekend=false
    if [ $current_day -eq 6 ] || [ $current_day -eq 7 ]; then
        is_weekend=true
    fi

    # Get threads based on time and day type
    threads=$(get_threads $current_hour $is_weekend)
    
    # Calculate time until next interval
    on_hold_t=$(calculate_on_hold_time)

    echo "----------------------------------------"
    echo "Current time: $(date)"
    echo "Day type: $(if $is_weekend; then echo "Weekend"; else echo "Weekday"; fi)"
    echo "Running JMeter with $threads threads"
    echo "Seconds until next interval: $on_hold_t"

    # Execute JMeter with the calculated number of threads and on-hold time
    jmeter -n -t test_plan.jmx -l "results_$(date +%Y%m%d_%H%M%S).jtl" -Jthreads=$threads -Jon_hold_t=$on_hold_t

    echo "Test cycle completed. Waiting 1 minute before next execution..."
    echo "----------------------------------------"
done
