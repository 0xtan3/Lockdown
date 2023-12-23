# key_gen.py

# This is where the key files are generated and given to the crypt.sh file 
# Rotating keys may be fine but lets see there is something like a option to change the password
import string
import random
# import hashlib

def generate_keys():

    length = 25
    charList = ""

    charList+=string.ascii_letters
    charList+=string.digits
    charList+=string.punctuation

    password = []

    for i in range(length):
        randomchar = random.choice(charList)
        password.append(randomchar)
    key = "".join(password)    

    #generate a cipher key
    # cipher_key = hashlib.md5(joined_passwd.encode("utf-8")).hexdigest()
    return key

if __name__=="__main__":

    #execute the function call
    generate_keys()