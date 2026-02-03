# Newsly

A modern Flutter application for browsing and reading news articles. Built with Material Design 3, Newsly provides a sleek and intuitive interface to stay updated with the latest news from various sources.

## Features

- **News Fetching**: Retrieve real-time news articles from reliable APIs.
- **Card-Based UI**: Display news in visually appealing cards for easy browsing.
- **Shimmer Loading**: Smooth loading animations for a better user experience.
- **Sharing**: Share news articles directly from the app.
- **URL Launching**: Open articles in external browsers.
- **Modern Design**: Utilizes Material 3 design principles with Google Fonts for a professional look.
- **Environment Configuration**: Secure API key management using environment variables.

## Installation

### Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio or VS Code with Flutter extensions

### Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/newsly.git
   cd newsly
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the root directory and add your API key:

   ```
   NEWS_API_KEY=your_api_key_here
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Usage

- Launch the app on your device or emulator.
- Browse through the latest news articles on the home page.
- Tap on a news card to read more or share the article.

## Dependencies

- `flutter`: The Flutter framework.
- `http`: For making HTTP requests to fetch news data.
- `flutter_dotenv`: To load environment variables securely.
- `url_launcher`: To open URLs in external browsers.
- `google_fonts`: For modern typography.
- `shimmer`: For loading animations.
- `share_plus`: For sharing functionality.
- `cupertino_icons`: For iOS-style icons.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with Flutter and Dart.
- News data provided by [NewsAPI](https://newsapi.org/) or similar services.
- Icons and fonts from Google Fonts and Material Icons.
