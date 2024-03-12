{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  jsonpatch,
  networkx,
  numpy,
  requests,
  scipy,
  six,
  tornado,
  websocket-client,
  pillow,
}:

buildPythonPackage rec {
  pname = "visdom";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fossasia";
    repo = "visdom";
    rev = "v${version}";
    hash = "sha256-Tqapmw7ckU1FYuKvQWBbNvUdJd3cIXvbOX4rO5ifM7M=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];
  propagatedBuildInputs = [
    jsonpatch
    networkx
    numpy
    requests
    scipy
    six
    tornado
    websocket-client
    pillow
  ];

  pythonImportsCheck = [ "visdom" ];

  meta = with lib; {
    description = "A flexible tool for creating, organizing, and sharing visualizations of live, rich data. Supports Torch and Numpy";
    homepage = "https://github.com/fossasia/visdom";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
