{ lib, stdenv, afl}:

stdenv.mkDerivation {
  version = lib.getVersion afl;
  pname = "libdislocator";

  src = afl.src;
  sourceRoot = "${afl.src.name}/libdislocator";

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/lib/afl
  '';
  postInstall = ''
    mkdir $out/bin
    cat > $out/bin/get-libdislocator-so <<END
    #!${stdenv.shell}
    echo $out/lib/afl/libdislocator.so
    END
    chmod +x $out/bin/get-libdislocator-so
  '';

  meta = with lib; {
    homepage = "https://lcamtuf.coredump.cx/afl/";
    description = ''
      Drop-in replacement for the libc allocator which improves
      the odds of bumping into heap-related security bugs in
      several ways.
    '';
    mainProgram = "get-libdislocator-so";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
