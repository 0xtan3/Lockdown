# key_gen.py
import string
import random

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
    print(key)
    return key

def save_output(output, file_path):
    with open(file_path, "w") as f:
        f.write(output)

if __name__=="__main__":

    #execute the function call
    save_output(generate_keys(),"./data/initial_password")


#TODO: Save the key in a file that deletes in 24 hours