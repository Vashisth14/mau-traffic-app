# 🚦 MAU-Traffic  
### Automated Accident Monitoring in Mauritius from Social Media Posts

MAU-Traffic is a mobile-based intelligent accident monitoring system designed for Mauritius.  
The system integrates **user-reported incidents** and **Facebook social media data** to provide real-time traffic monitoring using **AI-based text analysis and location intelligence**.

---

## 📌 Project Overview

Road accidents remain a major concern in Mauritius, with traditional reporting systems often being slow and reactive.  

This project introduces a **real-time monitoring solution** that leverages:
- Social media (Facebook)
- Mobile reporting
- Natural Language Processing (NLP)

to detect, analyse, and visualise accident-related information.

---

## 🎯 Objectives

- Extract accident-related posts from Facebook  
- Detect accidents using text analysis  
- Extract location information from posts  
- Analyse sentiment to estimate severity  
- Allow users to report accidents via mobile app  
- Display incidents in a live feed and map view  

---

## 🏗️ System Architecture

The system follows a **client-server architecture**:

- 📱 **Frontend (Flutter App)**  
  - Accident reporting  
  - Live feed display  
  - Hotspot map visualisation  

- 🖥️ **Backend (Node.js + Express)**  
  - REST API  
  - Data processing  
  - Facebook integration  
  - NLP processing  

- 🧠 **NLP Engine**  
  - Keyword detection  
  - Sentiment analysis  
  - Location extraction  

- 🗄️ **Database (MongoDB)**  
  - Stores accident reports  
  - Stores social media posts  

---

## ⚙️ Technologies Used

### 🔹 Frontend
- Flutter  
- Dart  
- Flutter Riverpod  
- Google Maps Flutter  
- Image Picker  

### 🔹 Backend
- Node.js  
- Express.js  
- MongoDB  
- Mongoose  
- Axios  
- Multer  
- CORS  
- dotenv  

---

## 📂 Project Structure
mau-traffic-app/
│
├── frontend/ # Flutter mobile application
│ ├── lib/
│ ├── android/
│ ├── ios/
│ └── pubspec.yaml
│
├── backend/ # Node.js backend API
│ ├── config/
│ ├── models/
│ ├── routes/
│ ├── uploads/
│ ├── server.js
│ └── package.json
│
├── README.md
└── .gitignore


---

## 🚀 Setup Instructions

### 🔹 1. Clone Repository

git clone https://github.com/Vashisth14/mau-traffic-app.git
cd mau-traffic-app
🔹 2. Frontend Setup (Flutter)
cd frontend
flutter pub get
flutter run
🔹 3. Backend Setup (Node.js)
cd backend
npm install
node server.js
🔐 Environment Variables (Backend)

Create a .env file inside the backend folder:

PORT=5000
MONGO_URI=your_mongodb_connection_string
FB_PAGE_ID=your_facebook_page_id
FB_PAGE_ACCESS_TOKEN=your_facebook_access_token
PUBLIC_BASE_URL=http://localhost:5000
🔄 API Endpoints
📍 Accident Reports
Method	Endpoint	Description
POST	/api/accidents	Submit accident report
GET	/api/accidents	Retrieve all reports
📡 Social Media Feed
Method	Endpoint	Description
GET	/api/social-posts	Combined feed
POST	/api/social-posts/sync	Manual sync
🤖 AI / NLP Features

The system includes a lightweight NLP module to analyse text:

Accident detection (keyword-based)
Sentiment analysis (positive/negative)
Location extraction
Confidence scoring
📊 System Features
✔ Real-time accident monitoring
✔ Facebook integration
✔ Mobile-based reporting
✔ Image upload support
✔ Interactive map with hotspots
✔ Combined feed (social + user reports)
⚠️ Limitations
Uses rule-based NLP (not deep learning)
Limited dataset for evaluation
Depends on Facebook API availability
🔮 Future Improvements
Deep learning-based NLP models
Real-time notifications
Integration with more social platforms
Improved location accuracy
🎓 Academic Context

This project was developed as part of the dissertation:

Automated Accident Monitoring in Mauritius from Social Media Posts
(using AI based Location Intelligence and Analysis of Social Media Posts)

👤 Student: Vashistha Ittoo
🆔 Student ID: M01015177
👨‍🏫 Supervisor: Girish Bekaroo
🔗 GitHub Repository
👉 https://github.com/Vashisth14/mau-traffic-app
