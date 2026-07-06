# 🎨 Next.js Design System — Color Tokens Reference for Flutter

Branch: `feature/audit-form-enhancements`

---

## 1. Backgrounds

| Token | Light Hex | Light Name | Dark Hex | Dark Name | Flutter Usage |
|-------|-----------|------------|----------|-----------|---------------|
| `--bg-page` | `#F1F5F9` | slate-100 | `#0F172A` | slate-900 | `Scaffold.backgroundColor` |
| `--bg-card` | `#FFFFFF` | white | `#1E293B` | slate-800 | `Card`, `Container` พื้นหลัง |
| `--bg-card-alt` | `#F8FAFC` | slate-50 | `#334155` | slate-700 | Table header, Card alternate |
| `--bg-input` | `#F8FAFC` | slate-50 | `#1E293B` | slate-800 | `TextField`, `DropdownButtonFormField` |
| `--bg-sidebar` | `#1E293B` | slate-800 | `#020617` | slate-950 | Sidebar / NavBar |

## 2. Foregrounds (Text)

| Token | Light Hex | Light Name | Dark Hex | Dark Name | Flutter Usage |
|-------|-----------|------------|----------|-----------|---------------|
| `--fg-primary` | `#0F172A` | slate-900 | `#F1F5F9` | slate-100 | `Text` หลักทั่วไป |
| `--fg-secondary` | `#475569` | slate-600 | `#94A3B8` | slate-400 | รายละเอียดรอง (description) |
| `--fg-muted` | `#94A3B8` | slate-400 | `#64748B` | slate-500 | ข้อความจาง, hint, placeholder |
| `--fg-on-dark` | `#F1F5F9` | slate-100 | `#0F172A` | slate-900 | ข้อความบนพื้นสีเข้ม |

## 3. Accent (Blue)

| Token | Light Hex | Light Name | Dark Hex | Dark Name | Flutter Usage |
|-------|-----------|------------|----------|-----------|---------------|
| `--accent` | `#2563EB` | blue-600 | `#3B82F6` | blue-500 | **ปุ่มกดหลัก**, selected, active |
| `--accent-hover` | `#1D4ED8` | blue-700 | `#60A5FA` | blue-400 | Hover state |
| `--accent-light` | `#DBEAFE` | blue-100 | `#1E3A5F` | — | **BG ตอนเลือก/active** (selected row, card) |
| `--accent-text` | `#1E40AF` | blue-800 | `#93C5FD` | blue-300 | สีข้อความ accent, assetNo |

## 4. Status Colors

| Token | Light Hex | Light Name | Dark Hex | Dark Name | Flutter Usage |
|-------|-----------|------------|----------|-----------|---------------|
| `--success` | `#059669` | emerald-600 | `#10B981` | emerald-500 | ✅ สำเร็จ |
| `--success-light` | `#D1FAE5` | emerald-100 | `#064E3B` | emerald-900 | พื้นหลัง success |
| `--warning` | `#D97706` | amber-600 | `#F59E0B` | amber-500 | ⚠️ คำเตือน, lastCondition |
| `--warning-light` | `#FEF3C7` | amber-100 | `#78350F` | amber-900 | พื้นหลัง warning |
| `--danger` | `#DC2626` | red-600 | `#EF4444` | red-500 | ❌ Error |
| `--danger-light` | `#FEE2E2` | red-100 | `#7F1D1D` | red-900 | พื้นหลัง error |

## 5. Borders

| Token | Light Hex | Light Name | Dark Hex | Dark Name | Flutter Usage |
|-------|-----------|------------|----------|-----------|---------------|
| `--border` | `#E2E8F0` | slate-200 | `#334155` | slate-700 | เส้นขอบทั่วไป |
| `--border-accent` | `#BFDBFE` | blue-200 | `#1E40AF` | blue-800 | เส้นขอบตอน active/selected |

## 6. Shadows

