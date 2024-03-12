{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  croco,
  torch,
  cudaPackages,
  habitat-sim,
  ipykernel,
  ipywidgets,
  matplotlib,
  notebook,
  pytorch,
  torchvision,
  typing-extensions,
  widgetsnbextension,
  enablePretraining ? false,
  opencv,
  quaternion,
  scikit-learn,
  tqdm,
}:

buildPythonPackage rec {
  pname = "curope";
  inherit (croco) version;
  pyproject = true;

  src = "${croco.src}/models/curope";

  nativeBuildInputs = [
    setuptools
    wheel
    cudaPackages.cuda_nvcc
  ];

  buildInputs =
    [
      (lib.getOutput "cxxdev" torch)
      typing-extensions
      habitat-sim
      ipykernel
      ipywidgets
      matplotlib
      notebook
      pytorch
      torchvision
      widgetsnbextension
    ]
    ++ lib.optionals enablePretraining [
      opencv
      quaternion
      scikit-learn
      tqdm
    ];

  meta = with lib; {
    description = "CUDA implementation of RoPE from Naverlab's CroCo";
    homepage = "https://github.com/naver/croco";
    license = licenses.cc-by-nc-sa-40;
    mainProgram = "croco";
    maintainers = with maintainers; [ SomeoneSerge ];
    platforms = platforms.all;
  };
}
