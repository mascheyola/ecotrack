
# EcoTrack App Blueprint

## Overview

EcoTrack is a Flutter application designed to encourage and track recycling efforts. Users can register their recycled materials, accumulate reward points, and view statistics on their environmental impact. The app is built with Flutter and Firebase, providing a secure and scalable backend for data persistence and user management.

## Features

### User Authentication
- **Registration:** New users can create an account using their email and password. User data, including name and email, is stored in Firestore.
- **Login:** Registered users can sign in to access their personalized data and features.
- **Persistent Sessions:** The app maintains user sessions, so users don't have to log in every time they open the app.

### Recycling Tracking
- **Material Registration:** Users can record the type, weight, and location of recycled materials.
- **Reward Points:** For each recycled item, users earn points based on the weight of the material.
- **Data Persistence:** All recycling records are stored in Firestore, linked to the user's account.

### Statistics and Rewards
- **Personalized Statistics:** Users can view a summary of their recycling efforts, including the total weight of materials recycled and the total reward points earned.
- **Recycling Points:** The app displays the current balance of reward points.
- **Detailed Reports:** The statistics screen provides a breakdown of recycled materials by type.

### Additional Features
- **Recycling Tips:** A dedicated screen offers helpful tips and best practices for recycling.
- **Recycling Points Screen:** Users can check their accumulated points at any time.

## Technical Architecture

### Frontend
- **Framework:** Flutter
- **UI:** Material Design
- **State Management:** `StreamBuilder` for real-time data updates from Firestore.

### Backend
- **Authentication:** Firebase Authentication for secure user management.
- **Database:** Firestore for storing user profiles, recycling data, and reward points.
- **Hosting:** Firebase Hosting for deploying the web version of the app.

## Current Implementation Plan

### 1. **Firebase Integration**
- **Dependencies:** Added `firebase_core`, `firebase_auth`, and `cloud_firestore`.
- **Configuration:** Set up a new Firebase project and configured the app with the necessary credentials.
- **Initialization:** Ensured Firebase is initialized at app startup.

### 2. **Authentication Flow**
- **Login/Register Screens:** Created UI for user login and registration.
- **Auth Wrapper:** Implemented a wrapper to manage user sessions and route users to the appropriate screen (login or home).
- **Firebase Auth:** Integrated Firebase Authentication to handle user creation and sign-in.

### 3. **Firestore Database**
- **Data Models:** Structured the database with collections for `users` and `recycling`.
- **Data Writing:** Implemented logic to save user data upon registration and to record new recycling entries.
- **Data Reading:** Fetched and displayed user-specific data on the home and statistics screens.

### 4. **UI/UX Enhancements**
- **Real-time Updates:** Used `StreamBuilder` to ensure that user data and statistics are updated in real-time.
- **User Feedback:** Provided feedback to the user during login, registration, and data submission.
- **Navigation:** Set up routes for all screens and ensured smooth navigation between them.

This blueprint provides a comprehensive overview of the EcoTrack app, its features, and the technical implementation. It will be updated as new features are added or existing ones are modified.
