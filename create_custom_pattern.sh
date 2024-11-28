#!/bin/bash

## 
## Requires fabric, with FABRIC_HOME set to the location of the fabric command.
##

# Function to display usage instructions
usage() {
    echo "Usage: $0 <PATTERN_NAME> <PATTERN_INSTRUCTION>"
    echo "  PATTERN_NAME: Name of the pattern to be created."
    echo "  PATTERN_INSTRUCTION: Instructions for creating the pattern."
    exit 1
}

# Check parameters
if [ -z "$1" ]
  then
    echo "No pattern name supplied"
    usage
fi

if [ -z "$2" ]
  then
    echo "No pattern instructions supplied"
    usage
fi

# Check FABRIC_HOME is set
if [ -z "$FABRIC_HOME" ]; then
    echo "FABRIC_HOME is not set. Please set it before running the script."
    exit 1
else
    echo "FABRIC_HOME is set to: $FABRIC_HOME"
fi

PATTERNNAME=$1
PATTERNDESCRIPTION=$2 

# Create new pattern directory 
if ! cd ~/.config/; then
	echo "Failed to navigate to ~/.config"
	exit 1
fi

mkdir -p ~/.config/custom-fabric-patterns/$PATTERNNAME

if ! cd custom-fabric-patterns/$PATTERNNAME; then
	echo "Failed to navigate to custom-fabric-patterns/$PATTERNNAME"
	exit 1
fi
# create the system.md for the pattern
touch system.md
current_directory=$(pwd)
systemmdfile="$current_directory/system.md"
# execute fabric command 
echo
echo "Creating pattern $PATTERNNAME, in $systemmdfile, using the following description:" 
echo "$PATTERNDESCRIPTION" 
echo 
cd $FABRIC_HOME && ./fabric -p create_pattern "$PATTERNDESCRIPTION" > $systemmdfile

# copy to the patterns directory
cp -a ~/.config/custom-fabric-patterns/* ~/.config/fabric/patterns

# Visual check
cd ~/.config/fabric/patterns || exit 1
ls -l | grep "$PATTERNNAME"
cat ./$PATTERNNAME/system.md

cd $FABRIC_HOME

# Optional - Use pattern
read -p "Run $PATTERNNAME Y/n? " choice
case $choice in 
    yes|y|Y)
		read -p "Enter the input for $PATTERNNAME " pinput
        ./fabric -s -p "$PATTERNNAME" "$pinput"
        ;;
    no|n|N)
        echo "Exiting without running $PATTERNNAME."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please enter yes or no."
        exit 1
        ;;
esac