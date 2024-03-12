{
  lib,
  buildPythonPackage,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pip,
  setuptools,
  wheel,
  attrs,
  gitpython,
  imageio,
  imageio-ffmpeg,
  matplotlib,
  numba,
  numpy,
  quaternion,
  pillow,
  scipy,
  tqdm,
  bullet,
  eigen,
  openexr,
  glfw3,
  pybind11,
  rapidjson,
  assimp,
  corrade,
  magnum,
  magnum-bindings,
  magnum-integration,
  magnum-plugins,
  recastnavigation,
  xorg,
}:

buildPythonPackage rec {
  pname = "habitat-sim";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "habitat-sim";
    rev = "v${version}";
    hash = "sha256-vTXBg3PUmXFn6nyGIGEap+LEW5KftnIXfk4qIp4T9SU=";
  };

  patches = [ ./0001-cmake-recastnavigation-allow-dependency-injection.patch ];
  postPatch = ''
    sed -i 's|option(USE_SYSTEM_\(.*\) OFF)|option(USE_SYSTEM_\1 ON)|' src/CMakeLists.txt
    substituteInPlace src/esp/gfx/CMakeLists.txt \
      --replace-fail \
        "MagnumIntegration REQUIRED Eigen" \
        "MagnumIntegration COMPONENTS Eigen"
    rm src/cmake/FindMagnumBindings.cmake
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pip
    setuptools
    wheel
  ];

  buildInputs = [
    (lib.getDev bullet)
    eigen
    openexr
    glfw3
    pybind11
    rapidjson
    assimp
    corrade
    magnum
    magnum-bindings
    magnum-integration
    magnum-plugins
    recastnavigation
  ] ++ lib.optionals stdenv.hostPlatform.isUnix [ xorg.libX11 ];

  propagatedBuildInputs = [
    attrs
    gitpython
    imageio
    imageio-ffmpeg
    matplotlib
    numba
    numpy
    quaternion
    pillow
    scipy
    tqdm
  ];

  dontUseCmakeConfigure = true;
  preConfigure = ''
    export CMAKE_ARGS=$cmakeFlags
  '';

  cmakeFlags = [
    (lib.cmakeFeature "MAGNUMINTEGRATION_INCLUDE_DIR" "${lib.getDev magnum-integration}/include")
    (lib.cmakeFeature "MAGNUMPLUGINS_INCLUDE_DIR" "${lib.getDev magnum-plugins}/include")
    (lib.cmakeFeature "MAGNUMBINDINGS_INCLUDE_DIR" "${lib.getDev magnum-bindings}/include")
  ];

  pythonImportsCheck = [ "habitat_sim" ];

  meta = with lib; {
    description = "A flexible, high-performance 3D simulator for Embodied AI research";
    homepage = "https://github.com/facebookresearch/habitat-sim";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
