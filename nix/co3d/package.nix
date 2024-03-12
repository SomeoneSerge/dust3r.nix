{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  h5py,
  requests,
  tqdm,
  visdom,
  pillow,
  plyfile,
}:

buildPythonPackage rec {
  pname = "co3d";
  version = "unstable-2023-03-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "co3d";
    rev = "a8db478e5e6e4fece2e5e13f3f04bc544b434f8d";
    hash = "sha256-H1CPhsLlwhhPgzEjDvmZGdhdOfsng9jexx3axciewMk=";
  };
  patches = [
    ./0001-co3d.download_dataset-fix-imports.patch
    ./0002-pyproject-add-an-entrypoint-for-download_dataset.patch
    ./0003-nix-bootstrap-an-empty-flake.patch
    ./0004-pyproject-fix-JSONs-missing-from-the-wheel.patch
  ];
  postPatch = ''
    substituteInPlace co3d/download_dataset.py \
      --replace \
        "from dataset." \
        "from co3d.dataset."
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    h5py
    requests
    tqdm
    visdom
    pillow
    plyfile
  ];

  pythonImportsCheck = [ "co3d" ];

  meta = with lib; {
    changelog = "https://github.com/facebookresearch/co3d/blob/${src.rev}/CHANGELOG.md";
    description = "Tooling for the Common Objects In 3D dataset";
    homepage = "https://github.com/facebookresearch/co3d";
    license = licenses.cc-by-nc-40;
    mainProgram = "dust3r-demo";
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
