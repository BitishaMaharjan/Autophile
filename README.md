# Please USE THE below .env in the assets/.env
NEWS_API_KEY=your-news-api-key
Link to newsapi = https://newsapi.org/


# Autophile

**Autophile** is your ultimate car encyclopedia, designed as a comprehensive platform for car enthusiasts. The app provides detailed car specifications, 3D car models, camera-based car detection, and the latest car news while connecting car enthusiasts worldwide.

---

## 🚀 Features

- **Global Car Database**: Access detailed specifications for cars from all over the world.
- **3D Car Models**: Visualize cars in an interactive 3D environment.
- **Camera Scan Feature**: Identify cars using your phone’s camera and get instant details.
- **User Reviews & Ratings**: Share and discover insights from a global car enthusiast community.
- **Car News**: Stay updated with the latest trends and updates in the automotive industry.
- **Social Community**: Interact with car lovers, share experiences, and join the conversation.

---

## 📱 Tech Stack

### **Frontend**
- **Framework**: [Flutter](https://flutter.dev/) - Cross-platform development for iOS and Android.

### **Backend**
- **Database**: [Firebase Firestore](https://firebase.google.com/products/firestore) - Real-time and scalable database.
- **File Storage**: [Firebase Storage](https://firebase.google.com/products/storage) - Store user-uploaded images and 3D model files.

### **APIs**
- **News**: [NewsAPI](https://newsapi.org/) - Get the latest automotive news.

### **3D Modeling**
- **Tools**: [Blender](https://www.blender.org/) - Create interactive 3D car models.

### **Machine Learning**
- **Framework**: [TensorFlow Lite](https://www.tensorflow.org/lite) - On-device car detection using machine learning models.

---

## 🌟 Installation

Follow these steps to set up and run Autophile on your local machine:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/racerfire321/Autophile.git
   cd Autophile
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

---

## 🗂 Folder Structure

```plaintext
Autophile/
├── lib/
│   ├── core/             # Core utilities and constants
│   ├── features/         # Feature-specific modules
│   │   ├── car_database/ # Car database-related functionality
│   │   ├── news/         # News feature
│   │   ├── community/    # Social community modules
│   │   └── scan/         # Camera scan feature
│   ├── models/           # Data models
│   ├── services/         # API services and business logic
│   ├── widgets/          # Reusable components
│   └── main.dart         # App entry point
├── assets/               # Images, icons, and 3D models
├── test/                 # Unit and widget tests
└── pubspec.yaml          # Project dependencies
```

---

## 📖 Documentation

### **Camera Scan Feature**
Use the camera to detect cars and retrieve their specifications in real-time.

### **3D Car Models**
Interact with Blender-created car models within the app, simulating a virtual showroom experience.

---

## 👥 Contributing

We welcome contributions to improve Autophile! To get started:

1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature/<feature-name>
   ```
3. Commit your changes:
   ```bash
   git commit -m "feat: <feature-name>"
   ```
4. Push to the branch:
   ```bash
   git push origin feature/<feature-name>
   ```
5. Open a pull request.

---


## 📝 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🤝 Contact

For any inquiries or feedback, reach out at **racerfire321@gmail.com** or open an issue on [GitHub](https://github.com/racerfire321/Autophile/issues).

---

Thank you for using Autophile! 🚗
