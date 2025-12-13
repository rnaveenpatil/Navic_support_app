# 🌍 NAVIC – Advanced GNSS & NavIC Analyzer

> **An intelligent Flutter-based Android application that detects, analyzes, and visualizes NavIC (IRNSS) and global GNSS satellite signals in real time.**

---

## 🚀 What is NAVIC?

**NAVIC** is a **research‑oriented GNSS diagnostic & navigation app** built using **Flutter** with **native Android (Java)** integration. It focuses on **India’s NavIC (IRNSS)** system while seamlessly supporting **GPS, Galileo, BeiDou, GLONASS, QZSS, and SBAS**.

The app intelligently detects **hardware capability**, **processor compatibility**, **frequency band support (L5 & S‑band)**, and **real‑time satellite availability**, then visualizes everything on **OpenStreetMap (OSM)**.

---

## ✨ Key Highlights

✅ Native‑level GNSS access using **Android GNSS APIs**
✅ Advanced **NavIC hardware & chipset detection**
✅ **L5 & S‑band verification** (capability + real usage)
✅ Real‑time **satellite tracking & signal analysis**
✅ **OpenStreetMap (OSM)** based live location visualization
✅ Works as a **GNSS diagnostic tool** for students & researchers

---

## 🧠 How the App Works (Flow)

```text
App Launch
   ↓
Request Location Permission
   ↓
Check GNSS Hardware Availability
   ↓
Detect Processor / Chipset Type
   ↓
Verify NavIC (IRNSS) Support
   ↓
Check L5 & S‑Band Capability
   ↓
Attempt NavIC Satellite Lock
   ↓
If NavIC unavailable → Use other GNSS
   ↓
Show Live Location + Satellite Details
```

---

## 🔍 What NAVIC Detects

### 📱 Device & Hardware

* Chipset Vendor (Qualcomm / MediaTek / Samsung / Unisoc)
* SoC Model & Confidence Level
* GNSS Capability via Android API
* Hardware‑level NavIC availability

### 📡 Frequency Bands

* **L5 Band (1176.45 MHz)**
* **S‑Band (2492.028 MHz)**
* L1 / L2 / E5 / B2 (other GNSS)

### 🛰️ Satellites (Real‑Time)

For **each satellite in range**:

* Satellite Name & ID (SVID)
* Navigation System (NavIC, GPS, Galileo, etc.)
* Country Flag 🇮🇳 🇺🇸 🇪🇺 🇨🇳 🇷🇺 🇯🇵
* Signal Strength (C/N₀)
* Carrier Frequency
* Used‑in‑Fix status
* Elevation & Azimuth

---

## 🗺️ Mapping & Navigation

* Uses **OpenStreetMap (OSM)** (No Google Maps dependency)
* Displays **live device location**
* Shows **current positioning system** being used
* Ideal for **offline‑friendly & open‑source mapping research**

---

## 🛠️ Tech Stack

### Frontend

* **Flutter (Dart)**
* Platform Channels for native communication

### Native Android

* **Java (MainActivity.java)**
* Android GNSS APIs
* GnssStatus.Callback (real‑time satellite monitoring)
* GnssCapabilities API (Android R+)

### Mapping

* **OpenStreetMap (OSM)**

---

##

```text
```

---

## 🎯 Use Cases

* 📚 GNSS & NavIC academic research
* 🛰️ Satellite visibility & signal analysis
* 🇮🇳 NavIC awareness & testing in India
* 📱 Chipset capability verification
* 🧪 Field testing GNSS receivers

---

## ⚠️ Important Notes

* NavIC detection depends on **hardware support**, not just software
* Some OEMs restrict NavIC visibility at OS level
* Accuracy varies with environment & satellite geometry
* This app is intended for **civilian & research use**

---

## 📸 Screenshots

> Real application screenshots captured during live GNSS operation

### 🛰️ GNSS & NavIC Detection Dashboard

![GPS Only – No NavIC Hardware](screenshots/navic_gps_only_status.jpg)

* Shows **hardware compatibility status**
* Indicates **NavIC availability** and fallback to GPS
* Displays **active frequency bands**

---

### 🌍 Live Location on OpenStreetMap (OSM)

![Acquiring Enhanced Location](screenshots/osm_live_location_acquiring.jpg)

* Real‑time **device location tracking**
* OpenStreetMap based visualization
* Displays **current positioning system** in use

---

### 📍 Enhanced Location & Accuracy Metrics

![Enhanced Accuracy Metrics](screenshots/enhanced_accuracy_metrics.jpg)

* Latitude & Longitude (live)
* Accuracy radius (meters)
* Signal quality indicator
* Active GNSS band information

---

### 🚨 Emergency Assistance Module

![Emergency Assistance Screen](screenshots/emergency_assistance.jpg)

* One‑tap **Emergency Call**
* **Share Current Location**
* **Live Location Tracking**
* **Emergency SMS with coordinates**
* L5 band readiness indicator

---

### 🧠 Hardware & Band Information

![Chipset and Band Info](screenshots/chipset_band_info.jpg)

* Detected **chipset vendor**
* Active GNSS band (L1 / L5 / G1)
* Clear indication of **NavIC hardware limitation**

---

## 🧑‍💻 Author

**R Naveen Patil**
🎓 Information Science & Engineering Student
🏫 MIT College, Kundapura

---

## 📜 License

This project is licensed under the **MIT License**.

---

## ⭐ Support the Project

If you find this project useful:

* ⭐ Star this repository
* 🍴 Fork & experiment
* 🛰️ Contribute GNSS improvements

**Jai Hind 🇮🇳 | Powered by MITK | Make in india |
