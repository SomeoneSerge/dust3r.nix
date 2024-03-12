{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  corrade,
  magnum,
  libGL,
  pybind11,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "magnum-bindings";
  version = "unstable-2024-03-08";

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum-bindings";
    rev = "16cd0ebead07f260b627bd978aaf7eba79a09941";
    hash = "sha256-JKcPiI28O3Or3c9QmA1GsLNdaNy3voP5z6/DQenRh6k=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    corrade
    magnum
    libGL
    pybind11
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ xorg.libX11 ];

  cmakeFlags = [ (lib.cmakeBool "MAGNUM_WITH_PYTHON" true) ];

  meta = with lib; {
    description = "Bindings of the Magnum C++11 graphics engine into other languages";
    homepage = "https://github.com/mosra/magnum-bindings";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "magnum-bindings";
    platforms = platforms.all;
  };
}
