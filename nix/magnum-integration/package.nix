{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  corrade,
  eigen,
  magnum,
}:

stdenv.mkDerivation rec {
  pname = "magnum-integration";
  version = "unstable-2024-03-07";

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum-integration";
    rev = "f01593fc94556bff23a848ac71187c56e034b6d9";
    hash = "sha256-q5LCSNQmf9MqUX4PKnwYxxIC/khREwBCPte2szhH8tA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    eigen
    corrade
    magnum
  ];

  cmakeFlags = [
    (lib.cmakeBool "MAGNUM_WITH_EIGEN" true)
  ];

  meta = with lib; {
    description = "Integration libraries for the Magnum C++11 graphics engine";
    homepage = "https://github.com/mosra/magnum-integration";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "magnum-integration";
    platforms = platforms.all;
  };
}
