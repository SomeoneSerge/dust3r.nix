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
  version = "unstable-2024-02-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "naver";
    repo = "roma";
    rev = "1c2739571d06a746723fc552203ff7e844ea2ad3";
    hash = "sha256-ROfa9JODUK5+yVxdDW3+9vILgUhTzxfN362e5iNIL9U=";
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
