open Digestif.SHA256
open Eio.Std

let get_cpu_times () =
  let { Unix.tms_utime; tms_stime; _ } = Unix.times () in
  tms_stime +. tms_utime

let heavy_computation () =
  let rec compute hash =
    let hash = digest_string (to_raw_string hash) in
    (* DEBUG *)
    (* traceln "%s" (to_hex hash); *)
    Fiber.yield ();
    compute hash
  in
  let hash = digest_string "some initial data" in
  compute hash

let random_string n =
  let chars = "abcdefghijklmnopqrstuvwxyz0123456789" in
  let chars_len = String.length chars in
  String.init n (fun _ ->
      let index = Random.int chars_len in
      chars.[index])
