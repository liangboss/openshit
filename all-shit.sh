#!/bin/bash
SCRIPT_NAME=all-shit.sh
MAIN_SCRIPT=openshit.sh
PREINSTALL_SCRIPT=pre-install.sh
INSTALL_LIST="mysql rabbitmq keystone glance nova nova-network cinder dashboard"
SERVICE_LIST="mysql rabbitmq keystone glance nova nova-network cinder"
REMOVE_LIST="dashboard cinder nova-network nova glance keystone"
REMOVE_DEPENDENCE_LIST="rabbitmq mysql"
CONFIG_LIST="keystone glance nova nova-network cinder"

# args: service-list
# env: ACTION

ACTION=""
run_openshit()
{
  local SERVICE_LIST=$@
  for SERVICE in $SERVICE_LIST;
  do
    echo "${ACTION}: ${SERVICE}"
    bash -c "bash ${MAIN_SCRIPT} $SERVICE $ACTION"
  done
}

help()
{
  echo "usage: ${SCRIPT_NAME} <start|stop|restart|config|install|download|uninstall>"
}

if [ $# -lt 1 ]; then
  help
  exit
fi
ACTION=$1
if [ $ACTION = "start" -o $ACTION = "stop" -o $ACTION = "restart" ]; then
  run_openshit $SERVICE_LIST
elif [ $ACTION = "config" ]; then
  run_openshit $CONFIG_LIST
elif [ $ACTION = "install" -o $ACTION = "download" ]; then
  bash $PREINSTALL_SCRIPT
  run_openshit $INSTALL_LIST
elif [ $ACTION = "uninstall" ]; then
  run_openshit $REMOVE_LIST
  echo "There some dependence package:"
  echo "    ${REMOVE_DEPENDENCE_LIST}"
  read -p "Do you want to remove? [y/N]" ret
  if [ 'Y' = ret -o 'y' = ret ]; then
    run_openshit $REMOVE_DEPENDENCE_LIST
  fi
else
  help
fi