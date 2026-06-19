# Goal Description

Build a completely new, premium Gita cross-platform mobile app using **Flutter**. The app will be built from scratch, offering distinct **Reading** and **Listening** modes. To ensure a robust and scalable foundation, we will adopt the exact same feature-first architecture and state management approach used in your **Koshly** project.

## Finalized Requirements & Architecture

Based on your feedback, here is the updated and locked-in technical plan:

### 1. Frontend Stack (Flutter) & State Management
- **Architecture**: Feature-first folder structure (`lib/core`, `lib/features`, `lib/shared`) matching the Koshly app.
- **State Management**: **Riverpod** (`flutter_riverpod` + `riverpod_annotation`) and Code Generation. This replaces BLoC from the previous plan to align with Koshly.
- **Immutable State**: `freezed` and `json_serializable` for robust state classes.
- **Routing**: `go_router` for declarative navigation.
- **Audio Playback**: `audioplayers` or `just_audio` (for S3 streaming).
- **Networking**: `dio` to communicate with your NestJS APIs.

### 2. Design System & Aesthetics
- **Theme Engine**: We will adapt the powerful Dark/Light mode theme system from **Koshly** (`core/theme/`). 
- **Unique Palette**: To give the Gita app its own premium, spiritual identity, we will modify the Koshly color tokens. We'll use harmonious colors like Deep Saffron, Gold, and rich Dark Purples/Blacks for dark mode, while keeping the structural design system (text themes, glassmorphism containers) intact.
- **Typography**: Google Fonts (`Inter` for UI, `Noto Sans Devanagari` for Sanskrit).

### 3. Backend Strategy
- **Authentication**: **Firebase Auth** (Google/Apple/Email).
- **Data & Progress**: Your existing **NestJS + MySQL backend**. We will pass the Firebase Auth token to NestJS, which will verify the user and serve Gita data and track progress.
- **Media**: S3 Bucket (Images & MP3 Audio).

## Implementation Steps

### Phase 1: Foundation (The Koshly Way)
1. **Initialize**: Create the new Flutter project (e.g., `gita_app`).
2. **Scaffold**: Port over the Koshly architecture (`core`, `features`, `shared`).
3. **Design System**: Copy the Koshly theme structure into `core/theme/` and update the color palettes to fit the Gita theme.
4. **Firebase**: Configure Firebase Auth and link it to the app.

### Phase 2: Navigation & Core Modules
1. Implement the Auth flow (Login/Splash screen) using Riverpod state.
2. Build the Main Dashboard / Home Screen (showing resume progress for reading/listening).
3. Build the Chapter List and Verse List views fetching data from the NestJS API via a Riverpod `FutureProvider`.

### Phase 3: The Dual Experience
1. **Reading Mode**: Build the distraction-free UI displaying Sanskrit text, transliteration, and commentary.
2. **Listen Mode**: Implement the Audio Service to stream from S3. Build the Audio Player UI with album art, play/pause controls, and a scrubbable progress bar.

### Phase 4: Sync & Polish
1. Implement progress syncing (sending the last read/listened verse back to the NestJS server).
2. Add finishing touches (animations, error handling, offline caching).

## User Review Required

> [!IMPORTANT]
> The plan is now fully aligned with the **Koshly architecture** (Riverpod + Freezed) and **Design System**. 
> If you are happy with this final roadmap, please approve! Once approved, I'll create the new Flutter app in your workspace and begin porting the foundation.
