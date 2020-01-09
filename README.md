# terraform-demo-modules

**Not For Production Use**

The modules are designed to make it easy to spin up demo environments. Specifically, they are designed to be used with [Terragrunt](https://terragrunt.gruntworks.io) (https://terragrunt.gruntworks.io).

By cloing this repo, it is possible use the `--terragrunt-source` flag when used inconjunction with a set of Terragrunt configuration files that use these modules exclusively.

In most cases, they are basic pass-through modules that add `provider` and `terraform` stanza. With the latter including a minimal state configuration too, as well as constraining provider versions.

In other cases, `/aws/vpc` for instance, they are a bit more featured. These are generally modules that other modules are dependant on.
