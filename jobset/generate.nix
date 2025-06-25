{ nixpkgs, generator, pull_requests, generator_config, ignore_prs_from_forks ? false } @ args:
let
  pkgs = import nixpkgs { };
  inherit (pkgs) lib;
  jobset_generator = import (generator + "/jobset-generator") { inherit pkgs; };
in
{
  jobsets =
    pkgs.runCommand "jobsets.json"
      {
        buildInputs = [ jobset_generator ];
        template = generator_config + "/.hydra/config.json";
      } ''
      jobset-generator ${pull_requests} "$template" ${lib.optionalString ignore_prs_from_forks "--ignore-prs-from-forks"}  > $out
    '';
}
