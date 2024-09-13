(* open Printf
open Unix*)

let generate_key (length:int) =
  let alphanumeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" in
  let n = String.length alphanumeric in
  let result = Bytes.create length in
  for i = 0 to length -1 do
    let rand_index = Random.int n in
      Bytes.set result i alphanumeric.[rand_index]
  done;
  Bytes.to_string result

let check_package (name:str) =
  printf(Unix.)
