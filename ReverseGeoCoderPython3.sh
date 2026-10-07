#!/bin/bash

# Runs the Melissa Reverse GeoCoder Cloud API Python 3 sample.
#
# This script runs ReverseGeoCoderPython3.py with python3, passing along the license
# and (if supplied) the lookup fields.
#
# Overall flow:
#   1. Parse the command-line options below.
#   2. Resolve the license (--license, then a prompt, then the MD_LICENSE environment variable).
#   3. Run ReverseGeoCoderPython3.py: with the lookup fields if any was supplied,
#      otherwise with only the license (the Python program prompts for each field).
#
# Options (each takes a value):
#   --lat       Latitude to test.
#   --long      Longitude to test.
#   --max       Maximum number of records to return (up to 100).
#   --license   License string. If omitted, the script prompts for it; if the prompt
#               is left blank, it falls back to MD_LICENSE. Running without --license
#               always prompts, even when MD_LICENSE is set.
#
# ReverseGeoCoderPython3.py is found relative to the current directory, so run the script from its own folder.
#
# Examples:
#   ./ReverseGeoCoderPython3.sh --license "your-license"
#   ./ReverseGeoCoderPython3.sh --lat "33.637520" --long "-117.606920" --max "3" --license "your-license"

######################### Constants ##########################

RED='\033[0;31m' #RED
NC='\033[0m' # No Color

######################### Parameters ##########################

lat=""
long=""
max=""
license=""

# Read each --flag and its value. A flag with no value, or whose value looks like an
# option name (e.g. --lat or -x), is an error; other values starting with "-" (such as
# negative coordinates) are accepted. Unrecognized options are ignored.
while [ $# -gt 0 ] ; do
  case $1 in
    --lat)
        if [ -z "$2" ] || [[ $2 =~ ^--?[a-zA-Z]+$ ]];
        then
            printf "${RED}Error: Missing an argument for parameter 'lat'.${NC}\n"
            exit 1
        fi
        lat="$2"
        shift
        ;;
    --long)
        if [ -z "$2" ] || [[ $2 =~ ^--?[a-zA-Z]+$ ]];
        then
            printf "${RED}Error: Missing an argument for parameter 'long'.${NC}\n"
            exit 1
        fi
        long="$2"
        shift
        ;;
    --max)
        if [ -z "$2" ] || [[ $2 =~ ^--?[a-zA-Z]+$ ]];
        then
            printf "${RED}Error: Missing an argument for parameter 'max'.${NC}\n"
            exit 1
        fi
        max="$2"
        shift
        ;;
    --license)
        if [ -z "$2" ] || [[ $2 =~ ^--?[a-zA-Z]+$ ]];
        then
            printf "${RED}Error: Missing an argument for parameter 'license'.${NC}\n"
            exit 1
        fi
        license="$2"
        shift
        ;;
  esac
  shift
done

########################## Main ############################
printf "\n=================== Melissa Reverse GeoCoder Cloud API =====================\n"

# Get license (either from parameters or user input)
if [ -z "$license" ];
then
  printf "Please enter your license string: "
  read license
fi

# Check for License from Environment Variables 
if [ -z "$license" ];
then
  license=`echo $MD_LICENSE` 
fi

if [ -z "$license" ];
then
  printf "\nLicense String is invalid!\n"
  exit 1
fi

# Run project
# No lookup fields (including --max) supplied -> run with only the license (the program
# prompts); otherwise pass all of them through. Unsupplied fields arrive as empty strings
# and the program prompts for them.
if [ -z "$lat" ] && [ -z "$long" ] && [ -z "$max" ];
then
    python3 ReverseGeoCoderPython3.py --license "$license"
else
    python3 ReverseGeoCoderPython3.py --license "$license" --lat "$lat" --long "$long" --max "$max"
fi

