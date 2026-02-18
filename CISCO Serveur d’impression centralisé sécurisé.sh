
# CREATION VLAN SERVEUR IMPRESSION
############################################
interface GigabitEthernet0/3
 nameif PRINT_SERVER
 security-level 80
 ip address 192.168.60.1 255.255.255.0
 no shutdown


# OBJETS RESEAUX
############################################
object network USERS_NET
 subnet 192.168.0.0 255.255.0.0

object network PRINT_SERVER
 host 192.168.60.10

object network PRINTER_NET
 subnet 192.168.50.0 255.255.255.0


# POLITIQUE D’ACCES UTILISATEURS -> SERVEUR
############################################
access-list USER_TO_SERVER extended permit tcp object USERS_NET object PRINT_SERVER eq 445
access-list USER_TO_SERVER extended permit tcp object USERS_NET object PRINT_SERVER eq 631
access-list USER_TO_SERVER extended permit tcp object USERS_NET object PRINT_SERVER eq 515

access-group USER_TO_SERVER in interface INSIDE


# POLITIQUE SERVEUR -> IMPRIMANTES
############################################
access-list SERVER_TO_PRINTER extended permit tcp object PRINT_SERVER object PRINTER_NET eq 9100
access-list SERVER_TO_PRINTER extended permit tcp object PRINT_SERVER object PRINTER_NET eq 515
access-list SERVER_TO_PRINTER extended permit tcp object PRINT_SERVER object PRINTER_NET eq 631

access-group SERVER_TO_PRINTER in interface PRINT_SERVER


# BLOQUER ACCES DIRECT USERS -> IMPRIMANTES
############################################
access-list BLOCK_DIRECT extended deny ip object USERS_NET object PRINTER_NET
access-group BLOCK_DIRECT in interface INSIDE


# SAUVEGARDE
############################################
write memory
