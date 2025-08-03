Write-Host "Starting Maintenance Portal Development Server with SAP Proxy..." -ForegroundColor Green
Write-Host ""

Write-Host "Building Flutter web app..." -ForegroundColor Yellow
flutter build web

Write-Host ""
Write-Host "Installing Node.js dependencies..." -ForegroundColor Yellow
npm install

Write-Host ""
Write-Host "Starting development server with proxy..." -ForegroundColor Green
Write-Host "SAP API will be available at: http://localhost:3000/sap" -ForegroundColor Cyan
Write-Host "App will be available at: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""
npm start 