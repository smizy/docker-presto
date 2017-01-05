@test "presto is the correct version" {
  run docker run smizy/presto:${TAG} presto --version
  echo "${output}" 

  [ $status -eq 0 ]
  [ "${lines[0]}" = "Presto CLI ${VERSION}" ]
}