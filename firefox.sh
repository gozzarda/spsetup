#!/bin/bash

# Set Firefox homepage to http://contest.sppregional.org
cat << EOF_FIREPREFS > /usr/lib/firefox-esr/defaults/pref/all.corp.js
lockPref("browser.startup.homepage_override.mstone", "ignore");
lockPref("browser.startup.homepage","http://contest.sppregional.org");
EOF_FIREPREFS
