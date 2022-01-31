packageName   = "stint"
version       = "2.0.0"
author        = "Status Research & Development GmbH"
description   = "Efficient stack-based multiprecision int in Nim"
license       = "Apache License 2.0 or MIT"
skipDirs      = @["tests", "benchmarks"]
### Dependencies

# TODO test only requirements don't work: https://github.com/nim-lang/nimble/issues/482
requires "nim >= 1.2.12",
         "stew"

proc test(name: string, lang: string = "c") =
  if not dirExists "build":
    mkDir "build"
  --run
  switch("out", ("./build/" & name))
  setCommand lang, "tests/" & name & ".nim"

task test_internal, "Run tests for internal procs":
  test "internal"

task test_public_api, "Run all tests - prod implementation (StUint[64] = uint64":
  test "all_tests"

task test_uint256_ttmath, "Run random tests Uint256 vs TTMath":
  requires "https://github.com/alehander42/nim-quicktest >= 0.18.0", "https://github.com/status-im/nim-ttmath"
  switch("define", "release")
  test "uint256_ttmath", "cpp"

task test, "Run all tests":
  exec "nimble test_internal"
  exec "nimble test_public_api"
