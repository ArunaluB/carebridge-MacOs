# CareBridge-macOS - NurseryConnect Setting Manager

**SE4020 - Mobile Application Design & Development**  
**Assignment 02 Part A - NurseryConnect macOS MVP**

---

## Student Details

| Field | Details |
|---|---|
| **Student ID** | IT22515612 |
| **Student Name** | Bamunusinghe S A N |
| **Chosen User Role** | Setting Manager (Nursery Manager) |

---

## Demo Video

🎥 **[Watch the Assignment Demo Video on Google Drive](https://drive.google.com/file/d/1-ugbq413cXbbI1pkpcYa40dpTt5CgHgV/view?usp=sharing)**

---

## 01. Abstract & Project Overview

This project is the macOS extension of the NurseryConnect mobile application developed for the SE4020 module. It targets the **Setting Manager** role, complementing the Keyworker role from Assignment 1. The application is built natively for macOS using **SwiftUI** and the **MVVM architecture**.

The macOS application addresses the administrative and compliance needs of nursery managers, such as reviewing children's data across rooms, countersigning incidents, and generating Ofsted-ready reports.

## 02. Key Features

- **Setting Manager Dashboard:** A native macOS three-column layout (`NavigationSplitView`) with multi-window support and a Menu Bar Extra status app.
- **AI-Powered Child Development Analytics:** Uses Apple's `NaturalLanguage` framework for sentiment analysis, EYFS keyword extraction, and wellbeing score computation based on daily diary entries.
- **Incident Review Queue:** A dedicated workflow for managers to countersign incident reports before parent notification (RIDDOR compliance).
- **PDF Report Generation:** Uses `PDFKit` to generate exportable, paginated, Ofsted-ready PDF reports (Weekly Summary, Incident Report, EYFS Coverage).
- **Advanced Visualizations (Swift Charts):**
  - *Wellbeing Trend Chart:* 14-day rolling wellbeing score using `LineMark` and `AreaMark`.
  - *EYFS Coverage Dashboard:* Activity coverage across 7 learning areas using `BarMark`.
  - *Mood Distribution Chart:* A pie chart representation using `SectorMark`.

## 03. Technology Stack

- **Platform:** macOS 14+
- **Language:** Swift 6 / Xcode 16+
- **Framework:** SwiftUI
- **Architecture:** MVVM with `@Observable` Service Layer
- **Advanced Apple Frameworks Integrated:**
  - `NaturalLanguage`: For NLP tasks (sentiment, keywords, named entity recognition).
  - `Swift Charts`: For data visualizations and analytical trends.
  - `PDFKit` & `AppKit`: For HTML-to-PDF generation, print operations, and native macOS features (`NSPrintOperation`, `NSSavePanel`, `NSHapticFeedbackManager`).
- **Persistence:** JSON persistence via `Foundation` / `UserDefaults` (shared with Assignment 1 data layer).
- **Logging & Testing:** `os.log` (OSLog) for structured logging, and `XCTest` combined with a custom Runtime Diagnostics Dashboard for testing.

## 04. Regulatory Compliance

The application helps the Setting Manager adhere to critical UK childcare regulations:
- **UK GDPR:** Implements data minimization, storage limitation, and structured logging for accountability.
- **EYFS Framework 2024:** Supports incident countersignature workflows, developmental records monitoring across the 7 EYFS areas, and staff-to-child ratio tracking.
- **Children Act 1989:** Safeguarding concern escalation and authorized collector oversight.
- **Ofsted EIF 2023 Inspection Readiness:** Generates required chronological incident evidence and compliance reports.

## 05. Application Architecture

The codebase comprises over 80 Swift files across ~19,680 lines of code, structured with a clear separation of concerns:
- **Models:** Reused data models from the iOS MVP with new manager-specific structs.
- **Services:** Singletons like `NLAnalysisService` and `ManagerDataService` using `@Observable`.
- **ViewModels:** Handle state and business logic (`SettingManagerDashboardViewModel`, `ReportViewModel`).
- **Views:** macOS-specific declarative views heavily utilizing `NavigationSplitView` and multi-window features (`WindowGroup(for:)`).

---
*Developed for SE4020 - SLIIT | Semester 1, 2026*
