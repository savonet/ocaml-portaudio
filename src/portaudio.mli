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

(**
  * Bindings for the portaudio portable audio library.
  *
  * @author Samuel Mimram
  *)

(** {2 Exceptions} *)
(** An error occured. In the future, this exception should be replaced by more
  * specific exceptions. Use [string_of_error] to get a description of the
  * error. *)
exception Error of int

(** An unanticipaced *)
exception Unanticipated_host_error

(** Get a description of an error. *)
val string_of_error : int -> string

(** Get the last errror which occured together with its description. *)
val get_last_host_error : unit -> int * string

(** {2 General} *)

(** Version of portaudio. *)
val get_version : unit -> int

(** Version of portaudio. *)
val get_version_string : unit -> string

(** Initialize the portaudio library. Should be called before calling any other
  * function. *)
val init : unit -> unit

(** Stop using the library. This function should be called before ending the
  * program and no other portaudio function should be called after. *)
val terminate : unit -> unit

(** {2 Host API} *)
(** Number of available host API. *)
val get_host_api_count : unit -> int

(** Index of the default host API. *)
val get_default_host_api : unit -> int

(** Default input device. *)
val get_default_input_device : unit -> int

(** Default output device. *)
val get_default_output_device : unit -> int

(** Number of available devices. *)
val get_device_count : unit -> int

(** {2 Streams} *)

(** Format of samples. *)
type sample_format =
  | Format_int8
  | Format_int16
  | Format_int24
  | Format_int32
  | Format_float32

(** Parameters of the stream. *)
type stream_parameters =
    {
      channels : int;
      device : int;
      sample_format : sample_format;
      latency : float;
    }

(*
type stream_flag
*)

type stream

(*
(** [open_stream inparam outparam rate bufframes callback flags] opens a new
  * stream with input stream of format [inparam], output stream of format
  * [outparam] at [rate] samples per second, with [bufframes] frames per buffer
  * passed the callback function [callback] (0 means leave this choice to
  * portaudio). *)
val open_stream : stream_parameters -> stream_parameters -> float -> int -> ?callback:(unit -> unit) -> stream_flag list -> stream
*)

(** [open_default_stream callback format inchans outchans rate bufframes] opens
  * default stream with [callback] as callback function, handling samples in
  * [format] format with [inchans] input channels and [outchans] output channels
  * at [rate] samples per seconds with handling buffers of size [bufframes]. *)
val open_default_stream : ?callback:(unit -> unit) -> ?format:sample_format -> int -> int -> int -> int -> stream

(** Close a stream. *)
val close_stream : stream -> unit

(** Start a stream. *)
val start_stream : stream -> unit

(** Stop a stream. *)
val stop_stream : stream -> unit

(** Abort a stream. *)
val abort_stream : stream -> unit

(** Write to a stream. *)
val write_stream : stream -> float array array -> int -> int -> unit

(** Read from a stream. *)
val read_stream : stream -> float array array -> int -> int -> unit
