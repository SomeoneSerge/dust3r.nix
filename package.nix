{
  lib,
  buildPythonPackage,
  einops,
  gradio,
  matplotlib,
  opencv4,
  opencv-python ? opencv4,
  pyglet,
  roma,
  scipy,
  tensorboard,
  torch,
  torchvision,
  torch-batch-svd,
  tqdm,
  trimesh,
  python,
  croco,
  makeWrapper,
}:

buildPythonPackage {
  pname = "dust3r";
  version = "0.0.0";
  pyproject = true;

  src =
    let
      fs = lib.fileset;
      intersect = lib.flip fs.intersection;
      subtract = lib.flip fs.difference;
      hasAnySuffices = name: builtins.any (ext: lib.hasSuffix ext name);
    in
    lib.pipe ./. [
      fs.gitTracked
      (intersect (fs.fileFilter (file: !(file.hasExt "nix")) ./.))
      (intersect (fs.fileFilter (file: !(lib.hasPrefix "." file.name)) ./.))
      (intersect (
        fs.fileFilter (
          file:
          !(hasAnySuffices file.name [
            ".img"
            ".pth"
            ".zip"
            ".ipynb"
          ])
        ) ./.
      ))
      (subtract (fs.maybeMissing ./assets))
      (subtract (fs.maybeMissing ./result-scenes))
      (subtract (fs.maybeMissing ./checkpoints))
      (
        fileset:
        fs.toSource {
          inherit fileset;
          root = ./.;
        }
      )
      lib.cleanSource
    ];

  # Training and evaluation scripts &c
  postPatch = ''
    mv *.py dust3r/
    cat << EOF >> pyproject.toml
    [project.scripts]
    dust3r-demo = "dust3r.demo:main"
    EOF
  '';

  nativeBuildInputs = [
    makeWrapper
  ];
  propagatedBuildInputs = [
    einops
    gradio
    matplotlib
    opencv-python
    pyglet
    roma
    scipy
    torch
    torchvision
    tqdm
    trimesh
    croco
    torch-batch-svd
  ];

  passthru.optional-dependencies.dev = [ tensorboard ];
  pythonImportsCheck = [ "dust3r" ];

  meta = with lib; {
    description = "Official implementation of DUSt3R: Geometric 3D Vision Made Easy";
    homepage = "https://github.com/naver/dust3r";
    license = licenses.cc-by-nc-sa-40;
    maintainers = with maintainers; [ SomeoneSerge ];
    mainProgram = "dust3r";
    platforms = platforms.all;
  };
}
