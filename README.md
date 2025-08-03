# SAP Maintenance Portal

A Flutter-based mobile application for SAP maintenance operations with real OData API integration.

## 🚀 Features

### Authentication
- **SAP OData Integration**: Real authentication using SAP OData service
- **Engineer ID Login**: Secure login with Engineer ID and password
- **Error Handling**: Comprehensive error handling for network and authentication issues
- **State Management**: Provider-based state management for login state

### Dashboard
- **Overview Metrics**: Real-time display of ticket counts and asset information
- **Responsive Design**: Adapts to different screen sizes
- **Navigation Drawer**: Easy access to all app sections

### Ticket Management
- **Ticket List**: View all maintenance tickets with status indicators
- **Ticket Details**: Comprehensive ticket information with update capabilities
- **Create Tickets**: Form-based ticket creation with validation
- **Status Tracking**: Open → In Progress → Resolved workflow

### User Profile
- **User Information**: Display engineer details
- **Logout Functionality**: Secure logout with state cleanup

## 🏗️ Architecture

The app follows **Clean Architecture** with feature-based organization:

```
lib/
├── core/                    # Shared utilities
│   ├── constants/          # App colors, theme, dimensions
│   └── widgets/            # Reusable UI components
├── features/               # Feature modules
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Data layer (API, models)
│   │   ├── domain/        # Business logic (repositories, usecases)
│   │   └── presentation/  # UI layer (screens, providers)
│   ├── dashboard/         # Dashboard feature
│   ├── tickets/           # Ticket management
│   └── profile/           # User profile
└── main.dart              # App entry point
```

## 🔧 SAP OData Integration

### API Endpoint
```
GET http://AZKTLDS5CP.kcloud.com:8000/sap/opu/odata/SAP/ZPM_MAINT54_PORTAL_SRV/LoginSet(MaintenanceEngineer='{engineerId}',Password='{password}')?$format=json
```

### Response Format
```json
{
  "d": {
    "__metadata": {
      "id": "http://AZKTLDS5CP.kcloud.com:8000/sap/opu/odata/SAP/ZPM_MAINT54_PORTAL_SRV/LoginSet(MaintenanceEngineer='00000001',Password='VALID')",
      "uri": "http://AZKTLDS5CP.kcloud.com:8000/sap/opu/odata/SAP/ZPM_MAINT54_PORTAL_SRV/LoginSet(MaintenanceEngineer='00000001',Password='VALID')",
      "type": "ZPM_MAINT54_PORTAL_SRV.login"
    },
    "MaintenanceEngineer": "00000001",
    "Password": "VALID"
  }
}
```

### Error Handling
- **401**: Invalid credentials
- **404**: Service not found
- **500**: Server error
- **Network**: Connection issues
- **Timeout**: Request timeout (30 seconds)

## 🎨 Design System

### Color Palette
- **Primary**: Orange (`#FF6F00`) - Main brand color
- **Secondary**: Light Orange (`#FFA726`) - Supporting color
- **Background**: White (`#FFFFFF`)
- **Surface**: Light Gray (`#F5F5F5`)
- **Text**: Dark (`#333333`) and Light (`#999999`)
- **Error**: Red (`#D32F2F`)

### Typography
- **Font Family**: Roboto
- **Material Design 3**: Modern design system

## 📱 Getting Started

### Prerequisites
- Flutter SDK ^3.6.2
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd maintenance_portal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Testing

Run the test suite:
```bash
flutter test
```

Run specific tests:
```bash
flutter test test/auth_integration_test.dart
```

## 🔐 Authentication Flow

1. **Login Screen**: Enter Engineer ID and Password
2. **API Call**: Validates credentials against SAP OData service
3. **Success**: Navigate to Dashboard
4. **Error**: Display error message with retry option

### Test Credentials
- **Engineer ID**: `00000001`
- **Password**: `1234` or `VALID`

## 📊 State Management

The app uses **Provider** for state management:

- **LoginProvider**: Manages authentication state
- **Loading States**: Shows progress indicators
- **Error Handling**: Displays user-friendly error messages
- **Logout**: Clears all state and returns to login

## 🛠️ Development

### Adding New Features
1. Create feature folder in `lib/features/`
2. Follow Clean Architecture pattern
3. Add tests for new functionality
4. Update documentation

### API Integration
1. Add data models in `data/models/`
2. Create datasource in `data/datasources/`
3. Implement repository in `domain/repositories/`
4. Create usecase in `domain/usecases/`
5. Add provider in `presentation/providers/`

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📝 Dependencies

- **http**: ^0.13.6 - HTTP requests
- **provider**: ^6.1.1 - State management
- **font_awesome_flutter**: ^10.6.0 - Icons
- **flutter_lints**: ^5.0.0 - Code quality

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Add tests
5. Submit pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

**Built with ❤️ using Flutter and SAP OData**
