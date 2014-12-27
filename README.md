BSidesWpgCTF 2013
=================

This is the absolutely terrible website/backend we used to manage the 2013 CTF. No CGI, no proper server-side code.

Table of Contents
-----------

`challs/` contains the challenge files.

`flags/` contains text files with success or "keep trying" messages. Nginx was configured to return `err/nope.txt` if a request to `flags/` 404ed.
All of these responses were standardized and expected by the browser-side JavaScript.

`tablemaker.lua` was a Lua program that generated the CTF's scoreboard by slurping Nginx logs every 10 seconds.
