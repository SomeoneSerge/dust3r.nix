{ fetchurl }:

fetchurl {
  urls = [
    # Mutable/non-deterministic
    "https://download.europe.naverlabs.com/ComputerVision/DUSt3R/DUSt3R_ViTLarge_BaseDecoder_512_dpt.pth"
  ];

  # 5e8bbf0c4d1d6007f5343f3f45814b956ddc5bbb4d00cb66beaf73afe5c53b34
  hash = "sha256-Xou/DE0dYAf1ND8/RYFLlW3cW7tNAMtmvq9zr+XFOzQ=";
}
