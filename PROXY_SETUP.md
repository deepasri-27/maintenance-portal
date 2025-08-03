# SAP Maintenance Portal - Proxy Setup

This document explains how to run the Maintenance Portal with a local proxy to bypass CORS issues.

## 🚀 Quick Start

### Option 1: Using the Development Server (Recommended)

1. **Install Dependencies**:
   ```bash
   npm install
   ```

2. **Build Flutter Web App**:
   ```bash
   flutter build web
   ```

3. **Start Development Server**:
   ```bash
   npm start
   ```

4. **Access the App**:
   - App: http://localhost:3000
   - SAP API Proxy: http://localhost:3000/sap

### Option 2: Using Scripts

**Windows (Batch)**:
```bash
dev_server.bat
```

**PowerShell**:
```powershell
.\dev_server.ps1
```

## 🔧 How It Works

### Proxy Configuration
The development server uses Express.js with `http-proxy-middleware` to:

1. **Serve Flutter Web App**: Static files from `build/web/`
2. **Proxy SAP API**: All requests to `/sap/*` are proxied to `http://AZKTLDS5CP.kcloud.com:8000`
3. **Add Authentication**: Automatically adds Basic Auth headers
4. **Bypass CORS**: Requests appear to come from the same origin

### Authentication
- **SAP Username**: `K901554`
- **SAP Password**: `Deepasri@27`
- **Basic Auth**: Automatically added to all SAP API requests

## 📁 File Structure

```
maintenance_portal/
├── web/
│   ├── dev_server.js          # Express.js development server
│   ├── index.html             # Flutter web entry point
│   └── proxy.conf.json        # Proxy configuration
├── package.json               # Node.js dependencies
├── dev_server.bat            # Windows batch script
├── dev_server.ps1            # PowerShell script
└── PROXY_SETUP.md           # This documentation
```

## 🔍 API Endpoints

### SAP OData Login
- **URL**: `http://localhost:3000/sap/sap/opu/odata/SAP/ZPM_MAINT54_PORTAL_SRV/LoginSet(MaintenanceEngineer='{engineerId}',Password='{password}')?$format=json`
- **Method**: GET
- **Headers**: Basic Authentication automatically added

### Test Credentials
- **Engineer ID**: `00000001`
- **Password**: `MAIN@1`

## 🛠️ Development

### Adding New API Endpoints
1. Update `web/dev_server.js` to add new proxy routes
2. Update `lib/features/auth/data/datasources/login_remote_datasource.dart` to use the new endpoints

### Troubleshooting

**Port Already in Use**:
- Change `PORT` in `web/dev_server.js`
- Update all references to the new port

**Proxy Errors**:
- Check SAP server connectivity
- Verify Basic Auth credentials
- Check network firewall settings

**CORS Still Blocked**:
- Ensure you're accessing via `http://localhost:3000`
- Check browser console for errors
- Verify proxy is running

## 🚀 Production Deployment

For production, you should:

1. **Remove Proxy**: Use direct SAP API calls
2. **Configure CORS**: Add proper CORS headers to SAP server
3. **Use HTTPS**: Secure all communications
4. **Environment Variables**: Store credentials securely

## 📝 Notes

- This setup is for **development only**
- The proxy automatically handles Basic Authentication
- All SAP API calls go through the proxy
- CORS issues are completely bypassed
- Works with any SAP OData service

## 🎯 Benefits

✅ **No CORS Issues**: All requests appear from same origin  
✅ **Automatic Auth**: Basic Auth headers added automatically  
✅ **Easy Development**: Simple npm start command  
✅ **Cross-Platform**: Works on Windows, Mac, Linux  
✅ **Hot Reload**: Changes reflect immediately  
✅ **Debug Support**: Full error logging and debugging 