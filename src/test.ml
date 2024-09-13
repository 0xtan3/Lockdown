
let test_generate_key () =
    Alcotest.(check string) "key" "2" (Lib.generate_key 15)

let () =
let open Alcotest in
run "Utils" [
    "unit-test-case", [
        test_case "key_generation"     `Quick test_generate_key;
      ];
    (* "string-concat", [ test_case "String mashing" `Quick test_str_concat  ];
    "list-concat",   [ test_case "List mashing"   `Slow  test_list_concat ]; *)
  ]
