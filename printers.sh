#!/bin/bash

# Setup printers
apt-get update
apt-get -y install cups
# THIS IS A TEST CONFIGURATION FILE FOR PRINTING AT UWA
# PLEASE MODIFY THIS
# PLACE THE PRINTER'S PPD IN /etc/cups/ppd/ IF NECESSARY
cat << EOF_PRINTER > /etc/cups/printers.conf
# Printer configuration file for CUPS v2.1.3
# Written by cupsd
# DO NOT EDIT THIS FILE WHEN CUPSD IS RUNNING
<DefaultPrinter HP-LaserJet-4350>
UUID urn:uuid:67191948-1c7e-3ffe-6696-d9c3bd451062
AuthInfoRequired none
Info HP LaserJet 4350
Location Lab 2.05
MakeModel HP LaserJet 4350 Postscript (recommended)
DeviceURI ipp://130.95.116.32
State Idle
StateTime 1507112136
ConfigTime 1507112131
Reason paused-error
Type 8425668
Accepting Yes
Shared Yes
ColorManaged Yes
JobSheets none none
QuotaPeriod 0
PageLimit 0
KLimit 0
OpPolicy default
ErrorPolicy retry-job
Attribute marker-colors none,none
Attribute marker-levels 96,34
Attribute marker-names Black Cartridge HP Q5942X,Maintenance Kit HP 110V-Q5421A, 220V-Q5422A
Attribute marker-types toner-cartridge,fuser
Attribute marker-change-time 1507112136
</DefaultPrinter>
EOF_PRINTER
