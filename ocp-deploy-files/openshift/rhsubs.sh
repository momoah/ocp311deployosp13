#!/usr/bin/env bash
echo "Please enter your RedHat registry login ID"
read -sr OREG_AUTH_USER_INPUT
export OREG_AUTH_USER=$OREG_AUTH_USER_INPUT
echo "Please enter your RedHat registry password for $OREG_AUTH_USER"
read -sr OREG_AUTH_PASSWORD_INPUT
export OREG_AUTH_PASSWORD=$OREG_AUTH_PASSWORD_INPUT

