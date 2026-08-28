# CONSTRUCTA – SMART CONSTRUCTION & ARCHITECTURAL SERVICES PLATFORM
## Comprehensive College Mini Project Report & Viva Evaluation Guide

---

### **Project Metadata**
- **Project Title:** Constructa – Smart Construction & Architectural Marketplace Application
- **Domain:** Mobile & Cross-Platform Application Development / Cloud Computing
- **Front-End Framework:** Flutter (Dart 3.x)
- **Backend / Database:** Google Firebase (Authentication, Cloud Firestore, Firebase Storage)
- **Architecture:** Feature-First Modular Layered Architecture (Service-Repository-UI Pattern)
- **Target Platforms:** Android, iOS, Web, macOS, Linux, Windows

---

## 1. Executive Summary & Abstract

In the traditional civil construction and home design industry, homeowners frequently encounter challenges including:
1. **Opaque Pricing Models:** Inability to estimate initial civil construction costs accurately before engaging contractors.
2. **Discovery Friction:** Difficulty finding verified, certified construction companies with verifiable track records and portfolio showcases.
3. **Inefficient Communication & Booking:** Disjointed communication channels with no centralized platform for scheduling architectural consultations, site inspections, and house plan bookings.

**Constructa** is an end-to-end cloud-integrated Flutter platform that bridges the gap between prospective homeowners/clients, verified construction firms/architects, and platform administrators. Built with a reactive architecture powered by **Google Cloud Firestore** and **Firebase Authentication**, Constructa enables real-time project management, customizable construction cost estimations, modular architectural plan discovery, end-to-end appointment scheduling, and automated administrative oversight.

---

## 2. Problem Statement & Motivation

| Traditional Industry Challenge | Constructa Proposed Solution |
|---|---|
| **Lack of Transparent Budgeting** | Interactive **Dynamic Construction Cost Estimator** calculating instant estimates based on square footage, architectural quality grade (Standard, Premium, Luxury), and material specifications. |
| **Unverified Contractors** | **Admin Verification Badge System** ensures only vetted companies with valid licenses and ratings can offer services. |
| **Scattered Portfolios** | **Centralized Architectural Repository** showcasing house plans (2BHK/3BHK/4BHK), architectural specs, and completed real-world project portfolios. |
| **Booking & Status Disconnect** | **Real-Time Reactive Booking Engine** with instant status transitions (`Pending` ➔ `Confirmed` ➔ `Completed` / `Cancelled`) streamed directly to both client and contractor. |

---

## 3. System Architecture & Tech Stack

```
                                  +-------------------------------------------------------+
                                  |                 CONSTRUCTA APP CLIENT                 |
                                  |     (Flutter Cross-Platform Engine - Web / Mobile)    |
                                  +-------------------------------------------------------+
                                                              |
                  +-------------------------------------------+-------------------------------------------+
                  |                                           |                                           |
    +---------------------------+               +---------------------------+               +---------------------------+
    |      CUSTOMER MODULE      |               |     CONTRACTOR MODULE     |               |       ADMIN MODULE        |
    | - Cost Calculator         |               | - Live Metrics Analytics  |               | - Global Metrics Dashboard|
    | - House Plans Showcase    |               | - Plan & Project Portfolio|               | - Verification Management |
    | - Verified Company Search |               | - Booking Requests Manager|               | - User & Company Control  |
    | - Consultation Booking    |               | - Customer Review Feed    |               | - Content Moderation      |
    +---------------------------+               +---------------------------+               +---------------------------+
                  |                                           |                                           |
                  +-------------------------------------------+-------------------------------------------+
                                                              |
                                           +------------------------------------+
                                           |      CORE SERVICES & REPOSITORIES  |
                                           | - AuthService      - AdminService  |
                                           | - BookingService   - CompanyService|
                                           | - HousePlanService - ProjectService|
                                           | - ReviewService                    |
                                           +------------------------------------+
                                                              |
                                           +------------------------------------+
                                           |         CLOUD INFRASTRUCTURE       |
                                           |  - Firebase Auth (RBAC / OAuth)    |
                                           |  - Cloud Firestore (NoSQL Realtime)|
                                           |  - Firebase Storage (Media Assets) |
                                           +------------------------------------+
```

