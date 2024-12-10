#!/bin/sh

echo "Backup slapd config"
slapcat -v -n0 | gzip -c >./export/ldap_config.ldif.gz
echo "Backup slapd data"
slapcat -v -n1 | gzip -c >./export/ldap_data.ldif.gz
exit 0
