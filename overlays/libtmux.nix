self: super: {
  python310 = super.python310.override {
    packageOverrides = python-self: python-super: {
      libtmux = python-super.libtmux.overrideAttrs (oldAttrs:{
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
