{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  corrade,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "magnum";
  version = "unstable-2024-03-11";

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum";
    rev = "b1419017650c83538d8fe4681de6f0bca524cf49";
    hash = "sha256-kN2NhUCfUavNpK/cYQ1XgVUUaQJCKLCcF6VnL6vP3qU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    corrade
    libGL # A shim that resolves into libglvnd on Linux
  ];

  cmakeFlags = [
    (lib.cmakeBool "MAGNUM_WITH_EIGEN" true)
  ];

  meta = with lib; {
    description = "Lightweight and modular C++11 graphics middleware for games and data visualization";
    homepage = "https://github.com/mosra/magnum";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
    mainProgram = "magnum";
    platforms = platforms.all;
  };
}
