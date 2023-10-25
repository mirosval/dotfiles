{
  description = "A collection of opinionated flakes";

  outputs = _: {

    templates = {

      rust = {
        path = ./rust;
        description = "Basic Rust project";
      };

      python = {
        path = ./python;
        description = "Basic Python project with poetry";
      };

      nextjs = {
        path = ./nextjs;
        description = "Basic Next.js project with Typescript and Tailwind";
      };

    };
  };
}