| Token | Light | Dark |
|-------|-------|------|
| `--shadow-sm` | `0 1px 2px rgba(0,0,0,0.05)` | `0 1px 2px rgba(0,0,0,0.3)` |
| `--shadow-md` | `0 4px 6px -1px rgba(0,0,0,0.08), 0 2px 4px -2px rgba(0,0,0,0.05)` | `0 4px 6px -1px rgba(0,0,0,0.4), 0 2px 4px -2px rgba(0,0,0,0.3)` |
| `--shadow-lg` | `0 10px 15px -3px rgba(0,0,0,0.08), 0 4px 6px -4px rgba(0,0,0,0.04)` | `0 10px 15px -3px rgba(0,0,0,0.4), 0 4px 6px -4px rgba(0,0,0,0.3)` |

## 7. NavBar / AppBar

| Element | Light | Dark | Notes |
|---------|-------|------|-------|
| Nav BG | `#FFFFFF` (`--bg-card`) | `#1E293B` (`--bg-card`) | |
| Nav border bottom | `#E2E8F0` (`--border`) | `#334155` (`--border`) | |
| Title "AssetApp" | `#0F172A` (`--fg-primary`) | `#F1F5F9` (`--fg-primary`) | `text-base` (16px), `font-bold` |
| Link inactive | `#475569` (`--fg-secondary`) | `#94A3B8` (`--fg-secondary`) | `text-xs` (12px), `font-medium` |
| Link hover | `#0F172A` (`--fg-primary`), BG: `#F8FAFC` | `#F1F5F9`, BG: `#334155` | |
| Link active | **White** on `#2563EB` (`--accent`) | **White** on `#3B82F6` (`--accent`) | BG: accent, text: white |
| Email text | `#475569` (`--fg-secondary`) | `#94A3B8` (`--fg-secondary`) | `text-[10px]` |
| Nav height | `h-14` = **56px** | | |

## 8. Table (AssetTable / AssetRow)

| Element | Light | Dark | Font Size |
|---------|-------|------|-----------|
| Table wrapper | BG: `#FFFFFF`, Border: `#E2E8F0` | BG: `#1E293B`, Border: `#334155` | |
| Table header | BG: `#F8FAFC` (`--bg-card-alt`) | BG: `#334155` (`--bg-card-alt`) | **10px**, `uppercase`, `font-bold` |
| Row normal | BG: `transparent` | BG: `transparent` | |
| Row selected | BG: `#DBEAFE` (`--accent-light`), left border: 4px `#2563EB` | BG: `#1E3A5F`, left border: 4px `#3B82F6` | |
| Row audited | `opacity: 70%` | `opacity: 70%` | |

### 8.1 Text in Table Row

| Element | Color (Light) | Color (Dark) | Font Size | Weight |
|---------|--------------|--------------|-----------|--------|
| assetNo | `#1E40AF` (`--accent-text`) | `#93C5FD` (`--accent-text`) | **13px** | `bold` |
| assetClass suffix | `#94A3B8` (`--fg-muted`) | `#64748B` (`--fg-muted`) | 13px | `normal` |
| description | `#475569` (`--fg-secondary`) | `#94A3B8` (`--fg-secondary`) | **10px** | `normal` |
| assetClassName | `#94A3B8` (`--fg-muted`) | `#64748B` (`--fg-muted`) | **9px** | `italic` |
| lastCondition | `#D97706` (`--warning`) | `#F59E0B` (`--warning`) | **8px** | `medium` |
| lastLocation | `#94A3B8` (`--fg-muted`) | `#64748B` (`--fg-muted`) | **10px** | `italic` |

### 8.2 Badge (Environment / Mobility)

| Badge | Light BG | Light Text | Dark BG | Dark Text |
|-------|----------|------------|---------|-----------|
| Outdoor | `#FEF3C7` (`--warning-light`) | `#D97706` (`--warning`) | `#78350F` | `#F59E0B` |
| Indoor | `#DBEAFE` (`--accent-light`) | `#1E40AF` (`--accent-text`) | `#1E3A5F` | `#93C5FD` |
| Fixed | `#F3E8FF` | `#7C3AED` | `#3B1F6E` | `#A78BFA` |
| Portable | `#CCFBF1` | `#0F766E` | `#134E4A` | `#5EEAD4` |
| Unknown/Fallback | `#F8FAFC` (`--bg-card-alt`) | `#94A3B8` (`--fg-muted`) | `#334155` | `#64748B` |

