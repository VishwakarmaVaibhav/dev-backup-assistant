-- Install.app Logic
-- This script finds the bundled scripts folder and runs start-server.sh silently
-- It avoids opening any terminal window.

set myPath to POSIX path of (path to me)
-- When run as .app, path is .../Install.app/
-- We need to go up one level to find the root folder where scripts/ is located

-- Display Welcome Message
display dialog "Welcome to Backup Pro!

Starting the Setup Interface..." buttons {"OK"} default button "OK" with title "Backup Pro" with icon note giving up after 5

set scriptPath to myPath & "../scripts/start-server.sh"
set rootPath to myPath & ".."

try
	-- Make sure scripts are executable and run
	do shell script "chmod +x \"" & scriptPath & "\" && \"" & scriptPath & "\""
on error errMsg
	-- If it fails, show helpful instructions
	display dialog "Setup couldn't start automatically.

Please open Terminal and run:
cd " & rootPath & " && ./install.sh && node setup-server.js

Error: " & errMsg buttons {"OK"} default button "OK" with title "Backup Pro - Help" with icon caution
end try

