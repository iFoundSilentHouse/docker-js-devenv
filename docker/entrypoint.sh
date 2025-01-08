#!/bin/sh
echo "##################################"
echo "####### ENTRYPOINT.bash ##########"
echo "##################################"

echo "# start vscode as $USER"
whoami
echo "# start vscode"
su -s /bin/bash $USER <<EOF
code-oss --verbose --user-data-dir ./userdata .
EOF
