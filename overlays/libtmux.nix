_: super: {
  python310 = super.python310.override {
    packageOverrides = _: python-super: {
      libtmux = python-super.libtmux.overrideAttrs (_: {
        disabledTests = [
          "test_capture_pane_start"
        ];
        disabledTestPaths = [
          "tests/test_test.py"
          "tests/legacy_api/test_test.py"
        ];
      });
    };
  };
}
