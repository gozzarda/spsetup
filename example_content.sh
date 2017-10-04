#!/bin/bash

# Cleanup example content, and place useful links instead
rm -r /usr/share/example-content/*
cat << EOF_DOMSERVER > /usr/share/example-content/domserver.desktop
[Desktop Entry]
Encoding=UTF-8
Name=DOMJudge Server
Type=Link
URL=http://domserver.cosc.canterbury.ac.nz/domjudge/team/
Icon=text-html
EOF_DOMSERVER
cat << EOF_BACKUPSERVER > /usr/share/example-content/backup_server.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Backup DOMJudge Server
Type=Link
URL=http://60.241.98.115/domjudge/team/
Icon=text-html
EOF_BACKUPSERVER
cat << EOF_DOCURL > /usr/share/example-content/documentation.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Language References
Type=Link
URL=http://domserver.cosc.canterbury.ac.nz/contestantdocs/
Icon=text-html
EOF_DOCURL
cat << EOF_SAMPLEDATA > /usr/share/example-content/Sample_Data.html
<!DOCTYPE HTML>
<html>
<head>
<title>Sample Data Links</title>
</head>
<body>
<ul>
<li><a href="http://domserver.cosc.canterbury.ac.nz/sampledata-west.zip">West</a></li>
<li><a href="http://domserver.cosc.canterbury.ac.nz/sampledata-east.zip">East</a></li>
<li><a href="http://domserver.cosc.canterbury.ac.nz/sampledata-central.zip">Central</a></li>
</ul>
</body>
</html>
EOF_SAMPLEDATA
