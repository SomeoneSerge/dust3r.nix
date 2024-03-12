{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  SDL2,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "recastnavigation";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "recastnavigation";
    repo = "recastnavigation";
    rev = "v${version}";
    hash = "sha256-SNaGXm50n+7ZM6c4lgUnQYZDoEBdCajkDyYtcisev2U=";
  };

  patches = [
    ./0001-CMake-fix-write-correct-install-paths-in-the-.pc.patch

    # "Multi-goal shortest path"
    (fetchpatch {
      url = "https://github.com/recastnavigation/recastnavigation/commit/b9d9a9d8ba243f588f4534efe3759a5abbd21dcb.patch";
      hash = "sha256-1thkQQ1kSUPHqVO1R46+v8soko0QLCWQN+hovTL2mdI=";
    })

    # Patches from: https://github.com/recastnavigation/recastnavigation/compare/main...erikwijmans:recastnavigation:master

    # "Adds multi-goal shortest path ..."
    # (fetchpatch {
    #   url = "https://github.com/recastnavigation/recastnavigation/commit/02be4986e3f02c807443366cef56d33b75ad89dc.patch";
    #   hash = "sha256-ygdhqdzGXZyRgCDM3vCxV6gQTH2u+zNBGu0ZfFCe6Pk=";
    # })
    # # "Fix 64bit pointer arithmetic warnings"
    # (fetchpatch {
    #   url = "https://github.com/recastnavigation/recastnavigation/commit/7a2363f8ebf4b3cfecfdc07f9b4c72ae9aeba4de.patch";
    #   # Hmm?
    #   hash = "sha256-ygdhqdzGXZyRgCDM3vCxV6gQTH2u+zNBGu0ZfFCe6Pk=";
    # })
    # # "Hacky fix for ESP"
    # (fetchpatch {
    #   url = "https://github.com/recastnavigation/recastnavigation/commit/5c7ef6fea3b43abda5b0daa982be265d23d0664c.patch";
    #   hash = "sha256-JLU39Cgss3nWXy6L/8x02tz4+pM9vjap6RW4XiRdvx8=";
    # })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    # "Dependency-Free - building Recast & Detour only requires a C++98-compliant compiler"
    SDL2
    libGLU
  ];

  cmakeFlags = [
    # They vendor a broken copy of catch2
    (lib.cmakeBool "RECASTNAVIGATION_TESTS" false)
  ];

  meta = with lib; {
    description = "Navigation-mesh Toolset for Games";
    homepage = "https://github.com/erikwijmans/recastnavigation";
    license = licenses.zlib;
    maintainers = with maintainers; [ ];
    mainProgram = "recastnavigation";
    platforms = platforms.all;
  };
}
