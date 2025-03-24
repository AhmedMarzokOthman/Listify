@echo off
setlocal

:: Ask for the commit message
set /p commitMessage=Enter commit message: 

:: Initialize git if not already initialized
git init

:: Add all changes
git add .

:: Commit with the user's message
git commit -m "%commitMessage%"

:: Push to the repository
git push

endlocal