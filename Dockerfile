FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -qq install lsb-release wget software-properties-common gnupg

RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

RUN apt-get -qq install opam
RUN ln -s $(which clang-15) /usr/bin/clang

RUN apt-get -qq install libglfw3-dev

RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user

RUN opam init --disable-sandboxing

RUN opam switch create 4.14.0

COPY *.ml .
COPY *.c .

RUN eval $(opam env) && \
    ocamlc -custom -output-obj -o modcaml.o mod.ml && \
    ocamlc -c modwrap.c && \
    cp `ocamlc -where`/libcamlrun.a mod.a && chmod +w mod.a && \
    ar r mod.a modcaml.o modwrap.o

RUN eval $(opam env) && \
    cc -lm -Wl,--copy-dt-needed-entries -o prog -I `ocamlc -where` main.c mod.a -lcurses && \
    ./prog
