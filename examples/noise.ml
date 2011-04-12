open Portaudio
open Bigarray

let choose_device () =
    print_endline "-1 Quit";
    let dcount = get_device_count () in
    for d = 0 to dcount - 1 do
        let dinfo = get_device_info d in
        Printf.printf "%d\t%s\n" d dinfo.d_name
    done;
    read_int ()

let choose_format () =
    let formats = [|"format_int8"; "format_int16"; "format_int24"; "format_int32"; "format_float32"|] in
    for i = 0 to (Array.length formats) - 1 do
        let s = formats.(i) in
        Printf.printf "%d\t%s\n" i s
    done;
    read_int ()

let rec choose_interleaved () =
    print_endline "0 Non-interleaved";
    print_endline "1 Interleaved";
    match read_int () with
    | 0 -> false
    | 1 -> true
    | _ -> choose_interleaved ()


let choose_callback () =
    print_endline "0 blocking write";
    print_endline "1 callback";
    read_int ()

let test_array stream init randf randv = 
    print_endline "Testing arrays...";
    let buf = Array.create 256 init in
    let bbuf = [|buf; buf|] in
    for j = 0 to 100 do
        for i = 0 to 255 do
            let rand = randf randv in
            buf.(i) <- rand;
        done;
        Portaudio.write_stream stream bbuf 0 256
    done

let fill_ba ba inter randf randv =
    for i = 0 to 255 do
        let rand = randf randv in
        let left, right = match inter with true -> ([|2*i|], [|2*i + 1|])
        | false -> ([|0;i|], [|1;i|]) in
        Genarray.set ba left rand;
        Genarray.set ba right rand
    done

let test_bigarray stream inter batype randf randv = 
    print_endline "Testing Bigarrays...";
    let dims = match inter with true -> [|2*256|]
        | false -> [|2;256|] in
    let ba = Genarray.create batype c_layout dims in
    for j = 0 to 100 do
        fill_ba ba inter randf randv;
        Portaudio.write_stream_ba stream ba 0 256
    done

let start d fmt = 
    let inter = choose_interleaved () in
    match fmt with
    | 0 ->
        let outparam = Some { channels=2; device=d; sample_format=format_int8; latency=1. } in
        let stream = open_stream ~interleaved:inter None outparam 11025. 256 [] in
        start_stream stream;
        test_array stream 0 Random.int 256;
        test_bigarray stream inter int8_signed Random.int 256;
        close_stream stream
    | 1 ->
        let outparam = Some { channels=2; device=d; sample_format=format_int16; latency=1. } in
        let stream = open_stream ~interleaved:inter None outparam 11025. 256 [] in
        start_stream stream;
        test_array stream 0 Random.int 65536;
        test_bigarray stream inter int16_signed Random.int 65536;
        close_stream stream
    | 2 ->
        let outparam = Some { channels=2; device=d; sample_format=format_int24; latency=1. } in
        let stream = open_stream ~interleaved:inter None outparam 11025. 256 [] in
        start_stream stream;
        test_array stream Int32.zero Random.int32 (Int32.of_int (4096*4096));
        test_bigarray stream inter int32 Random.int32 (Int32.of_int (4096*4096));
        close_stream stream
    | 3 ->
        let outparam = Some { channels=2; device=d; sample_format=format_int32; latency=1. } in
        let stream = open_stream ~interleaved:inter None outparam 11025. 256 [] in
        start_stream stream;
        test_array stream Int32.zero Random.int32 Int32.max_int;
        test_bigarray stream inter int32 Random.int32 Int32.max_int;
        close_stream stream
    | 4 ->
        let outparam = Some { channels=2; device=d; sample_format=format_float32; latency=1. } in
        let stream = open_stream ~interleaved:inter None outparam 11025. 256 [] in
        start_stream stream;
        test_array stream 0. (fun () -> 1. -. (Random.float 2.)) ();
        test_bigarray stream inter float32 (fun () -> 1. -. (Random.float 2.)) ();
        close_stream stream
    | _ -> ()

let start_callback d fmt =
    let cb r x y l =
        for i = 0 to l - 1 do
            Genarray.set y [|2*i|] (r ());
            Genarray.set y [|2*i + 1|] (r ()) 
        done;
        0
    in
    match fmt with
    | 0 ->
        let outparam = Some { channels=2; device=d; sample_format=format_int8; latency=1. } in
        let r () = Random.int 256 in
        let stream = open_stream ~callback:(cb r) None outparam 11025. 0 [] in
        start_stream stream;
        sleep 5000;
        close_stream stream
    | 1 ->
        let outparam = Some { channels=2; device=d; sample_format=format_int16; latency=1. } in
        let r () = Random.int 65536 in
        let stream = open_stream ~callback:(cb r) None outparam 11025. 0 [] in
        start_stream stream;
        sleep 5000;
        close_stream stream
    | 2 ->
        let outparam = Some { channels=2; device=d; sample_format=format_int24; latency=1. } in
        let r () = Random.int32 (Int32.of_int (4096*4096)) in
        let stream = open_stream ~callback:(cb r) None outparam 11025. 0 [] in
        start_stream stream;
        sleep 5000;
        close_stream stream
    | 3 ->
        let outparam = Some { channels=2; device=d; sample_format=format_int32; latency=1. } in
        let r () = Random.int32 (Int32.max_int) in
        let stream = open_stream ~callback:(cb r) None outparam 11025. 0 [] in
        start_stream stream;
        sleep 5000;
        close_stream stream
    | 4 ->
        let outparam = Some { channels=2; device=d; sample_format=format_float32; latency=1. } in
        let r () = 1. -. (Random.float 2.) in
        let stream = open_stream ~callback:(cb r) None outparam 11025. 0 [] in
        start_stream stream;
        sleep 5000;
        close_stream stream
    | _ -> ()

let rec main () =
    let d = choose_device () in
    if d = -1 then exit 0;
    let fmt = choose_format () in
    (match choose_callback () with
    | 0 -> start d fmt
    | 1 -> start_callback d fmt
    | _ -> ());
    main ()

let () =
    Printf.printf "Using %s.\n%!" (get_version_string ());
    Random.self_init ();
    Portaudio.init ();
    main ()
