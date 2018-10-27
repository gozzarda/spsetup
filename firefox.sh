#!/bin/bash

# Set Firefox homepage to http://contest.sppregional.org
cat << EOF_FIREPREFS > /usr/lib/firefox-esr/defaults/pref/all.corp.js
pref("browser.startup.homepage_override.mstone", "ignore", locked);
pref("browser.startup.homepage", "http://contest.sppregional.org", locked);
EOF_FIREPREFS
