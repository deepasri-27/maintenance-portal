@echo off
echo Starting Maintenance Portal Development Server with SAP Proxy...
echo.

echo Building Flutter web app...
flutter build web

echo.
echo Installing Node.js dependencies...
npm install

echo.
echo Starting development server with proxy...
echo SAP API will be available at: http://localhost:3000/sap
echo App will be available at: http://localhost:3000
echo.
npm start 