### Technology Stack Details

1. **Client Framework:** `Flutter 3.x` with `Dart SDK >=3.0.0 <4.0.0`
   - **UI Design System:** Custom Material 3 theme palette (`AppColors`), Google Fonts (`Poppins`), responsive layouts.
   - **Reactive UI:** `StreamBuilder` and `FutureBuilder` bindings for live zero-latency synchronization.
2. **Authentication Tier:** `Firebase Authentication`
   - Role-Based Access Control (RBAC): `customer`, `company` / `constructor`, and `admin`.
   - Email/Password authentication & Google Sign-In (`google_sign_in`).
3. **Database Tier:** `Google Cloud Firestore` (NoSQL Document Store)
   - Real-time collection snapshots and multi-collection streams.
4. **Storage Tier:** `Firebase Storage`
   - Cloud storage for architectural plans, project images, company logos, and inspection attachments.
5. **External Utilities:** `url_launcher` (direct phone/email interaction), `image_picker` (portfolio upload).

---

## 4. Database Schema & Data Dictionary

The NoSQL data layer in Cloud Firestore is structured across six primary collections:

```
Cloud Firestore
├── users/{uid}
├── companies/{companyId}
├── house_plans/{planId}
├── projects/{projectId}
├── bookings/{bookingId}
└── reviews/{reviewId}
```

### Data Dictionary

#### 1. `users` Collection
| Field | Type | Description |
|---|---|---|
| `uid` | `String` | Unique Firebase Auth identifier |
| `email` | `String` | User email address |
| `fullName` | `String` | Full name of the user / representative |
| `phoneNumber` | `String` | Contact phone number |
| `role` | `String` | Authorization role: `'customer'`, `'company'`, `'admin'` |
| `profileImageUrl`| `String` | URL of the profile avatar |

#### 2. `companies` Collection
| Field | Type | Description |
|---|---|---|
| `id` | `String` | Firestore Document ID |
| `uid` | `String` | Associated user UID of company owner |
| `name` | `String` | Legal trade name of construction firm |
| `specialty` | `String` | Core domain (e.g. *Luxury Residential, Commercial, Renovation*) |
| `location` | `String` | Operating city/district (e.g., *Kochi, Kerala*) |
| `rating` | `double` | Aggregated user rating (e.g., `4.8`) |
| `reviewCount` | `int` | Total count of submitted reviews |
| `logoUrl` | `String` | Company brand logo image URL |
| `bannerUrl` | `String` | Profile banner image URL |
| `description` | `String` | Company overview and experience summary |
| `phone` / `email`| `String` | Official contact information |
| `services` | `List<String>`| Array of offered services |
| `isVerified` | `bool` | Administrative verification status badge |

#### 3. `house_plans` Collection
| Field | Type | Description |
|---|---|---|
| `id` | `String` | Document ID |
| `companyId` | `String` | Identifier of publishing contractor |
| `companyName` | `String` | Denormalized company name for fast rendering |
| `title` | `String` | Plan title (e.g., *Modern Nordic Villa*) |
| `bhk` | `String` | Room configuration (`2BHK`, `3BHK`, `4BHK`, `Duplex`) |
| `sqft` | `int` | Total built-up area in square feet |
| `contractPrice`| `double` | Base estimated construction price (₹) |
| `description` | `String` | Detailed architectural specifications |
| `imageUrls` | `List<String>`| 3D elevation renders and floor blueprint URLs |
| `tag` | `String` | Highlight badge (`Bestseller`, `Trending`, `New`) |
| `features` | `List<String>`| Amenity checklist (*Modular Kitchen, Solar Roof, etc.*) |

