# Smart Agriculture Assistant — Phase 1 (UI/UX Prototype)

Ye Flutter project proposal ke **Phase 1** ka deliverable hai:
> "Requirement Finalization + Wireframes/UI Design"

Is phase mein poori app ka look-and-feel, navigation aur roadmap logic
bana diya gaya hai — lekin abhi koi real backend (Firebase) nahi laga,
is liye sara data **mock/in-memory** hai (`lib/data/app_data.dart`).
Jab aap app chalayenge to already 2 sample fasalein (Gandum, Kapas)
dikhengi, aur naya crop add karne par khud-kar ek roadmap ban jayega.

## Kya kaam karta hai (is phase mein)

- Splash → Login (mock phone number, koi real OTP nahi) → Home
- Home: mausam ka card + "Meri Fasalein" list
- Fasal Add Karein: crop dropdown, kasht ki tareekh (date picker),
  rakba, aur "location use karein" button (soil data abhi mock hai)
- Fasal per tap karne se: poora Smart Roadmap (pani/khaad ki tareekhain)
  checklist ki tarah, progress bar ke sath
- Profile tab: kisan ka basic data + logout

## Project ko apne computer par chalana

1. [Flutter SDK install karein](https://docs.flutter.dev/get-started/install)
   (Windows/Mac/Linux — official Flutter website se, ye bilkul free hai)
2. Is folder ko extract karein aur terminal mein andar jayein:
   ```
   cd smart_agri_app
   flutter pub get
   flutter run
   ```
3. Emulator ya apna Android phone (USB debugging ke sath) connect karke
   `flutter run` karein — app khul jayegi.

> Agar Android Studio ya VS Code use kar rahe hain, to bas folder open
> karein aur "Run" dabayein — dono IDEs Flutter projects khud detect
> kar lete hain.

## Folder Structure

```
lib/
  main.dart                 -> app entry point
  theme/app_theme.dart      -> colors, fonts, button/card styling
  models/                   -> Crop aur RoadmapTask data models
  data/app_data.dart        -> mock database + roadmap-generation logic
  screens/                  -> har screen (splash, login, home, weather,
                                add-crop, crop-detail, profile)
  widgets/                  -> reusable cards (weather, crop, task tile)
```

## Aage ke Phases (Proposal se)

| Phase | Kaam | Status |
|---|---|---|
| Phase 1 | Wireframes/UI Design | ✅ Ye zip — complete |
| Phase 2 | Firebase Setup + Real Authentication (OTP) | Agla kadam |
| Phase 3 | Crop & Field data ko Firestore mein save karna | Baaqi |
| Phase 4 | OpenWeatherMap se real mausam data | Baaqi |
| Phase 5 | SoilGrids API se real zameen ka data (GPS ke zariye) | Baaqi |
| Phase 6 | Behtar Recommendation Engine (rules ko refine karna) | Baaqi |
| Phase 7 | Push Notifications (Firebase Cloud Messaging) | Baaqi |
| Phase 8 | Testing | Baaqi |
| Phase 9 | Play Store Deployment | Baaqi |

## Phase 2 shuru karne ke liye aap se chahiye hoga

1. Google account se ek free [Firebase Project](https://console.firebase.google.com) banayein.
2. Android app add karein, `google-services.json` file download karein.
3. Wo file mujhe bhej dein (ya bata dein aap ne bana li) — main us se
   Authentication, Firestore aur Cloud Messaging connect kar dunga.

Koi bhi screen ka design, color, ya field modify karwana ho — bata dein,
isi structure mein update kar dunga.
