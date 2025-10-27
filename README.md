# Krishi Ariv - Agricultural Assistant App

A Flutter mobile application designed to provide agricultural assistance and guidance to farmers in Kerala, India.

## Features

### 🏠 Homepage (Main Chat Interface)
- **App Bar**: Displays "KRISHI MITHRA" with notification and profile buttons
- **Greeting**: Personalized greeting in Malayalam ("നമസ്കാരം, {User Name}")
- **Input Bar**: Multi-modal input with text, image, file, and voice options
- **Background**: Beautiful green gradient representing agricultural theme
- **Feedback Button**: Quick access to send feedback

### 🔔 Notifications Page
- List of agricultural alerts, advisories, and system updates
- Real-time notification display with timestamps
- Interactive notification cards

### 👤 Profile Page
- **Personal Details**: Editable user information (Name, Phone, Crop Details)
- **Account Information**: Non-editable account ID display
- **Nearest Krishi Officer**: Contact details of local agricultural officer
- **Save Changes**: Update profile functionality

### 🎤 Voice Recording Page
- **Voice Input**: Record voice queries for agricultural assistance
- **Real-time Timer**: Track recording duration
- **Visual Feedback**: Animated microphone with pulsing effect
- **Recording Controls**: Start/stop recording with confirmation dialog

### 💬 Feedback Page
- **Feedback Form**: Multi-line text input for user feedback
- **Form Validation**: Ensures meaningful feedback submission
- **Submission Status**: Loading states and success confirmation

## Technical Implementation

### Dependencies
- `image_picker`: For gallery image selection
- `file_picker`: For document/file selection
- `permission_handler`: For device permissions
- `audioplayers`: For voice recording functionality
- `path_provider`: For file system access
- `http`: For API communication

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── homepage.dart         # Main chat interface
│   ├── notifications_page.dart
│   ├── profile_page.dart
│   ├── voice_recording_page.dart
│   └── feedback_page.dart
└── widgets/                  # Reusable UI components
```

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Krishi-Mithra
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

The app is designed to work with a backend API. Update the API endpoints in the respective screen files to connect to your backend service.

## Design Specifications

### Color Scheme
- **Primary Green**: `#4A7C59` (Olive green)
- **Secondary Green**: `#6B8E6B` (Medium green)
- **Light Green**: `#8FBC8F` (Light green)
- **Accent Colors**: White, Grey tones

### Typography
- **Primary Font**: Roboto
- **Malayalam Support**: Built-in support for Malayalam text
- **Font Weights**: Regular, Medium, Bold

### UI Components
- **Cards**: Rounded corners (12px radius)
- **Buttons**: Elevated buttons with green theme
- **Input Fields**: Outlined text fields with focus states
- **Icons**: Material Design icons with consistent sizing

## Backend Integration

The app is designed to integrate with the existing FastAPI backend (`app.py`) for:
- Query processing and LLM responses
- User authentication and profile management
- Notification management
- Feedback collection

## Future Enhancements

- [ ] Real image background integration
- [ ] Push notifications
- [ ] Offline mode support
- [ ] Multi-language support
- [ ] Advanced voice recognition
- [ ] Image processing for crop disease detection
- [ ] Weather integration
- [ ] Market price updates

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is part of the Krishi Mithra agricultural assistance initiative.
