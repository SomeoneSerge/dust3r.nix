{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  which,
  buildPackages,
  croco,
  torch,
  cudaPackages,
  habitat-sim,
  ipykernel,
  ipywidgets,
  matplotlib,
  notebook,
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

  # Making pytorch'es useless _find_cuda_home() not fail
  env.CUDA_HOME = "${buildPackages.cudaPackages.cuda_nvcc}";
  env.TORCH_CUDA_ARCH_LIST = builtins.concatStringsSep ";" torch.cudaCapabilities;

  nativeBuildInputs = [
    setuptools
    wheel
    which # for pytorch'es useless cpp_extension
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [ (lib.getOutput "cxxdev" torch) ];
  propagatedBuildInputs =
    [
      typing-extensions
      habitat-sim
      ipykernel
      ipywidgets
      matplotlib
      notebook
      torch
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
