{
  buildPythonPackage,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  corrade,
  magnum,
  libGL,
  xorg,
  pybind11,
  setuptools,
}:

buildPythonPackage rec {
  pname = "magnum-bindings";
  version = "unstable-2024-03-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum-bindings";
    rev = "16cd0ebead07f260b627bd978aaf7eba79a09941";
    hash = "sha256-JKcPiI28O3Or3c9QmA1GsLNdaNy3voP5z6/DQenRh6k=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    setuptools
  ];

  buildInputs = [
    corrade
    magnum
    libGL
    pybind11
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ xorg.libX11 ];

  cmakeFlags = [ "-GNinja" (lib.cmakeBool "MAGNUM_WITH_PYTHON" true) ];

  # Runs pre/postBuild hooks twice...
  buildPhase = ''
    runPhase ninjaBuildPhase

    # "$sourceRoot/build/src/python"
    cd src/python
    runPhase pypaBuildPhase
  '';

  installPhase = ''
    runPhase pypaInstallPhase

    (cd ../.. ; runPhase ninjaInstallPhase)
  '';

  meta = with lib; {
    description = "Bindings of the Magnum C++11 graphics engine into other languages";
    homepage = "https://github.com/mosra/magnum-bindings";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "magnum-bindings";
    platforms = platforms.all;
  };
}
