-- Install.app Logic
-- This script finds the bundled scripts folder and runs start-server.sh silently
-- It avoids opening any terminal window.

set myPath to POSIX path of (path to me)
-- When run as .app, path is .../Install.app/
-- We need to go up one level to find the root folder where scripts/ is located
-- The .app is in the root folder alongside scripts/

-- Display Welcome Message
display dialog "Welcome to Backup Pro!

Starting the Setup Interface..." buttons {"OK"} default button "OK" with title "Backup Pro" with icon note giving up after 5

set scriptPath to myPath & "../scripts/start-server.sh"
do shell script "\"" & scriptPath & "\""
