#! /bin/bash

rggen_root=$(cd "$(dirname "$0")"/../..; pwd -P)
repository_root=`git rev-parse --show-toplevel`
repository_name=`basename ${repository_root}`
branch_name=`git branch --show-current`

# Check env variables
if [ ! -z "${RGGEN_ROOT}" ]; then
  rggen_root=${RGGEN_ROOT}
fi

if [ ! -z "${RGGEN_REPOSITORY_NAME}" ]; then
  repository_name=${RGGEN_REPOSITORY_NAME}
fi

if [ ! -z "${RGGEN_BRANCH_NAME}" ]; then
  branch_name=${RGGEN_BRANCH_NAME}
fi

# Get checkout list file
list_dir=${rggen_root}/rggen-checkout/${repository_name}
list_file=${list_dir}/master.yml
if [ -f ${list_dir}/${branch_name}.yml ]; then
  list_file=${list_dir}/${branch_name}.yml
fi

# Checkout repositories
while read entry; do
  checkout_repository=`echo ${entry} | cut -d : -f 1 | tr -d ' '`
  checkout_branch=`echo ${entry} | cut -d : -f 2 | tr -d ' '`

  command="git clone --branch=${checkout_branch} https://github.com/rggen/${checkout_repository}.git"
  echo ${command}
  ${command}
done < ${list_file}
