open Portaudio

let buflen = 1024

let bufc = Array.make buflen 0.

let buf = [|bufc; bufc|]

let () =
  Portaudio.init ();
  Printf.printf "Using %s.\n%!" (get_version_string ());
  let stream = open_default_stream 0 2 44100 256 in
    start_stream stream;
    while true do
      for i = 0 to Array.length bufc - 1 do
        bufc.(i) <- (Random.float 2.) -. 1.
      done;
      write_stream stream buf 0 buflen
    done