#### 4. `bookings` Collection
| Field | Type | Description |
|---|---|---|
| `id` | `String` | Unique Booking ID |
| `userId` | `String` | Customer UID |
| `userName` / `userPhone` | `String` | Client contact details |
| `companyId` / `companyName` | `String` | Selected contractor details |
| `planId` / `planTitle` | `String` | Selected house plan or service type |
| `bookingDate` | `String` | Requested appointment date (`YYYY-MM-DD`) |
| `timeSlot` | `String` | Preferred consultation window (e.g. *10:00 AM - 12:00 PM*) |
| `status` | `String` | State machine: `'Pending'` ➔ `'Confirmed'` ➔ `'Completed'` / `'Cancelled'` |
| `notes` | `String` | Client custom requirements / plot details |
| `estimatedCost`| `double` | Estimated contract budget |
| `createdAt` | `String` | ISO timestamp |

#### 5. `projects` Collection
| Field | Type | Description |
|---|---|---|
| `id` | `String` | Document ID |
| `companyId` / `companyName` | `String` | Publishing contractor details |
| `title` | `String` | Project title (e.g., *Green Valley Luxury Villa*) |
| `category` | `String` | Category: `Construction`, `Renovation`, `Interior` |
| `location` | `String` | Site location |
| `description` | `String` | Case study and materials used |
| `imageUrls` | `List<String>`| Photos of completed build |
| `completionDate` | `String` | Month and Year of handover |

#### 6. `reviews` Collection
| Field | Type | Description |
|---|---|---|
| `id` | `String` | Review Document ID |
| `userId` / `userName` | `String` | Reviewer identity |
| `companyId` | `String` | Target company identifier |
| `rating` | `double` | Numeric score (1.0 to 5.0) |
| `comment` | `String` | Detailed feedback |
| `createdAt` | `String` | Submission timestamp |
| `response` / `responseDate` | `String` | Contractor official reply |

---

## 5. Core Modules & Feature Breakdown

### A. Customer (User) Module
1. **Interactive Cost Estimator:**
   - Real-time calculation formula:
     $$\text{Estimated Cost} = \text{Built-up Area (sq.ft)} \times \text{Quality Rate (₹/sq.ft)}$$
     - *Standard Grade:* ₹1,650 / sq.ft
     - *Premium Grade:* ₹2,200 / sq.ft
     - *Luxury Grade:* ₹3,100 / sq.ft
   - Direct button to immediately transition the calculated estimate into a verified site-inspection booking.
2. **House Plans Marketplace:**
   - Filter plans by BHK, budget range, and category.
   - Comprehensive detail view with image carousels, dimensions, and included deliverables.
3. **Company Directory & Profiles:**
   - Search certified contractors by rating, location, and specialties.
   - View past project portfolios and verified customer reviews.
4. **End-to-End Booking Lifecycle:**
   - Schedule site inspections and consultations.
   - Track booking status live with cancellation safeguards.
5. **Review & Rating Engine:**
   - Submit star ratings and written reviews upon project completion.

### B. Constructor / Contractor Module
1. **Live Business Analytics Dashboard:**
   - Real-time aggregation of active booking requests, published house plans, completed builds, and calculated average star rating.
2. **Booking Management:**
   - Accept or decline incoming customer consultation requests with automatic notification states.
3. **Portfolio & Catalog Management:**
   - Add, edit, or delete house plan elevation models and completed project galleries.
4. **Customer Feedback Management:**
   - Monitor and respond directly to customer reviews.

### C. Admin Super-Module (Web & Mobile Optimized)
1. **Platform Analytics:**
   - Live stream count of total users, registered companies, active bookings, and submitted reviews.
2. **Company Verification Portal:**
   - Single-tap verification toggle to award the verified badge to certified builders.
3. **Universal Moderation:**
   - Full CRUD permissions to moderate fraudulent users, spam reviews, or deprecated listings.

---

## 6. Authentication & Role-Based Routing Architecture

