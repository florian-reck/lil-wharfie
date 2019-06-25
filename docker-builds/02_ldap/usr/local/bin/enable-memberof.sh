#!/bin/bash -e
cat << EOF |ldapadd -Y EXTERNAL -H ldapi:/// -f /dev/stdin
dn: cn=module,cn=config
cn: module
objectClass: olcModuleList
olcModuleLoad: memberof
olcModulePath: /usr/lib/ldap

dn: cn=module,cn=config
cn: module
objectClass: olcModuleList
olcModuleLoad: refint
olcModulePath: /usr/lib/ldap

dn: olcOverlay=memberof,olcDatabase={1}mdb,cn=config
objectClass: olcMemberOf
objectClass: olcOverlayConfig
objectClass: olcConfig
olcOverlay: memberof
olcMemberOfDangling: ignore
olcMemberOfGroupOC: groupOfNames
olcMemberOfMemberAD: member
olcMemberOfMemberOfAD: memberOf
olcMemberOfRefInt: TRUE

dn: olcOverlay=refint,olcDatabase={1}mdb,cn=config
objectClass: olcConfig
objectClass: olcOverlayConfig
objectClass: olcRefintConfig
objectClass: top
olcOverlay: refint
olcRefintAttribute: memberof member manager owner
EOF
