
# EcoTrack Blueprint\n\n## Overview\n\nEcoTrack is a mobile application designed to empower users to track their recycling habits, view their environmental impact, and discover recycling best practices. The app provides a user-friendly interface for registering recycled materials, visualizing personal statistics, and finding local recycling points.\n\n## Implemented Features\n\n### Authentication\n\n*   **User Registration:** New users can sign up with their name, email, and password.\n*   **User Login:** Existing users can sign in with their email and password.\n*   **Session Management:** The app securely manages user sessions, keeping them logged in until they explicitly log out.\n
### Home Screen

*   **Personalized Greeting:** The screen welcomes the user with a "Hola, \[user name]" message.
*   **2x2 Grid Layout:** A visually appealing grid of four large, square buttons provides access to the main features.
*   **Button Styling:** Buttons use the app's primary color scheme (`deepPurple`) and feature prominent icons and bold text for clarity.
*   **Logout:** A logout button is conveniently located in the `AppBar`.

### Core Features

*   **Recycling Registration:** A dedicated screen allows users to log the types and quantities of materials they recycle.
    *   **Material Types:** The selectable materials are: 'Plástico', 'Papel/cartón', 'Metal', 'Vidrio', 'Tela', and 'Tetra brik'.
    *   **Recycling Locations:** The selectable locations are: 'Casco urbano', 'Abasto', 'City Bell', 'Etcheverry', 'Gonnet', 'Gorina', 'Hernández', 'La Hermosura', 'Olmos', 'Romero', 'San Lorenzo', 'Sicardi', 'Tolosa', 'Villa Castells', 'Villa Elisa', and 'Villa Elvira'.
    *   **Data Persistence:** When a user registers a recycled material, their total points and weight are atomically updated in the Firestore database.
    *   **Continuous Submission:** After a successful submission, the form clears automatically, allowing the user to quickly register another item without leaving the screen.
*   **Statistics:** Users can view their recycling history and performance through charts and data visualizations.
*   **Recycling Tips:** A screen provides helpful tips and best practices for recycling.
*   **Recycling Points:** Users can find nearby recycling centers and drop-off locations.

### Theming

*   **Material Design 3:** The app uses the latest Material Design guidelines for a modern look and feel.
*   **Light & Dark Modes:** A theme provider allows users to switch between light and dark themes, or follow the system setting.
*   **Custom Fonts:** The `google_fonts` package is used for a unique and readable typography.

## Current Plan

*   **Implement functionality for the three remaining feature screens:** Statistics, Recycling Tips, and Recycling Points.
*   **Connect the app to a Firebase backend** to store and retrieve user data, recycling logs, and other relevant information.
*   **Flesh out the UI/UX** for each screen to ensure a polished and intuitive user experience.
*   **Home Screen Layout:** The positions of the "Recycling Tips" and "Recycling Points" buttons have been swapped for better user flow.
