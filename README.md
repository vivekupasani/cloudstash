# **CloudStash - The Ultimate Photo Vault**

**CloudStash** is a powerful backend system designed to securely store and manage photos. Built using **Flutter**,**Node.js**, **Express.js**, and **MongoDB**, CloudStash provides a fast and reliable cloud storage solution for users to upload, manage, and store images securely. With **Cloudinary** integration for media storage, CloudStash ensures smooth, high-performance image handling.

## 📱 **Features**

- 🔒 **User Authentication**: Secure user login and registration using JWT tokens.
- 📸 **Media File Uploads**: Upload and store images securely in Cloudinary.
- 🌐 **RESTful API Endpoints**: Expose API endpoints for user registration, login, image upload, and profile management.
- 💾 **MongoDB Integration**: Store user data and image references in MongoDB for scalability and performance.
- ⚡ **Performance Optimized**: Efficient asynchronous processing and database queries for fast and reliable performance.

## 🛠️ **Built With**

### **Core Technologies**
- **Flutter**: For cross-platform app development.
- **Bloc (flutter_bloc)**: Manages app state with the BLoC pattern.
- **Node.js**: JavaScript runtime for building the backend API.
- **Express.js**: Web framework for building RESTful APIs.
- **MongoDB**: NoSQL database for scalable data storage.
- **Firebase**: Cloud-based file storage for secure media handling.

### **Additional Packages**
- **jsonwebtoken (JWT)**: Manages user authentication and token generation.
- **bcryptjs**: Hashes passwords for secure storage.
- **mongoose**: MongoDB ODM for data modeling and interaction.
- **dotenv**: Loads environment variables for secure API configuration.
- **cors**: Manages cross-origin resource sharing for secure API requests.

### **Flutter Integration (Frontend)**
CloudStash can be integrated with a **Flutter** frontend for seamless mobile or web applications. This enables a full-stack solution with image upload and user management.

## 📦 **Installation**

1. **Clone the repository**:
   ```bash
   git clone https://github.com/vivekupasani/cloudstash.git
   cd cloudstash
2. **Install dependencies**:
   ```bash
   npm install
3. **Set up environment variables**:
   ```bash
   MONGO_URI=your_mongodb_connection_string
   CLOUDINARY_URL=your_cloudinary_url
   JWT_SECRET=your_jwt_secret_key
4. **Run the server**:
   ```bash
   npm start

## 🤝 Contributing

Contributions are welcome! If you have ideas or suggestions, feel free to open an issue or submit a pull request.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/YourFeature`
3. Commit your changes: `git commit -m 'Add a new feature'`
4. Push to the branch: `git push origin feature/YourFeature`
5. Open a pull request

## 🔐 License

Distributed under the MIT License. See `LICENSE` for more information.

---

Enjoy sharing moments with **Cloudstash**!
