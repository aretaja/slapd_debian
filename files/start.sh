#!/bin/sh

chown -R openldap ./export ./import \
  && cp /home/slapd/certs/*_server.pem /etc/ssl/certs/ \
  && cp /home/slapd/certs/ca_certs.pem /etc/ldap/ \
  && cp /home/slapd/certs/*.key /etc/ssl/private/ \
  && echo "TLS_CACERT /etc/ldap/ca_certs.pem" >/etc/ldap/ldap.conf \
  && addgroup --system ssl-cert \
  && adduser openldap ssl-cert \
  && chmod 0710 /etc/ssl/private \
  && chown -R :ssl-cert /etc/ssl/private \
  && chmod 640 /etc/ssl/private/*
echo "Environment prepared"

# Import config(s) if requested
if [ "${CONFIMPORT}" -eq 1 ]; then
    echo "Config import requested"

    # Config
    if [ -e ./import/ldap_config.ldif.gz ]; then
        echo "Decompressing slapd config ldif"
        gunzip ./import/ldap_config.ldif.gz
    fi
    if [ -e ./import/ldap_config.ldif ]; then
        echo "Found slapd config ldif"
        rm -fr /etc/ldap/slapd.d/* \
        && slapadd  -F /etc/ldap/slapd.d -n 0 -l ./import/ldap_config.ldif \
        && chown -R openldap:openldap /etc/ldap/slapd.d
    fi

    # Data
    if [ -e ./import/ldap_data.ldif.gz ]; then
        echo "Decompressing slapd data ldif"
        gunzip ./import/ldap_data.ldif.gz
    fi
    if [ -e ./import/ldap_data.ldif ]; then
        echo "Found slapd data ldif"
        rm -fr /var/lib/ldap/* \
        && slapadd  -F /etc/ldap/slapd.d -l ./import/ldap_data.ldif \
        && chown -R openldap:openldap /var/lib/ldap
    fi
fi

echo "Executing slapd daemon process"
/usr/sbin/slapd -d "${DEBUGSLAPD}" -4 -h " ldapi:/// ldap:/// ldaps:///" -g openldap -u openldap -F /etc/ldap/slapd.d