```
                                  [ App Launch ]
                                         │
                                  [ AuthWrapper ]
                                         │
                        Is user authenticated via Firebase?
                                ├── No  ──> [ Login / Signup / Onboarding Screen ]
                                └── Yes ──> [ Query Firestore `users/{uid}` ]
                                                  │
                                                  ├─ role == 'admin'       ──> [ AdminShell ]
                                                  ├─ role == 'company'     ──> [ ConstructorMainNavigationShell ]
                                                  └─ role == 'customer'    ──> [ UserBottomNavShell ]
```

---

## 7. Viva & Convener Examination Q&A Cheat Sheet

Prepare these exact technical answers for questions commonly asked by project examiners and conveners:

### **Q1: Why did you choose Flutter instead of native Android (Kotlin) or React Native?**
> **Answer:** Flutter provides a single compiled codebase running on the Skia/Impeller graphics engine, delivering consistent 60/120 FPS performance across Android, iOS, and Web. Unlike React Native, Flutter eliminates the JavaScript bridge overhead by compiling directly to native ARM machine code, resulting in faster rendering, seamless hardware integration, and unified UI styling across mobile and admin web dashboards.

### **Q2: How is data synchronized in real-time between clients and contractors?**
> **Answer:** We implemented Cloud Firestore’s reactive streams using Flutter's `StreamBuilder` widget. When a contractor updates a booking status from `'Pending'` to `'Confirmed'`, Firestore emits a snapshot event over WebSocket/gRPC channels. The client UI listening to that document stream automatically rebuilds instantly without requiring manual page refreshes or polling.

### **Q3: What database architecture are you using and why NoSQL over SQL?**
> **Answer:** We chose Cloud Firestore (NoSQL Document-based database). Construction applications feature nested, variable data like arrays of house plan blueprints, amenity tags, and dynamic image URLs. NoSQL allows flexible document structures without complex multi-table joins, scales automatically with zero server maintenance, and supports built-in offline caching and real-time listeners.

### **Q4: How does Role-Based Access Control (RBAC) work in your application?**
> **Answer:** On user login, `AuthWrapper` queries the user document in the `users` collection to check the `role` field. Based on whether the value is `'customer'`, `'company'`, or `'admin'`, the application dynamically routes to `UserBottomNavShell`, `ConstructorMainNavigationShell`, or `AdminShell`. Sensitive actions (e.g. company verification, catalog deletions) are further guarded by Firestore security rules.

### **Q5: How does the Cost Estimation logic function?**
> **Answer:** The cost calculator uses a dynamic algorithm factoring in built-up area ($\text{sq.ft}$) multiplied by real-world market material grade coefficients (Standard: ₹1,650/sq.ft, Premium: ₹2,200/sq.ft, Luxury: ₹3,100/sq.ft). The calculated estimate is then bundled into the booking payload so contractors receive pre-calculated budget parameters.

### **Q6: How do you handle image storage and media uploads?**
> **Answer:** Images are picked using the `image_picker` package, uploaded to **Firebase Storage** under structured folders (`/companies`, `/house_plans`, `/projects`), and the resulting public download URLs are persisted in the corresponding Firestore documents.

### **Q7: What are the future enhancements planned for this project?**
> **Answer:**
> 1. **3D BIM / AR Integration:** Integrating augmented reality (AR) to visualize 3D house plans directly on physical land plots.
> 2. **Milestone Escrow Payment Gateway:** Incorporating Razorpay/Stripe for automated phase-based payment releases (*Foundation ➔ Framing ➔ Finishing*).
> 3. **AI Floor Plan Generator:** Generative AI for customized floor layouts based on plot dimensions and Vaastu guidelines.

---

## 8. Summary of Project Contributions

- **Repository:** [`NahlaRiyas/constructa_app`](https://github.com/NahlaRiyas/constructa_app)
- **Primary Developer:** Nahla Riyas (`nahlariyas2002@gmail.com`)
- **Key Modules Implemented:** User Portal, Constructor Portal, Admin Dashboard, Firestore Service Layer, Material 3 Design System.
