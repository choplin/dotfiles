# pyworld 0.3.5 reads its version through `pkg_resources`, which setuptools
# dropped in 81.0.0. Rewrite the import to `importlib.metadata` so the package
# (and voicevox-engine, which depends on it) keeps building.
# Drop this overlay once nixpkgs ships a fixed pyworld.
final: prev: {
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (pyfinal: pyprev: {
        pyworld = pyprev.pyworld.overridePythonAttrs (old: {
          postPatch =
            (old.postPatch or "")
            + ''
              substituteInPlace pyworld/__init__.py \
                --replace-fail "import pkg_resources" "from importlib.metadata import version" \
                --replace-fail "pkg_resources.get_distribution('pyworld').version" "version('pyworld')"
            '';
        });
      })
    ];
}
