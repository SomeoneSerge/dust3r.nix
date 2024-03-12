{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-pep517,
  numpy,
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dranjan";
    repo = "python-plyfile";
    rev = "v${version}";
    hash = "sha256-+AIjfkVczs05ABUpTsykYc6v3XUfFURRQQRE9E05LiY=";
  };

  nativeBuildInputs = [ pdm-pep517 ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "plyfile" ];

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage = "https://github.com/dranjan/python-plyfile";
    changelog = "https://github.com/dranjan/python-plyfile/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
