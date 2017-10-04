#!/bin/bash

# Set Firefox homepage to http://domserver.cosc.canterbury.ac.nz/public/
cat << EOF_FIREPREFS > /usr/lib/firefox/defaults/pref/all.corp.js
user_pref("browser.startup.homepage_override.mstone", "ignore");
lockPref("browser.startup.homepage","http://domserver.cosc.canterbury.ac.nz/public/");
EOF_FIREPREFS
