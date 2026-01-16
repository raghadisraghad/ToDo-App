# Todo App - Flutter & Spring Boot

## 📱 What It Does
A full-featured todo app where users can:
- **Register** and **Login** with secure authentication
- **Add, Edit, Delete** tasks
- **Mark tasks as completed**
- **Bulk operations**: Delete all tasks / Mark all as complete
- **Profile management**: Update profile or delete account
- All data stored in **MySQL database**

## 🚀 Requirements to Run

### **Backend (Spring Boot):**
- **JDK 17+** (Java Development Kit)
- **MySQL** database (create database named `todo`)
- **Maven** (included in project)

### **Frontend (Flutter):**
- **Flutter SDK 3.0+**
- **Dart SDK 3.0+**
- **Android Studio / VS Code** with Flutter extension

## ⚡ How to Run

### **1. Start Backend (Spring Boot):**
```bash
cd spring_todo
mvn spring-boot:run
```
**Runs on:** `http://localhost:9191`

### **2. Start Frontend (Flutter):**
```bash
cd flutter_todo
flutter run
```
*(Open in new terminal window)*

## 📊 Database Setup
1. **Start MySQL**
2. **Create database:**
```sql
CREATE DATABASE todo;
```

## ⚠️ Important Notes
- **Run both applications simultaneously** in separate terminals
- Spring Boot must be running before Flutter starts
- Update database credentials in `application.properties`
- For Android emulator: Change Flutter `baseURL` to `http://10.0.2.2:9191`

## 🔧 If Connection Fails
1. Check Spring Boot is running on port 9191
2. Verify MySQL is running
3. Ensure correct `baseURL` in Flutter's `globals.dart`
4. **Both apps must be running at the same time**

## 🗂️ Project Structure
- `spring_todo/` - Spring Boot API
- `flutter_todo/` - Flutter mobile app
- Database: MySQL `todo`

---
**Run both apps → Test the features → All data saves to MySQL**