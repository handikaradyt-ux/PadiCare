---
name: AgroSawah Material System
colors:
  surface: '#f1fdeb'
  surface-dim: '#d2decc'
  surface-bright: '#f1fdeb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#ebf7e5'
  surface-container: '#e5f1e0'
  surface-container-high: '#e0ecda'
  surface-container-highest: '#dae6d4'
  on-surface: '#141e13'
  on-surface-variant: '#414942'
  inverse-surface: '#293327'
  inverse-on-surface: '#e8f4e2'
  outline: '#717972'
  outline-variant: '#c1c9c0'
  surface-tint: '#3d674c'
  primary: '#002713'
  on-primary: '#ffffff'
  primary-container: '#133e26'
  on-primary-container: '#7daa8a'
  inverse-primary: '#a3d1b0'
  secondary: '#1b6d24'
  on-secondary: '#ffffff'
  secondary-container: '#a0f399'
  on-secondary-container: '#217128'
  tertiary: '#3b1600'
  on-tertiary: '#ffffff'
  tertiary-container: '#5d2600'
  on-tertiary-container: '#f1813a'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#bfeecb'
  primary-fixed-dim: '#a3d1b0'
  on-primary-fixed: '#00210f'
  on-primary-fixed-variant: '#254f35'
  secondary-fixed: '#a3f69c'
  secondary-fixed-dim: '#88d982'
  on-secondary-fixed: '#002204'
  on-secondary-fixed-variant: '#005312'
  tertiary-fixed: '#ffdbca'
  tertiary-fixed-dim: '#ffb68e'
  on-tertiary-fixed: '#331200'
  on-tertiary-fixed-variant: '#763300'
  background: '#f1fdeb'
  on-background: '#141e13'
  surface-variant: '#dae6d4'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Inter
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: 0em
  headline-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0em
  title-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
    letterSpacing: 0.01em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.01em
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.02em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.03em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.03em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  margin-tablet: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system is engineered for Indonesian rice farmers (*petani padi*) and agricultural field extension officers (*Petugas Penyuluh Lapangan* / PPL). The visual aesthetic pairs a calm, grounded agricultural identity with rigorous high-contrast ergonomics required for outdoor operation under direct, intense equatorial sunlight.

The interface combines Material 3 foundational logic with tactile clarity:
- **Tone:** Pragmatic, trustworthy, dignified, and rooted in the soil.
- **Visual Movement:** High-Contrast Utilitarian Modernism merged with Organic Calm. It departs from glossy tech tropes in favor of robust, solid surfaces, clear bounding containers, and immediate operational legible cues.
- **Accessibility & Field Usability:** Every interaction respects wet, dirty fingers, glare reflections, and low-cost Android hardware displays (IPS LCD with limited nit brightness). Target touch boundaries adhere to an absolute minimum of 48×48dp, scaling to 56dp for primary action vectors.
- **Language & Cultural Ergonomics:** Visual metaphors, iconography, and copy reflect regional agronomic practices in natural, respectful, and unambiguous Bahasa Indonesia.

## Colors

The color palette addresses ambient glare in open sawah (paddy field) environments while maintaining a calming, organic presence.

### Primary & Functional Roles
- **Primary (`#133E26`):** Deep Forest Green. Used for structural top app bars, primary high-priority buttons, key navigation indicators, and high-emphasis framing.
- **Secondary (`#2E7D32`):** Fresh Leaf Vibrant Green. Used for active progress states, successful confirmation elements, verified stamps, and auxiliary actions.
- **Tertiary Accent (`#B45309`):** Restrained Warm Harvest Amber. Deployed for harvest alerts, pending diagnostics, and attention-required items.
- **Base Canvas (`#F7F9F5`):** Warm Paddy Off-White. Mitigates ocular fatigue caused by pure `#FFFFFF` under intense sunlight while delivering high contrast against primary ink.
- **Card Surface (`#FFFFFF`):** High-clarity elevated surface.
- **Card Surface Variant (`#F1F5ED`):** Tonal surface for grouped parameters, soil data readouts, and table cells.

