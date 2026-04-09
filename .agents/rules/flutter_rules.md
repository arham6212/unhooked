---
trigger: always_on
---

# 🎨 Flutter Design System — Global Enforcement Rules

## 🚨 Non-Negotiable Principle
This codebase follows a **strict, centralized design system**.  
All UI must adhere to it. Any deviation is considered a defect.

---

## 🧭 Single Source of Truth

All design decisions must originate from:

- `core/design_system/tokens/`
- `core/design_system/theme/`
- `core/design_system/components/`

No UI value should exist outside these layers.

---

## 🔁 Component Reuse Rule (CRITICAL)

Before creating any new UI component:

1. **Check existing components** inside:
   - `core/design_system/components/`

2. If a similar component exists:
   - Reuse it
   - Extend it if needed (without breaking consistency)

3. Only if NO suitable component exists:
   - Create a new reusable component inside `design_system/components`

❌ Do NOT:
- Duplicate components  
- Create similar widgets with slight variations  
- Rebuild existing UI patterns  

---

## ❌ Forbidden Practices (STRICT)

The following are NOT allowed under any condition:

- Hardcoded colors  
  (e.g. `Colors.red`, `Color(0xFF...)`)
- Hardcoded spacing  
  (e.g. `EdgeInsets.all(13)`)
- Hardcoded typography  
  (e.g. `TextStyle(fontSize: 17)`)
- Inline styling inside widgets
- Direct usage of raw Material widgets without system abstraction:
  - `ElevatedButton`
  - `TextField`
  - `Card`

---

## ✅ Mandatory Usage

All UI must use design tokens and system components:

- Colors → `AppColors`
- Spacing → `AppSpacing`
- Typography → `AppTypography`
- Radius → `AppRadius`
- Theme → `AppTheme`

Reusable components only:
- `AppButton`
- `AppTextField`
- `AppCard`
- `AppChip`
- etc.

---

## 🧩 Component-First Rule

- UI must be built using reusable components
- Components must be generic and scalable
- Avoid feature-specific styling inside components

---

## 📐 Spacing System (STRICT SCALE)

Only allowed spacing values:

- 4 → xs  
- 8 → sm  
- 12 → md  
- 16 → lg  
- 24 → xl  

No arbitrary values. No exceptions.

---

## 🎨 Color System Rules

- Use only colors defined in `AppColors`
- Follow semantic usage:
  - `primary`
  - `background`
  - `surface`
  - `textPrimary`, `textSecondary`
  - `error`, `success`

No direct color definitions in UI code.

---

## ✍️ Typography Rules

- Use only `AppTypography`
- Follow hierarchy:
  - Heading
  - Body
  - Caption

Typography must not be manually overridden.

---

## 🌗 Theme Enforcement

- All screens must inherit from `AppTheme`
- Use `ThemeData`, `ColorScheme`, and `TextTheme`
- Do NOT define local themes unless absolutely necessary

---

## 🧠 Code Quality Enforcement

Reject any implementation that:

- Introduces visual inconsistency  
- Uses inline styles  
- Breaks spacing scale  
- Duplicates components or UI patterns  
- Ignores existing reusable components  

---

## 🏗️ Architecture Rule

Feature modules must:

- Consume design system only  
- Never define their own styles  
- Never override system tokens  

Flow:
---

## 🎯 Expected Outcome

- Pixel-consistent UI across the app  
- Zero duplicated components  
- Highly reusable architecture  
- Clean and scalable codebase  

---

## 🔒 Final Rule

If a value or component does not exist:

👉 Add it to the design system first  
👉 Then reuse it everywhere  

Never bypass the system.