#!/bin/bash

# ───────────────────────────────────────
# Input
# ───────────────────────────────────────

# break down the range into network and prefix
range="$1"
network="${range%/*}" # '%': before | '/' char | '*' everything
prefix="${range#*/}" # '#': after | '*' everything | '/' char

# ───────────────────────────────────────
# Validation
# ───────────────────────────────────────

validate_prefix() {
    if [[ ! "$prefix" =~ ^[0-9]+$ ]] || (( prefix > 32 )); then
        echo "Invalid CIDR prefix: $prefix"
        exit 1
    fi
}

host_bits=$((32 - prefix))
count=$((2 ** host_bits))

validate_ip() {
    IFS=. read -ra octets <<< "$network" # split the ip address into octets and store them in an array

    if [[ "${#octets[@]}" -ne 4 ]]; then # check if the ip address has 4 octets
        echo "Invalid IP address: $network"
        exit 1
    fi
    for octet in "${octets[@]}"; do # loop through each octet and check if it's a valid number between 0 and 255
        if [[ ! "$octet" =~ ^[0-9]+$ ]] || (( octet < 0 || octet > 255 )); then
            echo "Invalid IP address: $network"
            exit 1
        fi
    done
}

# ───────────────────────────────────────
# IP conversion
# ───────────────────────────────────────

# convert the ip address to integers for easier manipulation
ip_to_int() {
    read -ra octets <<< "$network" 
    validate_ip 
    echo $((octets[0] * 256 ** 3 + octets[1] * 256 ** 2 + octets[2] * 256 + octets[3]))
}

# convert integers back to ip address
int_to_ip() {
    local ip=$1

    # Convert the 32-bit integer into four 8-bit IPv4 octets by shifting each octet
    # to the rightmost position and masking it with 255, then join them with dots.
    echo "$((ip >> 24 & 255)).$((ip >> 16 & 255)).$((ip >> 8 & 255)).$((ip & 255))"
}

# ───────────────────────────────────────
# Range generation
# ───────────────────────────────────────

# generate the list of IP addresses in the range
get_ip_range() {
    for ((i = 1; i < count - 1; i++)); do
        current_ip=$((start + i))
        echo "$(int_to_ip "$current_ip")"
    done
}

# get_ip_range

# ───────────────────────────────────────
# Scanning
# ───────────────────────────────────────

scan() {
    ip_range=$(get_ip_range)
    for ip in $ip_range; do
        if ping -c 1 -W 1 "$ip" > /dev/null 2>&1; then # ping the ip address once with a timeout of 1 second and suppress output
            echo "$ip is reachable"
        else
            echo "$ip is not reachable"
        fi
    done
}

# ───────────────────────────────────────
# Main
# ───────────────────────────────────────

validate_prefix
start=$(ip_to_int "$network")
scan