### Text Contrast Hierarchy
- **Text Primary (`#192318`):** Deep peat black-green. Exceeds WCAG AAA against canvas backgrounds.
- **Text Secondary (`#445142`):** Muted foliage slate. Preserves readability for supporting descriptions and measurement units outdoors.
- **Text Inverted (`#FFFFFF`):** Clean white for buttons and primary headers.

### Status Indicators
Status communication must **never rely on color alone**; every status state pairs its respective color with an explicit, standardized Material symbol and descriptive Bahasa Indonesia text label:
- **Sehat / Optimal (Healthy):** Rich Nature Green (`#15803D`) + `check_circle` icon.
- **Peringatan / Hama Terdeteksi (Disease/Pest Warning):** Warm Rust Orange (`#C2410C`) + `warning` icon.
- **Perlu Verifikasi (Uncertain/Needs Check):** Slate Amber (`#B45309`) + `help` / `schedule` icon.
- **Kritis / Bahaya (Critical Error/Alert):** Burnt Red (`#B91C1C`) + `error` icon.

## Typography

The typographic system utilizes **Inter** across all roles to ensure geometric clarity, high x-height, distinct letterforms (avoiding confusion between `I`, `l`, and `1`), and clear diacritics.

### Outdoor Legibility Principles
- **Weight Calibration:** Body text stays at weight `400` or higher; headings utilize weight `600` and `700` to prevent letter collapse under bright outdoor scattering. Light weights (`< 400`) are prohibited.
- **Numbers and Metrics:** When presenting vital crop figures (e.g., pH tanah, luas petak, dosis pupuk), values must be rendered in `headline-md` or `title-lg` with tabular or monospace figures to prevent optical jitter.
- **Information Density:** Avoid extended run-on prose. Field notes and diagnostic steps must be broken down into structured bullet points or step cards with generous line heights (`lineHeight >= 1.4x`).

## Layout & Spacing

The layout model adapts to standard Android screen widths (360dp to 412dp) as well as rugged field tablets utilized by agricultural extension workers (600dp to 840dp).

### Grid & Margins
- **Mobile (portrait < 600dp):** Single-column stack with `margin: 1rem` (16dp) and `gutter: 1rem` (16dp). Content spans the full fluid width between margins.
- **Tablet (landscape/field >= 600dp):** Two-column master-detail layout with `margin-tablet: 1.5rem` (24dp). The master pane holds petak sawah lists/inspections; the detail pane renders diagnoses and action plans.

### Ergonomics of Spacing
- Vertical rhythm strictly follows a 4dp/8dp base unit.
- Interactive targets must incorporate `space-sm` or `space-md` gaps to prevent mis-taps when navigating one-handed in the field.
- Bottom actions are anchored with dynamic safe area insets plus `space-md` bottom clearance to accommodate Android system gesture navigation bars.

## Elevation & Depth

To avoid optical wash-out under high-ambient-lux conditions, this design system does not rely on soft, delicate ambient blurs or low-contrast neomorphic shadows. Instead, it pairs deliberate tonal elevation with structural hairline borders.

### Elevation Levels
- **Level 0 (Kanvas / Background):** `#F7F9F5` flat surface. No shadow.
- **Level 1 (Kartu Konten / Cards):** Surface `#FFFFFF` bordered by a 1dp crisp outline `#E1E7DC`. A subtle grounding shadow: `0px 2px 4px rgba(25, 35, 24, 0.06)`.
- **Level 2 (Menu Melayang & Navigasi / Floating App Bar & Sheets):** Surface `#FFFFFF` with outline `#D4DDCF` and shadow: `0px 4px 12px rgba(25, 35, 24, 0.12)`.
- **Level 3 (Modal Dialog & Peringatan Mendesak):** Shadow `0px 8px 24px rgba(25, 35, 24, 0.18)` over a 40% opacity scrim (`rgba(25, 35, 24, 0.40)`).

