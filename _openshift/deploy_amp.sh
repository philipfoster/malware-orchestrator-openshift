#!/bin/bash

# Set the ANSIBLE_ROLES_PATH to drop the roles required for the playbook locally:
# export ANSIBLE_ROLES_PATH=$(readlink -f roles)
# echo "ANSIBLE_ROLES_PATH set to: $ANSIBLE_ROLES_PATH"

# Make sure that the roles required by the playbook are installed (force the right versions
# if that's required):
ansible-galaxy install -r roles/requirements.yml --force

# Get the current user's OCP access token:
OCP_TOKEN=$(oc whoami -t)
echo "User's OCP token => $OCP_TOKEN"

# Call the local `deploy` script which runs the actual `ansible-galaxy` command
# to apply the templates to the OCP cluster.  Note the environment variables
# ("-e") passed to the `ansible-playbook` command in the `deploy` script.

./deploy -e ocp_user='developer' \
         -e ocp_token="$OCP_TOKEN" \
         -e ocp_url='https://ocp.ecicd.dso.ncps.us-cert.gov' \
         -e docker_repo_url='docker.artifactory.apps.ecicd.dso.ncps.us-cert.gov' \
         -e namespace_name='hr-authentication-amp' \
         -e image_namespace_name='hr-authentication-amp' \
         -e filter_tags='create-build-config'\
         -e include_tags='create-build-config'
