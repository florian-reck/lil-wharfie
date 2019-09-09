#!/usr/bin/python3
import os, sys
import ldap, ldap.sasl, ldap.modlist
import yaml
import re
import subprocess

configFile = '/storage/initialconfig.yaml'
ldapConfigFile = '/etc/ldap/ldap.conf'
ldapSearchFilter = '(&(objectClass=posixAccount)(!(sambaSID=*)))'
configLinePattern = re.compile('^(.*?)\s+(.*?)\s*$')
config = yaml.safe_load(open(configFile, 'r').read())
fullDomainName = config['top']['domain'].strip().lower()
suffix = 'dc=' + fullDomainName.replace('.', ',dc=')
adminDN = 'cn=admin,' + suffix

ldapConfigString = open(ldapConfigFile).read()
ldapConfig = {}
for line in ldapConfigString.split('\n'):
    strippedLine = line.strip()
    if line != '':
        match = configLinePattern.search(line)
        if match:
            key = match.group(1).upper() 
            value = match.group(2)
            ldapConfig[key] = value

if not 'URI' in ldapConfig:
    print('No URI configured in ldap.conf')
    sys.exit(1)

c = ldap.initialize(ldapConfig['URI'])
c.simple_bind_s(adminDN, config['top']['adminpassword'])

searchResultId = c.search(suffix, ldap.SCOPE_SUBTREE, ldapSearchFilter, ['uid'])
while True:
    t, d = c.result(searchResultId, 0)
    if d == []:
        break;
    if t == ldap.RES_SEARCH_ENTRY:
        dn, attr = d[0]
        uid = attr['uid'][0].decode('utf-8')
        for user in config['users']:
            if user['uid'] == uid:
                proc = subprocess.Popen(['smbpasswd', '-a', user['uid']], stdin = subprocess.PIPE)
                out, err = proc.communicate(('%s\n%s\n' % (user['password'], user['password'])).encode('utf-8'))
                if out != None:
                    print(out)
c.unbind_s()
