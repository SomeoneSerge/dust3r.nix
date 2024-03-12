{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  corrade,
  magnum,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "magnum-bindings";
  version = "2020.06";

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum-bindings";
    rev = "v${version}";
    hash = "sha256-Nw5Moyv8e9bpyDckfzysDq1nxGGzfyfBZRdYDk7HkBU=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    corrade
    magnum
    libGL
  ];

  meta = with lib; {
    description = "Bindings of the Magnum C++11 graphics engine into other languages";
    homepage = "https://github.com/mosra/magnum-bindings";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "magnum-bindings";
    platforms = platforms.all;
  };
}