Glassmorphism and ultra-faint borders are prohibited because field glare makes low-contrast translucency illegible.

## Shapes

The system uses balanced, accessible rounding (Material 3 medium-scale curvature) to achieve an approachable, sturdy feel that remains clearly defined against the backdrop.

- **Buttons & Chips:** Pill or 12dp–16dp rounded geometries provide clear tactile bounds.
- **Cards & Bottom Sheets:** 16dp corner radiuses on cards; 24dp top corner radiuses on persistent bottom sheets.
- **Status Badges:** Fully rounded capsule/pill shape (`rounded-full`) to immediately differentiate metadata tags from interactive square buttons.

## Components

### 1. Tombol (Buttons)
- **Tombol Utama (Primary):** Height 52dp–56dp. Solid background `#133E26`, text and icons `#FFFFFF`, 16dp rounded radius. Full width on mobile screens for easy thumb reach.
- **Tombol Sekunder (Secondary / Outlined):** Height 48dp–52dp. 1.5dp border `#133E26`, transparent surface, text `#133E26`.
- **Tombol Bahaya / Darurat (Critical):** Height 52dp. Background `#B91C1C`, text `#FFFFFF`. Used strictly for destructive actions (e.g., *Hapus Data Panen*).

### 2. Status Chips & Badges
- Structured with icon (18dp) + label text (`label-md`).
- Minimum height of 32dp for view-only badges; 44dp for filter chips to preserve touch ergonomics.
- **Format:**
  - *Sehat:* Surface `#DCFCE7`, border `#15803D`, text `#15803D`, icon `check_circle`.
  - *Peringatan Hama:* Surface `#FFEDD5`, border `#C2410C`, text `#9A3412`, icon `warning`.
  - *Perlu Tindakan:* Surface `#FEF3C7`, border `#B45309`, text `#92400E`, icon `schedule`.
  - *Gagal / Error:* Surface `#FEE2E2`, border `#B91C1C`, text `#991B1B`, icon `error`.

### 3. Kartu Pemeriksaan (Inspection & Plant Health Cards)
- Background `#FFFFFF` with 1dp border `#E1E7DC` and 16dp border radius.
- Padding: `space-md` (16dp).
- Header contains an iconized status badge on the top right, followed by diagnosis title (`headline-sm`) and timestamp.
- Action items at card bottom have a minimum height of 48dp.

### 4. Bilah Atas Aplikasi (Top App Bar)
- Surface `#133E26` with title and action icons in `#FFFFFF`.
- Displays the app mark featuring the stylized rice stalk/leaf motif alongside the module title (e.g., *Deteksi Penyakit Padi*).
- Elevation Level 0 with a clean boundary, seamlessly anchoring the status bar on Android.

### 5. Input Formulir (Form Fields)
- Outlined style with a minimum container height of 56dp.
- Inactive border `#8A9886` (1.5dp), focused border `#133E26` (2dp).
- Helper and error text rendered in `label-md` with dedicated warning icons. Touch-activated dropdowns trigger a native Android bottom sheet picker instead of small dropdown menus.

### 6. Lembar Bawah (Bottom Sheets)
- Used for soil condition updates, spray dosage calculators, and photo capture options.
- Top corners rounded at 24dp with a 48×4dp handle in `#CAD3C4` at the top center.

### 7. Banner Cuaca & Peringatan Lapangan (Field Alert Banners)
- High-contrast edge-to-edge or margin-aligned container with 12dp border radius.
- Uses high-luminance, rich warning backgrounds (e.g., `#FFFBEB` with `#B45309` left accent border of 4dp) to surface impending rainfall, pest outbreaks (wereng/blas), and planting calendar advisories.