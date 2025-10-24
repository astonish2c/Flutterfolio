## FlutterFolio

FlutterFolio is a Flutter app that lets users watch live cryptocurrency prices, add them to their portfolio, and track their overall crypto collection.
It uses **Firebase** as the backend with features like **user authentication** and **email verification**.

---

### Features

* View live crypto prices
* Add and remove coins from your portfolio
* Track your portfolio’s total value
* Firebase authentication (sign up, login, email verification)
* Cloud Firestore for real-time data storage

---

### Tech Stack

* **Flutter**
* **Firebase Authentication**
* **Cloud Firestore**
* **Provider**

---

### Installation

1. Clone the repository

   ```bash
   git clone https://github.com/astonish2c/FlutterFolio.git
   ```
2. Go into the project folder

   ```bash
   cd FlutterFolio
   ```
3. Install dependencies

   ```bash
   flutter pub get
   ```
4. Run the app

   ```bash
   flutter run
   ```

---

### Firebase Setup

1. Create a new project in [Firebase Console](https://console.firebase.google.com/).
2. Add your Android/iOS app.
3. Download and place:

   * `google-services.json` in `android/app/`
   * `GoogleService-Info.plist` in `ios/Runner/`
4. Enable **Authentication** (Email/Password) and **Cloud Firestore**.

---

### License

This project is licensed under the MIT License.


