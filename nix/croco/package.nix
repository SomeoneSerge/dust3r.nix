{
  lib,
  buildPythonPackage,
  config,
  withCuda ? config.cudaSupport,
  fetchFromGitHub,
  setuptools,
  wheel,
  habitat-sim,
  curope,
}:

buildPythonPackage rec {
  pname = "croco";
  version = "unstable-2024-02-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "naver";
    repo = "croco";
    rev = "743ee71a2a9bf57cea6832a9064a70a0597fcfcb";
    hash = "sha256-xPdnFlMaafiPgxq+ZNPVD2+Tnftm9e5p7psmSn5MI0E=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];
  propagatedBuildInputs = [
    habitat-sim
  ] ++ lib.optionals withCuda [
    curope
  ];

  pyprojectToml = ./pyproject.toml;
  postPatch = ''
    rm -f models/curope/setup.py

    cp "$pyprojectToml" pyproject.toml
  '';

  # We could easily prefix these, but dust3r is written to expect the
  # conflict-prone generic names and it's too many imports...
  pythonImportsCheck = [
    "datasets.transforms"
    "models.croco"
  ];

  meta = with lib; {
    description = "Naverlab's CroCo model presented at the NeurIPS'22";
    homepage = "https://github.com/naver/croco";
    license = licenses.cc-by-nc-sa-40;
    mainProgram = "croco";
    maintainers = with maintainers; [ SomeoneSerge ];
    platforms = platforms.all;
  };
}
