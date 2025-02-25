{
  lib,
  async-timeout,
  buildPythonPackage,
  deprecated,
  fetchFromGitHub,
  pympler,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  redis,
  wrapt,
}:

buildPythonPackage rec {
  pname = "coredis";
  version = "4.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = pname;
    tag = version;
    hash = "sha256-HfGmsIi8PnYbnC2020x474gtq0eqHjF7mSmRSHb0QxY=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "-K" ""
  '';

  propagatedBuildInputs = [
    async-timeout
    deprecated
    pympler
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
    redis
    pytest-asyncio
  ];

  pythonImportsCheck = [ "coredis" ];

  pytestFlagsArray = [
    # All other tests require Docker
    "tests/test_lru_cache.py"
    "tests/test_parsers.py"
    "tests/test_retry.py"
    "tests/test_utils.py"
  ];

  meta = with lib; {
    description = "Async redis client with support for redis server, cluster & sentinel";
    homepage = "https://github.com/alisaifee/coredis";
    changelog = "https://github.com/alisaifee/coredis/blob/${src.rev}/HISTORY.rst";
    license = licenses.mit;
    maintainers = teams.wdz.members;
  };
}
