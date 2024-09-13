#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to run tests
run_test() {
    echo -e "\n[*] Running build"
    esy
    if [ $? -eq 0 ]; then
        echo -e "\n[*] Build successful, running tests"
        esy dune exec src/tst.exe
    fi
}

# Function to set up the environment
setup() {
    echo -e "\n[*] Installing dependencies"
    npm install -g esy@latest
    esy install
}

# Function to execute the main program
run_exec() {
    echo -e "\n[*] Running build"
    esy
    if [ $? -eq 0 ]; then
        echo -e "\n[*] Build successful, Executing main program"
        esy dune exec src/main.exe
    fi

}

# Function to enable watch option while building dune
watch_build() {
    echo -e "\n[*] Building with watcher"
    esy dune build -w
}

# Main script logic
case "$1" in
    test)
        run_test
        ;;
    setup)
        setup
        ;;
    exec)
        run_exec
        ;;
    watch)
        watch_build
        ;;
    *)
        echo "Invalid argument. Use 'test', 'setup', 'exec', 'watch'."
        exit 1
        ;;
esac

# End of script
