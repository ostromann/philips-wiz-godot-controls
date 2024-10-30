@echo off
setlocal
set json_command={"id":1,"method":"setState","params":{"state":true}}
echo %json_command% | "C:\\Program Files (x86)\\Nmap\\ncat.exe" -u -w 1 %1 38899
endlocal
