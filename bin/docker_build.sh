#!/bin/bash

: 'Process arguments' && {
  branch_name=$1
}

: 'Determine docker image tag' && {
  docker_image_tag=''

  case "${branch_name}" in
    'master') docker_image_tag='latest' ;;
    'staging') docker_image_tag='staging' ;;
    'production') docker_image_tag='production' ;;
    *) ;;
  esac
}

: 'Build docker image' && {
  if [[ "${docker_image_tag}" != '' ]]; then
    docker build -t asia.gcr.io/${GCP_PROJECT_NAME}/mackerel-agent:$CIRCLE_SHA1 .
    docker tag asia.gcr.io/${GCP_PROJECT_NAME}/mackerel-agent:$CIRCLE_SHA1 asia.gcr.io/${GCP_PROJECT_NAME}/mackerel-agent:${docker_image_tag}
    gcloud docker push asia.gcr.io/${GCP_PROJECT_NAME}/mackerel-agent:${docker_image_tag}
  fi
}
