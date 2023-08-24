{
  description = "A collection of opinionated flakes";

  outputs = { self }: {

    templates = {

      rust = {
        path = ./rust;
        description = "Basic Rust project";
      };

      python = {
        path = ./python;
        description = "Basic Python project with poetry";
      };

    };
  };
}
