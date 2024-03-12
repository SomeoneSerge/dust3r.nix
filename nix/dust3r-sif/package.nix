{
  singularity-tools,
  pythonWithDust3r,
  coreutils,
}:
singularity-tools.buildImage rec {
  name = "dust3r";
  contents = [
    pythonWithDust3r
    coreutils
  ];
  diskSize = 1024 * 20;
  memSize = diskSize;
}
