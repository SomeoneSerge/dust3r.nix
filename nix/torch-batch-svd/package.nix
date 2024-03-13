{
  lib,
  buildPythonPackage,
  buildPackages,
  fetchFromGitHub,
  setuptools,
  wheel,
  which,
  torch,
  cudaPackages,
}:

buildPythonPackage rec {
  pname = "torch-batch-svd";
  version = "unstable-2022-10-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KinglittleQ";
    repo = "torch-batch-svd";
    rev = "c0a96119187f7d55f939d2ff2b92942c6d6ca930";
    hash = "sha256-eqF8Qs+JsVeJ4Z6Scgh6D3yVoiZtFKvGnqA3x6ZTSjc=";
  };
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "rev =" \
        'rev = "0.0.0" #'
  '';

  env.CUDA_HOME = "${buildPackages.cudaPackages.cuda_nvcc}";
  env.TORCH_CUDA_ARCH_LIST = builtins.concatStringsSep ";" torch.cudaCapabilities;

  nativeBuildInputs = [
    setuptools
    wheel
    which # for pytorch'es useless cpp_extension
    cudaPackages.cuda_nvcc
  ];

  propagatedBuildInputs = [
    torch
  ];
  buildInputs = [
    (lib.getOutput "cxxdev" torch)
  ];

  pythonImportsCheck = [ "torch_batch_svd" ];

  meta = with lib; {
    description = "A 100x faster SVD for PyTorch";
    homepage = "https://github.com/KinglittleQ/torch-batch-svd";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
