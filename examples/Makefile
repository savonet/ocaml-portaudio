SOURCES=noise.ml
RESULT=noise
LIBS=portaudio bigarray
INCDIRS=../src
THREADS = yes

all: nc

test:
	./noise --device 0 --format int16 --blocking --interleaved

include OCamlMakefile
