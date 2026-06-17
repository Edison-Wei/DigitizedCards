# DigitizedCards

> A native iOS app to digitize, organize, and scan your physical loyalty, library, gym, and membership cards, all in one place.

---

## What Does DigitizedCards Do

DigitizedCards lets you scan the barcodes on your physical cards and store them digitally on your iPhone. When you're at the checkout or library desk, just open the app, find your card, and let staff scan the barcode right off your screen, no wallet required.
 
Cards are organized into colour-coded categories (Library, Loyalty, Gym, Membership, ID, and any custom ones you create), with drag-and-drop reordering and card search.


<img width="200" height="430" alt="Simulator Screenshot - 2026-06-09 at 00 06 19" src="https://github.com/user-attachments/assets/96e9df4a-a910-48a5-9fcb-e9f8b7e0b3fa" />
<img width="200" height="430" alt="Simulator Screenshot - 2026-06-09 at 00 06 45" src="https://github.com/user-attachments/assets/66174eff-5fa9-4c82-8646-84b95b16be54" />
<img width="200" height="430" alt="Simulator Screenshot - 2026-06-09 at 00 06 51" src="https://github.com/user-attachments/assets/88b08dae-cb70-41dd-87f4-a6833812987a" />

<img width="200" height="430" alt="Simulator Screenshot - 2026-06-09 at 00 07 13" src="https://github.com/user-attachments/assets/1a285af6-1b6a-490c-995b-49cb6cc7e414" />
<img width="200" height="430" alt="Simulator Screenshot - 2026-06-09 at 00 10 46" src="https://github.com/user-attachments/assets/626a10ad-f57b-4fa3-8987-d2e6ec354d31" />
<img width="200" height="430" alt="Simulator Screenshot - 2026-06-09 at 00 08 34" src="https://github.com/user-attachments/assets/d5eca080-f5e0-4d9f-8d0a-a9122a100277" />
<img width="200" height="430" alt="Simulator Screenshot - 2026-06-09 at 00 08 36" src="https://github.com/user-attachments/assets/4c90895a-9456-4205-a13f-b8b9dc5ef735" />


---

## Features

- **Multi-format barcode scanning** — camera scanning via `DataScannerViewController` (VisionKit); auto-detects QR, Aztec, DataMatrix, PDF417, Code 128, Code 39, Code 93, EAN-8, EAN-13, UPC-E, and ITF-14
- **Multi-format barcode display** — all 11 formats rendered natively by [RSBarcodes_Swift](https://github.com/yeahdongcn/RSBarcodes_Swift); 2D codes display square, 1D codes display as a wide strip
- **Format-aware validation** — fixed-length formats (EAN-13, EAN-8, UPC-E, ITF-14) are validated for correct digit count before a card can be saved
- **Manual entry with format picker** — type a barcode number manually and select any of the 11 supported formats
- **Category system** — five default categories seeded on first launch (Library, Loyalty / Rewards, Gym & Fitness, Membership, Identity / ID); create, rename, recolour, and delete your own
- **Colour palette** — pick from an 18-swatch colour grid; the chosen colour flows through the entire UI (category cards, list accents, filter chips)
- **Drag-to-reorder** — drag categories on the home screen and cards in the All Cards list; order persists across launches
- **Filter chips** — horizontal scrollable chip bar to filter cards by category without leaving the list
- **Privacy first** — No data collected, Stored locally on-device

---

## Requirements

| Requirement | Minimum |
|---|---|
| iOS | 18.6+ |
| Xcode | 16.0+ |
| Swift | 6.0+ |
| Device | iPhone with camera (physical device required for scanning) |

---

## Dependencies
 
| Package | Purpose |
|---|---|
| [RSBarcodes_Swift](https://github.com/yeahdongcn/RSBarcodes_Swift) `~> 5.2.0` | Barcode image generation for all 11 supported formats |

---

## Usage

### Adding a card
 
1. Tap **+** in the top-right corner.
2. Enter a card name (e.g. *Vancouver Public Library*).
3. Tap the barcode icon to scan — the format is detected and selected automatically — or type the number manually and choose the format from the picker.
4. Choose an existing category or create a new one inline with a random colour, which you can change later.
5. Tap **Save**. Fixed-length formats (EAN-13, EAN-8, UPC-E, ITF-14) are validated before saving.

### Displaying a card
 
Tap any card to open it. The barcode renders at maximum screen brightness using RSBarcodes_Swift. 2D codes (QR, Aztec, DataMatrix, PDF417) display as a square; 1D codes display as a wide strip.
 
### Managing categories
 
Tap the **folder** icon (top-right) to open Category Management:
 
- Tap a custom category to edit its name or pick a new colour from the 18-swatch palette
- Swipe left to delete a custom category (default categories are protected from deletion)
- Tap **+** to create a new category
### Reordering
 
- **Categories:** drag cards on the home screen, order persists across launches
- **Cards:** open **All Cards** (list icon, top-left) and drag rows; reordering is disabled while search or a category filter is active

---

## Project Structure

```
DigitizingCards/
├── App/
│   └── DigitizingCardsApp.swift          # @main entry; registers ScannedCard, CardCategory,
│                                         # and BarcodeData in the modelContainer
├── Models/
│   ├── ScannedCard.swift                 # SwiftData model — title, notes, dateAdded, userOrder;
│   │                                     #     cascade-deletes its BarcodeData
│   ├── CardCategory.swift                # SwiftData model — title, colorHex, isSystem, userOrder;
│   │                                     #     nullifies cards on delete
│   └── BarcodeData.swift                 # SwiftData model — value, formatRawValue; hosts
│                                         #     BarcodeFormat enum, BarcodeValidator, avObjectType
│                                         #     mapping, and displayName helpers
├── Views/
│   ├── ContentView.swift                 # Home screen: stacked draggable category cards,
│   │                                     #     drag-and-drop reorder, seeds default categories
│   ├── AllCardsListView.swift            # Flat list with search, filter chips, move & delete
│   ├── CategoryDetailListView.swift      # Cards filtered to one category
│   ├── CardDetailView.swift              # Full-screen barcode display + BarcodeImageView
│   ├── AddCardView.swift                 # Add card form; ScannerSheetView bridge; BarcodeValidator
│   ├── CategoryManagementView.swift      # CRUD list for categories
│   └── CategoryFormView.swift            # Add / edit category
├── Services/
│   └── BardcodeService.swift             # BarcodeGenerator singleton — delegates to
│                                         # RSUnifiedCodeGenerator.shared for all formats
├── Scanner/
│   └── BarcodeScannerView.swift          # VisionKit wrapper; maps VNBarcodeSymbology →
│                                         # BarcodeFormat
└── Extensions/
    └── Color+Hex.swift                   # Color ↔ hex string helpers (init(hex:), toHex())

```

---

## Privacy
 
DigitizingCards collects no data. Everything is stored locally on your device using SwiftData. No account, no network requests, no analytics.
 
[Privacy Policy](https://gist.github.com/Edison-Wei/5d23c3f26e43cb39010e20d6c726db09)

---

## Developer

Created and maintained by **Edison Wei** ([@Edison-Wei](https://github.com/edison-wei)).
