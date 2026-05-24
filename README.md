# DigitizedCards

> A native iOS app to digitize, organize, and scan your physical loyalty, library, gym, and membership cards, all in one place.

---

## What Does DigitizedCards Do

DigitizedCards lets you scan the barcodes on your physical cards and store them digitally on your iPhone. When you're at the checkout or library desk, just open the app, find your card, and let staff scan the barcode right off your screen, no wallet required.

Cards are organized into colour-coded categories (Library, Loyalty, Gym, Membership, ID, and any custom ones you create), with drag-and-drop reordering and a full-text search across your entire collection.

<img width="160" height="320" alt="App-Main-Page" src="https://github.com/user-attachments/assets/a7ea83c5-fb2f-4726-9685-cc9a5392a7f9" />
<img width="160" height="320" alt="Show-All-Cards" src="https://github.com/user-attachments/assets/f45dbaa3-cee9-4940-9b0b-7f072e8ef116" />
<img width="160" height="320" alt="Show-All-Cards-Filtered" src="https://github.com/user-attachments/assets/02d8f3a2-1b63-494f-ac64-ebdb463cc980" />
<img width="160" height="320" alt="Show-Category-Cards" src="https://github.com/user-attachments/assets/40664244-d384-47f6-91b6-ef559abce5c0" />
<img width="160" height="320" alt="Show-Card-Barcode" src="https://github.com/user-attachments/assets/991dc5dd-8498-4798-b1da-c1120c0ce12f" />

---

## Features

- **Barcode scanning** — uses the device camera via `DataScannerViewController` (VisionKit) to scan any Code 128 barcode in real time
- **Barcode display** — renders a crisp, full-brightness barcode image on screen using Core Image (`CICode128BarcodeGenerator`)
- **Auto-brightness** — maximizes screen brightness when a card is displayed and restores it when you leave
- **Category system** — five default categories seeded on first launch; create, rename, recolour, and delete your own
- **Colour theming** — every category gets a hex colour that flows through the UI (category cards, list accents, filter chips)
- **Drag-to-reorder** — reorder both categories (on the home screen) and cards (in the All Cards list) with standard SwiftUI gestures
- **Filter chips** — horizontal scrollable chip bar in All Cards to filter by category without leaving the view
- **Search** — `searchable` modifier provides system-standard search across card name and barcode number
- **SwiftData persistence** — all data is stored locally with SwiftData; no account or network required

---

## Requirements

| Requirement | Minimum |
|---|---|
| iOS | 17.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |
| Device | iPhone with camera (for scanning) |

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/DigitizedCards.git
cd DigitizedCards
```

### 2. Open in Xcode

```bash
open DigitizingCards.xcodeproj

```

### 3. Configure signing

In Xcode, select the **DigitizingCards** target → **Signing & Capabilities** → set your Team and Bundle Identifier.

### 4. Add camera permission

Ensure `Info.plist` contains the camera usage description key (required for VisionKit scanning):

```xml
<key>NSCameraUsageDescription</key>
<string>Used to scan barcodes on your physical cards.</string>
```

### 5. Run

Select your connected iPhone as the run destination and press **⌘R**.

---

## Usage

### Adding a card

1. Tap **+** in the top-right corner.
2. Enter a card name (e.g. *Vancouver Public Library*).
3. Tap the barcode icon to scan, or type the account number manually.
4. Choose an existing category or create a new one inline.
5. Tap **Save**.

### Displaying a card

Tap any card in the list — the barcode is rendered full-screen at maximum brightness so scanners can read it easily.

### Managing categories

Tap the **folder** icon (top-right) to open Category Management. From there you can:

- Tap a category to edit its name or colour
- Swipe left on a custom category to edit or delete it
- Tap **+** to create a new category with a colour picker

### Reordering

- **Categories:** long-press and drag cards on the home screen, or use drag-and-drop
- **Cards:** open **All Cards** (list icon, top-left) and drag rows when no search or filter is active

---

## Project Structure

```
DigitizingCards/
├── App/
│   └── DigitizingCardsApp.swift   # @main entry point, modelContainer setup
├── Models/
│   ├── ScannedCard.swift          # SwiftData model for individual cards
│   └── CardCategory.swift         # SwiftData model for categories
├── Views/
│   ├── ContentView.swift          # Home screen with stacked category cards
│   ├── AllCardsListView.swift     # Flat list of all cards with search + filter chips
│   ├── CategoryDetailListView.swift # Cards scoped to one category
│   ├── CardDetailView.swift       # Full-screen barcode display
│   ├── AddCardView.swift          # Form to add a new card
│   ├── CategoryManagementView.swift # CRUD list for categories
│   └── CategoryFormView.swift     # Add / edit category form
├── Services/
│   └── BardcodeService.swift      # Core Image barcode image generator
├── Scanner/
│   └── BarcodeScannerView.swift   # VisionKit DataScannerViewController wrapper
└── Extensions/
    └── Color+Hex.swift            # Color ↔ hex string conversion helpers
```


---

## Known Limitations

- Barcode format is working for **Code 128**. Cards that use QR codes, PDF417 (e.g. some transit cards), or other formats will scan correctly but will always be displayed as Code 128.
- No iCloud sync — data lives on-device only.
- No card image capture — only the barcode number is stored.

---

## Roadmap

- [ ] Support additional barcode formats (QR, PDF417, EAN-13)
- [ ] iCloud sync via CloudKit
- [ ] Card Image capture??

---

## Developer

Created and maintained by **Edison Wei** ([@Edison-Wei](https://github.com/edison-wei)).
