AUTH_URL=$(cat ~/overcloudrc |grep AUTH_URL | awk -F'=' '{print $2}')
cat openrc311.base > openrc311.sh
echo "export OS_AUTH_URL=$AUTH_URL" >> openrc311.sh
