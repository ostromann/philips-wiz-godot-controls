@echo off
setlocal
set json_command={"id":1,"method":"setPilot","params":{"r":%1,"g":%2,"b":%3,"dimming":%4}}
echo %json_command% | "C:\\Program Files (x86)\\Nmap\\ncat.exe" -u -w 1 %5 38899
endlocal