### 8.3 Thumbnail

| Element | Value |
|---------|-------|
| Size | `w-10 h-10` = **40×40 px** |
| Border Radius | `rounded-lg` = **8px** |
| Border | `--border` (1px) |
| Fallback icon | 📷, `#94A3B8` (`--fg-muted`) |

## 9. Cost Center Selector

| Element | Light | Dark | Font Size |
|---------|-------|------|-----------|
| Label "Select Cost Center" | `#475569` (`--fg-secondary`) | `#94A3B8` (`--fg-secondary`) | **12px**, `bold`, `uppercase`, `tracking-wider` |
| Subtext count | `#94A3B8` (`--fg-muted`) | `#64748B` (`--fg-muted`) | **10px** |

### 9.1 Button States

| State | BG | Border | Text | Notes |
|-------|----|--------|------|-------|
| **Inactive** (All) | `#FFFFFF` (`--bg-card`) | `#E2E8F0` (`--border`) | `#475569` (`--fg-secondary`) | |
| **Active** (All) | **`#1D4ED8`** (blue-700) | **`#1D4ED8`** | **White** | |
| **Inactive** (ราย CC) | `#FFFFFF` (`--bg-card`) | `#E2E8F0` (`--border`) | `#475569` (`--fg-secondary`) | |
| **Active** (ราย CC) | **`#1D4ED8`** (blue-700) | **`#1D4ED8`** | **White** | |
| CC name inactive | `#94A3B8` (`--fg-muted`) | — | `--fg-muted` | `text-[9px]` |
| CC name active | `text-white/70` | — | `text-white/70` | |
| "remaining" inactive | `#D97706` (`--warning`) | — | `#F59E0B` | `text-[9px]` |
| "Done" inactive | `#059669` (`--success`) | — | `#10B981` | |
| "remaining" active | `text-white/80` | — | `text-white/80` | |

### 9.2 Dark Mode Button States

| State | Dark BG | Dark Border | Dark Text |
|-------|---------|-------------|-----------|
| **Inactive** (All) | `#1E293B` (`--bg-card`) | `#334155` (`--border`) | `#94A3B8` (`--fg-secondary`) |
| **Active** (All) | **`#1D4ED8`** (blue-700) | **`#1D4ED8`** | **White** |
| CC name inactive | `#64748B` (`--fg-muted`) | — | |
| "remaining" inactive | `#F59E0B` | — | |
| "Done" inactive | `#10B981` | — | |

## 10. Asset Class Picker

| Element | Light | Dark | Font Size |
|---------|-------|------|-----------|
| Label "Select Asset Class" | **`#B45309`** (amber-700) | **`#F59E0B`** | **12px**, `bold`, `uppercase`, `tracking-wider` |

### 10.1 Button States

| State | BG | Border | Text |
|-------|----|--------|------|
| **Inactive** (All) | `#FFFFFF` (`--bg-card`) | `#E2E8F0` (`--border`) | `#475569` (`--fg-secondary`) |
| **Active** (All) | **`#B45309`** (amber-700) | **`#B45309`** | **White** |
| **Inactive** (ราย class) | `#FFFFFF` (`--bg-card`) | `#E2E8F0` (`--border`) | `#475569` (`--fg-secondary`) |
| **Active** (ราย class) | **`#B45309`** (amber-700) | **`#B45309`** | **White** |
| Class completed | `opacity: 50%` | — | |
| "remaining" text inactive | `#059669` (`--success`) | — | |
| "remaining" text active | `text-white/80` | — | |
| Button font size | `text-[10px]`, `font-bold` | | |

### 10.2 Dark Mode Button States

| State | Dark BG | Dark Border | Dark Text |
|-------|---------|-------------|-----------|
| **Inactive** (All) | `#1E293B` (`--bg-card`) | `#334155` (`--border`) | `#94A3B8` (`--fg-secondary`) |
| **Active** (All) | **`#B45309`** (amber-700) | **`#B45309`** | **White** |

## 11. Audit Form

