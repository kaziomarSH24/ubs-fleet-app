# 🚀 Progress Report - August 09, 2026

**Context for AI Agent on Mac:**
We are building the **UBS Fleet App** (a Fleet Management System) using Flutter (offline-first with Hive) and Supabase. The following features, database migrations, and bug fixes were completed in the last session. Please read this to understand the current state of the codebase before starting the next tasks.

## 1. Database & Storage Updates
- **Migrations Created:** 
  - `20260809160500_add_profile_avatar_and_docs.sql`
  - `20260809170000_seed_vehicles.sql`
- **Profiles Table:** Added `avatar_url` column to store the public URL of the driver's profile picture.
- **Driver Documents Table:** Created `driver_documents` table to track uploaded documents (NID, Driving License, etc.) with a `status` (pending, verified, rejected).
- **Storage Buckets:** Created `avatars` (public) and `driver_documents` (private) buckets in Supabase.

## 2. Driver Profile Features (`driver_profile_screen.dart`)
- **Avatar Upload:** Implemented profile picture upload functionality. Clicking the avatar gives options to "View Photo" or "Upload New Photo".
- **Document Upload:** Implemented uploading specific documents (NID Card, Driving License, Other).
- **Storage Optimization (Size Limits):** 
  - Added auto-compression using `image_picker` (`maxWidth`/`maxHeight`).
  - Added strict Dart-level file size validation: **Max 2MB per image**.
  - If a file exceeds 2MB, the upload is aborted and a localized SnackBar error is shown.
- **Image Preview (InteractiveViewer):** 
  - Avatars can be previewed directly (Public URL).
  - Documents can be previewed using dynamically generated **Signed URLs** (`getSignedUrl` from `ProfileRepository`).

## 3. Dynamic Assigned Vehicle
- Replaced the hardcoded mock vehicle data in the profile screen.
- Added `getAssignedVehicle` method in `ProfileRepository` to fetch the vehicle where `current_driver_id` matches the logged-in driver.
- Seeded dummy vehicles and dynamically assigned the first car to `employee_id: 'DRV-1001'` via the SQL seeder script.

## 4. Bug Fixes & Localization
- **Windows File Path Bug:** Fixed the `InvalidKey` error in Supabase Storage by safely extracting the filename using `file.path.split(RegExp(r'[\\/]')).last` to handle Windows backslashes properly.
- **Windows File Picker Deadlock:** Added a `300ms` delay after `Navigator.pop(context)` before opening the native file picker to prevent the Flutter UI from freezing on desktop.
- **Localization:** Added new strings (e.g., `errorImageTooLarge`) to both `app_en.arb` and `app_bn.arb` and ran `flutter gen-l10n`.

## 5. Architectural Decision (Next Steps)
- **Admin Panel Strategy:** We decided to build the Admin Panel **inside this same Flutter app (Monorepo)** rather than a separate project. 
- **Next Task:** Implement **Role-based Routing** (if `role == 'admin'` route to Admin Dashboard, else route to Driver Dashboard) and begin designing the Desktop/Web Admin UI.
