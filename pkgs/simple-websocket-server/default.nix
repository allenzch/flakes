{ buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "simple-websocket-server";
  version = "0.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0IOqpp7vy2/IfACdcgwMfW/o2VE13Bj4VaVohXbDOuY=";
  };

  doCheck = false;
  pyproject = true;
  build-system = [ setuptools ];
}
