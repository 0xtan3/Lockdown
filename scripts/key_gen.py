# key_gen.py
import string
import random
from db_operations import add_key


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

    return key

# def save_output(output, file_path):
#     with open(file_path, "w") as f:
#         f.write(output)

if __name__=="__main__":

    #execute the function call
    generate_keys()
    # save_output(output,"/opt/lockdown/key.txt")


#TODO: Save the key in a file that deletes in 24 hours