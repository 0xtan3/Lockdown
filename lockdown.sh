# lockdown.sh

echo "

    __    ____  ________ __ ____  ____ _       ___   __
   / /   / __ \/ ____/ //_// __ \/ __ \ |     / / | / /
  / /   / / / / /   / ,<  / / / / / / / | /| / /  |/ / 
 / /___/ /_/ / /___/ /| |/ /_/ / /_/ /| |/ |/ / /|  /  
/_____/\____/\____/_/ |_/_____/\____/ |__/|__/_/ |_/   
                                                       

"

# echo "Installing packages..."
# chmod 700 ./scripts/*

# ./scripts/install.sh

echo "Generating strong password..."
python3 ./scripts/key_gen.py