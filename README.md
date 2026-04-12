# 🚗 MAU-Traffic Mobile Application

## 📌 Overview

MAU-Traffic is a mobile application developed using Flutter that provides real-time monitoring of road accidents in Mauritius. The system integrates social media data and user-reported incidents, enhanced with AI-based analysis for accident detection and location extraction.

---

## 🎯 Features

* 📡 Live accident feed (Facebook + user reports)
* 🧠 AI-powered accident detection (NLP)
* 📍 Location extraction and mapping
* 🗺️ Hotspot visualization on Google Maps
* 📸 Accident reporting with image upload
* 📊 Daily summary and analytics
* 🔄 Pull-to-refresh functionality

---

## 🏗️ Architecture

The application follows a **feature-based clean architecture**:

```
lib/
├── features/
│   ├── fb_feed/
│   ├── hotspots/
│   ├── report/
│   └── home/
├── services/
├── shared/
```

---

## 🛠️ Technologies Used

* Flutter (UI Framework)
* Dart (Programming Language)
* Riverpod (State Management)
* Google Maps Flutter
* REST API Integration

---

## 📲 Screens

* Home Dashboard
* Live Feed
* Report Accident
* Hotspots & Map

---

## ⚙️ Setup Instructions

### 1. Clone the repository

```
git clone https://github.com/Vashisth14/mau-traffic-app.git
cd mau-traffic-app
```

### 2. Install dependencies

```
flutter pub get
```

### 3. Run the application

```
flutter run
```

---

## 🔗 API Configuration

Make sure the backend is running and update API base URL if needed:

```
http://10.0.2.2:5000   // Android Emulator
```

---

## 🧠 AI Integration

The frontend consumes NLP-processed data from the backend, including:

* Accident classification
* Confidence score
* Severity level
* Extracted locations

---

## 📌 Notes

* Works on Android emulator and real devices
* Requires internet connection
* Google Maps API key must be configured

---

## 👨‍💻 Author

Vashistha Ittoo
BSc (Hons) Computer Science
Middlesex University Mauritius
