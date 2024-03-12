{
  lib,
  buildPythonPackage,
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
  eigen,
  openexr,
  glfw3,
  pybind11,
  rapidjson,
  assimp,
  corrade,
  magnum,
  magnum-integration,
  magnum-bindings,
  recastnavigation
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

  patches = [
    ./0001-cmake-recastnavigation-allow-dependency-injection.patch
  ];
  postPatch = ''
    sed -i 's|option(USE_SYSTEM_\(.*\) OFF)|option(USE_SYSTEM_\1 ON)|' src/CMakeLists.txt
    substituteInPlace src/esp/gfx/CMakeLists.txt \
      --replace-fail \
        "MagnumIntegration REQUIRED Eigen" \
        "MagnumIntegration COMPONENTS Eigen"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pip
    setuptools
    wheel
  ];

  buildInputs = [
    eigen
    openexr
    glfw3
    pybind11
    rapidjson
    assimp
    corrade
    magnum
    magnum-integration
    magnum-bindings
    recastnavigation
  ];

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

  pythonImportsCheck = [ "habitat_sim" ];

  meta = with lib; {
    description = "A flexible, high-performance 3D simulator for Embodied AI research";
    homepage = "https://github.com/facebookresearch/habitat-sim";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
