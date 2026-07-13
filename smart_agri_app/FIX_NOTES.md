# Ye Fix Ki Hui Copy Hai

Aap ne jo project bheja tha, usi ka poora structure hai — bas 2 files
theek ki gayi hain (neeche wajah likhi hai). `build`, `.dart_tool`,
`.idea`, aur gradle cache folders is zip mein shamil NAHI hain, kyunke
wo khud-ba-khud dobara ban jate hain jab aap `flutter pub get` /
`flutter run` chalayenge — unhe zip mein rakhna sirf size barhata,
kaam ka nahi.

## Kya theek hua

1. **`lib/services/crop_repository.dart`** — Demo mode mein "Fasal Add
   Karein" button dabane par pehle chup-chaap kuch nahi hota tha. Ab
   demo mode mein fasal turant local memory mein save ho kar screen
   par dikh jati hai.
2. **`lib/services/auth_service.dart`** — Demo ka fake user adhoora
   tha (phone number missing tha), is wajah se Profile screen crash
   ho jati thi. Ab fake user poora kaam karta hai.

## Is folder ko kaise use karein

1. Apna purana `smart_agri_app` folder (jahan aap `flutter run` karte
   hain) — us ka naam badal dein ya kahin backup rakh dein
2. Is naye extract hue `smart_agri_app` folder ko usi jagah rakh dein
3. Terminal us naye folder mein le jayein:
   ```
   cd smart_agri_app
   flutter pub get
   flutter run -d chrome
   ```
4. Login karte waqt OTP code **123456** ya **000000** likhein

## Yaad rahe

- Ye abhi bhi **Demo Mode** hai (asal cloud database nahi hai) — app
  band karne par demo data khatam ho jayega
- Permanent/real storage ke liye `flutterfire configure` chalana
  abhi bhi zaroori hai — us ke baad demo fallback khud skip ho jayega
