{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  numpy,
  torch,
}:

buildPythonPackage rec {
  pname = "roma";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "naver";
    repo = "roma";
    rev = "v${version}";
    hash = "sha256-Rb6EaiDAntg6PaDIwn9V3oZYYV+qUOSFE8gBvfkAggU=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    torch
  ];

  pythonImportsCheck = [ "roma" ];

  meta = with lib; {
    description = "RoMa: A lightweight library to deal with 3D rotations in PyTorch";
    homepage = "https://github.com/naver/roma";
    license = licenses.cc-by-nc-sa-40;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
