#!/usr/bin/env sh

source script/docker-functions

git checkout packaging/Gemfile.lock
rm -rf tmp
docker_build_bundle_base
output=$(bundle_update_on_docker)
echo "${output}"
updated_pact_gems=$(echo "${output}" | grep "pact" | grep "(was " | cut -d " " -f 2 -f 3 | uniq | ruby -e 'puts ARGF.read.split("\n").join(", ")')

git add packaging/Gemfile.lock

if [ -n "${updated_pact_gems}" ]; then
  commit_message="feat(gems): update to ${updated_pact_gems}"
else
  commit_message="feat(gems): update non-pact gems"
fi

git commit -m "${commit_message}"