
dn: ou=Groups,dc=ibm,dc=com
changetype: add
objectclass: organizationalUnit
ou: Groups

# Add People OU
dn: ou=People,dc=ibm,dc=com
changetype: add
objectclass: organizationalUnit
ou: People

# Add users
dn: uid=demo,ou=People,dc=ibm,dc=com
changetype: add
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
uid: demo
displayname: demo
sn: demo
cn: demo
mail: demo@ibm.com
userpassword: P4ssw0rd!

dn: uid=dev,ou=People,dc=ibm,dc=com
changetype: add
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
uid: dev
displayname: dev
sn: dev
cn: dev
mail: dev@ibm.com
userpassword: P4ssw0rd!

dn: uid=test,ou=People,dc=ibm,dc=com
changetype: add
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
uid: test
displayname: test
sn: test
cn: test
mail: test@ibm.com
userpassword: P4ssw0rd!

dn: uid=prod,ou=People,dc=ibm,dc=com
changetype: add
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
uid: prod
displayname: prod
sn: prod
cn: prod
mail: prod@ibm.com
userpassword: P4ssw0rd!

dn: uid=boss,ou=People,dc=ibm,dc=com
changetype: add
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
uid: boss
displayname: boss
sn: boss
cn: boss
mail: boss@ibm.com
userpassword: P4ssw0rd!

dn: uid=nik,ou=People,dc=ibm,dc=com
changetype: add
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
uid: nik
displayname: NiklausHirt
sn: nik
cn: nik
mail: nik@ibm.com
userpassword: P4ssw0rd!

dn: uid=sre1,ou=People,dc=ibm,dc=com
changetype: add
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
uid: sre1
displayname: sre1
sn: sre1
cn: sre1
mail: sre1@ibm.com
userpassword: P4ssw0rd!

dn: uid=sre2,ou=People,dc=ibm,dc=com
changetype: add
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
uid: sre2
displayname: sre2
sn: sre2
cn: sre2
mail: sre2@ibm.com
userpassword: P4ssw0rd!


# Create user group
dn: cn=demo,ou=Groups,dc=ibm,dc=com
changetype: add
cn: demo
objectclass: groupOfUniqueNames
objectclass: top
owner: cn=admin,dc=ibm,dc=com
uniquemember: uid=demo,ou=People,dc=ibm,dc=com
uniquemember: uid=dev,ou=People,dc=ibm,dc=com
uniquemember: uid=prod,ou=People,dc=ibm,dc=com
uniquemember: uid=test,ou=People,dc=ibm,dc=com
uniquemember: uid=boss,ou=People,dc=ibm,dc=com
uniquemember: uid=nik,ou=People,dc=ibm,dc=com

# Create user group
dn: cn=dev,ou=Groups,dc=ibm,dc=com
changetype: add
cn: dev
objectclass: groupOfUniqueNames
objectclass: top
owner: cn=admin,dc=ibm,dc=com
uniquemember: uid=dev,ou=People,dc=ibm,dc=com

# Create user group
dn: cn=test,ou=Groups,dc=ibm,dc=com
changetype: add
cn: test
objectclass: groupOfUniqueNames
objectclass: top
owner: cn=admin,dc=ibm,dc=com
uniquemember: uid=test,ou=People,dc=ibm,dc=com

# Create user group
dn: cn=prod,ou=Groups,dc=ibm,dc=com
changetype: add
cn: prod
objectclass: groupOfUniqueNames
objectclass: top
owner: cn=admin,dc=ibm,dc=com
uniquemember: uid=prod,ou=People,dc=ibm,dc=com





