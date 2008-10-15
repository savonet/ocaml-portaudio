(*
 * Copyright 2007 Samuel Mimram
 *
 * This file is part of ocaml-portaudio.
 *
 * ocaml-portaudio is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * ocaml-portaudio is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with ocaml-portaudio; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * As a special exception to the GNU Library General Public License, you may
 * link, statically or dynamically, a "work that uses the Library" with a publicly
 * distributed version of the Library to produce an executable file containing
 * portions of the Library, and distribute that executable file under terms of
 * your choice, without any of the additional requirements listed in clause 6
 * of the GNU Library General Public License.
 * By "a publicly distributed version of the Library", we mean either the unmodified
 * Library as distributed by INRIA, or a modified version of the Library that is
 * distributed under the conditions defined in clause 3 of the GNU Library General
 * Public License. This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU Library General Public License.
 *
 *)

exception Error of int
exception Unanticipated_host_error

let () =
  Callback.register_exception "portaudio_exn_error" (Error 0);
  Callback.register_exception "portaudio_exn_unanticipated_host_error" Unanticipated_host_error

external get_version : unit -> int = "ocaml_pa_get_version"

external get_version_string : unit -> string = "ocaml_pa_get_version_text"

external string_of_error : int -> string = "ocaml_pa_get_error_text"

external get_last_host_error : unit -> int * string = "ocaml_pa_get_last_host_error_info"

external init : unit -> unit = "ocaml_pa_initialize"

external terminate : unit -> unit = "ocaml_pa_terminate"

external get_host_api_count : unit -> int = "ocaml_pa_get_host_api_count"

external get_default_host_api : unit -> int = "ocaml_pa_get_default_host_api"

external get_default_input_device : unit -> int = "ocaml_pa_get_default_input_device"

external get_default_output_device : unit -> int = "ocaml_pa_get_default_output_device"

external get_device_count : unit -> int = "ocaml_pa_get_device_count"

type sample_format = Format_int8 | Format_int16 | Format_int24 | Format_int32 | Format_float32

type stream_parameters =
    {
      channels : int;
      device : int;
      sample_format : sample_format;
      latency : float;
    }

type stream_flag

type stream

external open_stream : stream_parameters -> stream_parameters -> float -> int -> stream_flag list -> (unit -> unit) option -> stream = "ocaml_pa_open_stream_byte" "ocaml_pa_open_stream"

let open_stream ip op rate buflen ?callback flags =
  open_stream ip op rate buflen flags callback

external open_default_stream : int -> int -> sample_format -> int -> int -> (unit -> unit) option -> stream = "ocaml_pa_open_default_stream_byte" "ocaml_pa_open_default_stream"

let open_default_stream ?callback ?(format=Format_float32) ic oc rate frames =
  open_default_stream ic oc format rate frames callback

external close_stream : stream -> unit = "ocaml_pa_close_stream"

external start_stream : stream -> unit = "ocaml_pa_start_stream"

external stop_stream : stream -> unit = "ocaml_pa_stop_stream"

external abort_stream : stream -> unit = "ocaml_pa_abort_stream"

external write_stream : stream -> float array array -> int -> int -> unit = "ocaml_pa_write_stream"

external read_stream : stream -> float array array -> int -> int -> unit = "ocaml_pa_read_stream"
