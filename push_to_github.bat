@echo off
chcp 65001 >nul
cd /d D:\LTM_FINALQ

echo ========================================
echo Pushing to GitHub...
echo ========================================

echo.
echo Step 1: Initializing git repository...
git init

echo.
echo Step 2: Adding all files...
git add .

echo.
echo Step 3: Committing changes...
git commit -m "Initial commit - Expense Tracker System"

echo.
echo Step 4: Adding remote repository...
git remote add origin https://github.com/MinhAnh248/LTM_FINALQ2.git

echo.
echo Step 5: Changing branch to main...
git branch -M main

echo.
echo Step 6: Pushing to GitHub...
echo Please enter your GitHub credentials when prompted...
git push -u origin main

echo.
echo ========================================
echo Done! Check https://github.com/MinhAnh248/LTM_FINALQ2
echo ========================================
pause
