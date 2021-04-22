
Base DN: dc=ibm,dc=com
Bind DN: cn=admin,dc=ibm,dc=com

URL ldap://openldap.default:389

Group Filte: (&(cn=%v)(objectclass=groupOfUniqueNames))

G
Group ID map



Group filter
(&(cn=%v)(objectclass=groupOfUniqueNames))

Group ID map
*:cn

Group member ID map
groupOfUniqueNames:uniqueMember

User filter
(&(uid=%v)(objectclass=Person))

User ID map
*:uid