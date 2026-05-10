# Generator Fuel Management App

## Project Overview
This project is a Flutter mobile application developed for Continuous Assessment 3. The application helps factory managers monitor generator fuel usage, runtime hours, and fuel records during power outages.

The system allows users to:
- Add generator details
- Record fuel usage and runtime
- Calculate remaining fuel
- Generate fuel usage reports
- Forecast fuel requirements
- Store data permanently using SharedPreferences

---

# Features

## Generator Management
- Add generator name, code, fuel tank capacity, and fuel usage rate
- Display all generators in a list
- Swipe to delete generators

## Fuel & Runtime Tracking
- Record runtime hours
- Record added fuel amount
- Save fuel records with dates

## Reports
- View fuel usage reports
- Calculate remaining fuel
- Forecast future fuel requirements

## Data Storage
- Permanent local storage using SharedPreferences

## Testing
- Unit testing
- Widget testing
- Integration testing

---

# Technologies Used

- Flutter
- Dart
- SharedPreferences
- Android Studio
- GitHub

---

# Project Structure

lib/
- models/
- services/
- screen1_runtime_fuel.dart
- screen2_generator_list.dart
- screen3_add_generator.dart
- screen4_generator_details.dart
- screen5_app_info.dart
- screen6_report.dart

test/
- unit_test.dart
- widget_test.dart

integration_test/
- app_test.dart

---

# How to Run the Project

1. Install Flutter SDK
2. Open project in Android Studio or VS Code
3. Run:

```bash
flutter pub get