| Element | Light | Dark | Font Size |
|---------|-------|------|-----------|
| Label (LOCATION NAME, EVIDENCE PHOTO, etc.) | `#475569` (`--fg-secondary`) | `#94A3B8` (`--fg-secondary`) | **12px**, `bold` |
| Environment label | `#D97706` (amber-600) | `#F59E0B` | **12px**, `bold` |
| Mobility label | `#0F766E` (teal-700) | `#5EEAD4` | **12px**, `bold` |
| Asset Info Card BG | `#F8FAFC` (`--bg-card-alt`) | `#334155` (`--bg-card-alt`) | |
| Asset Info Card border | `#E2E8F0` (`--border`) | `#334155` (`--border`) | |
| Input / Select | BG: `#F8FAFC`, Border: `#E2E8F0` | BG: `#1E293B`, Border: `#334155` | |
| Input / Select (focus) | Border: `#2563EB` (`--accent`) | Border: `#3B82F6` (`--accent`) | |
| Submit button | BG: `#2563EB` (`--accent`), Text: White | BG: `#3B82F6` (`--accent`), Text: White | **16px**, `bold` |
| Submit button (disabled) | BG: `#94A3B8` (`--fg-muted`) | BG: `#64748B` | |

## 12. Font Sizes Summary

| Tailwind Class | Size | px | Usage |
|---------------|------|----|-------|
| `text-[8px]` | 8px | | lastCondition, remaining counter |
| `text-[9px]` | 9px | | assetClassName, Badge, CC name |
| `text-[10px]` | 10px | | description, table header, lastLocation, subtext, email |
| `text-xs` | 12px | | labels, button text, nav link |
| `text-sm` | 14px | | body text |
| `text-base` | 16px | | title "AssetApp", submit button |
| `font-bold` | — | 700 | |
| `font-medium` | — | 500 | |
| `font-normal` | — | 400 | |
| `tracking-wider` | — | `0.05em` | label letter spacing |

## 13. Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `rounded-lg` | 8px | Thumbnail, Badge, small elements |
| `rounded-xl` | 12px | Cards, Input fields, Select, Buttons |
| `rounded-2xl` | 16px | Large containers |
| `rounded-3xl` | 24px | Modal dialogs |
| `rounded-full` | 999px | Avatars, Theme toggle |

## 14. Quick Color Chart (Light)

```
#F1F5F9  ████████  bg-page (slate-100)
#FFFFFF  ████████  bg-card (white)
#F8FAFC  ████████  bg-card-alt, bg-input (slate-50)
#0F172A  ████████  fg-primary (slate-900)
#475569  ████████  fg-secondary (slate-600)
#94A3B8  ████████  fg-muted (slate-400)
#2563EB  ████████  accent (blue-600)
#DBEAFE  ████████  accent-light (blue-100)
#1E40AF  ████████  accent-text (blue-800)
#E2E8F0  ████████  border (slate-200)
#BFDBFE  ████████  border-accent (blue-200)
#059669  ████████  success (emerald-600)
#D97706  ████████  warning (amber-600)
#DC2626  ████████  danger (red-600)
#1D4ED8  ████████  selector active (blue-700)
#B45309  ████████  asset class active (amber-700)
```

## 15. Quick Color Chart (Dark)

```
#0F172A  ████████  bg-page (slate-900)
#1E293B  ████████  bg-card, bg-input (slate-800)
#334155  ████████  bg-card-alt (slate-700)
#F1F5F9  ████████  fg-primary (slate-100)
#94A3B8  ████████  fg-secondary (slate-400)
#64748B  ████████  fg-muted (slate-500)
#3B82F6  ████████  accent (blue-500)
#1E3A5F  ████████  accent-light
#93C5FD  ████████  accent-text (blue-300)
#334155  ████████  border (slate-700)
#1E40AF  ████████  border-accent (blue-800)
#10B981  ████████  success (emerald-500)
#F59E0B  ████████  warning (amber-500)
#EF4444  ████████  danger (red-500)
#1D4ED8  ████████  selector active (blue-700)
#B45309  ████████  asset class active (amber-700)
```
