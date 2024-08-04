#!/bin/bash

# Set Firefox homepage to http://contest.sppcontests.org
cat << EOF_FIREPREFS > /usr/lib/firefox-esr/defaults/pref/all.corp.js
pref("browser.startup.homepage_override.mstone", "ignore", locked);
pref("browser.startup.homepage", "http://contest.sppcontests.org", locked);
EOF_FIREPREFS
