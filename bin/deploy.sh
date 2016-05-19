#!/bin/bash

: 'Push script directory' && {
  CWD="$(cd "$(dirname "$0")" && pwd)"
}

: 'Setup variables' && {
  ENV=${ENV:-development}
  context=${GKE_CONTEXT_NAME_PREFIX}-${ENV}
  cluster=${GKE_CLUSTER_NAME_PREFIX}-${ENV}
}


: 'Get credential' && {
  gcloud container clusters get-credentials $cluster
}

: 'Roll up mackerel-agent' && {
  if [ 'production' = "$ENV" ]; then
    GKE_ENV=prod
  elif [ 'staging' = "$ENV" ]; then
    GKE_ENV=stg
  else
    GKE_ENV=stg
  fi
  sigil -p ${CWD}/../kubernetes/ds-mackerel-agent-${GKE_ENV}.yml | \
     kubectl apply --context=${context} -f - 
}
