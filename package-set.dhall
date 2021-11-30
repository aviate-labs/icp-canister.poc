let upstream = https://github.com/aviate-labs/package-set/releases/download/v0.1.3/package-set.dhall sha256:ca68dad1e4a68319d44c587f505176963615d533b8ac98bdb534f37d1d6a5b47
let Package = { name : Text, version : Text, repo : Text, dependencies : List Text }
let additions = [
  { name = "principal"
  , repo = "https://github.com/aviate-labs/principal.mo"
  , version = "v0.2.4"
  , dependencies = [ "array", "base", "hash", "encoding", "sha" ]
  }
] : List Package
in  upstream # additions
