SOURCES=noise.ml
RESULT=noise
LIBS=portaudio bigarray
INCDIRS=../src
THREADS = yes

all: nc

test: all
	./noise --device 0 --format int16 --blocking --interleaved
	./noise --device 0 --format int16 --callback

include OCamlMakefile
