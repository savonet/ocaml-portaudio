(lang dune 2.8)
(version 0.2.3)
(name portaudio)
(source (github savonet/ocaml-portaudio))
(license LGPL-2.1)
(authors "The Savonet Team <savonet-users@lists.sourceforge.net>")
(maintainers "The Savonet Team <savonet-users@lists.sourceforge.net>")

(generate_opam_files true)
(use_standard_c_and_cxx_flags false)

(package
 (name portaudio)
 (synopsis "Bindings for the portaudio library which provides high-level functions for using soundcards")
 (depends
  conf-portaudio
  conf-pkg-config
  dune
  dune-configurator)
)
