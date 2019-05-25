#!/bin/bash -e
oldpwd="$PWD"
workdir="/tmp/sambaschema"
mkdir -p "$workdir"
cd "$workdir"
apt-get download samba
ar -x *.deb
tar xvf data.tar.xz ./usr/share/doc/samba/examples/LDAP/samba.schema.gz
zcat ./usr/share/doc/samba/examples/LDAP/samba.schema.gz > /etc/ldap/schema/samba.schema
grep -Pie '^include.*$' /usr/share/slapd/slapd.conf > samba.conf
echo "include         /etc/ldap/schema/samba.schema" >> samba.conf
mkdir slapd.d
slaptest -f samba.conf -F slapd.d
cp -v '/tmp/sambaschema/slapd.d/cn=config/cn=schema/cn={4}samba.ldif' '/etc/ldap/slapd.d/cn=config/cn=schema'
chown openldap:openldap '/etc/ldap/slapd.d/cn=config/cn=schema/cn={4}samba.ldif'
cd $oldpwd
rm -rf "$workdir"
