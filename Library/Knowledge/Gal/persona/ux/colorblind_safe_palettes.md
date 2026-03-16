---
title: Colorblind-Safe and Universal Accessibility Color Palettes
source_url: Multiple (Visme, Venngage, Martin Krzywinski, Perkins School)
category: ux
tags: colorblind, accessibility, color-palettes, universal-design, vision-impairment, inclusive
relevant_agents: builder, brainstorm, checker, orca
fetched_date: 2026-02-04
last_updated: 2026-02-04
content_type: reference
difficulty: intermediate
description: Comprehensive guide to color palettes that work for all users including those with color vision deficiencies and low vision
keywords: colorblind, deuteranopia, protanopia, tritanopia, universal design, accessible colors, high contrast
copyright_notice: "See Library/Sources/Legal/FETCHING_DISCLAIMER.md"
---

> **Attribution:** Research compiled from Visme, Venngage, Martin Krzywinski's palettes, Perkins School, and various accessibility resources on 2026-02-04.

# Colorblind-Safe and Universal Accessibility Color Palettes

## Why This Matters

**~300 million people worldwide are colorblind:**
- 8% of males have some form of color vision deficiency
- 0.5% of females are affected
- This is roughly 1 in 12 men and 1 in 200 women

**Additional vision impairments:**
- 285 million people have visual impairments globally
- 39 million are blind, 246 million have low vision
- Age-related vision changes affect most people over 60

**Key insight:** "Colorblind-friendly" vs "accessible" are different. Accessible design addresses ALL visual impairments, not just color blindness.

---

## Types of Color Blindness

### Red-Green Color Blindness (Most Common: ~99% of cases)

| Type | Affects | Prevalence | What They See |
|------|---------|------------|---------------|
| **Deuteranomaly** | Green (reduced) | 5% of males | Greens appear faded |
| **Deuteranopia** | Green (absent) | 1% of males | No green, appears gray/yellow/brown |
| **Protanomaly** | Red (reduced) | 1% of males | Reds appear faded |
| **Protanopia** | Red (absent) | 1% of males | No red, appears brown/orange |

### Blue-Yellow Color Blindness (Rare)

| Type | Affects | Prevalence | What They See |
|------|---------|------------|---------------|
| **Tritanomaly** | Blue (reduced) | 0.01% | Blues appear faded |
| **Tritanopia** | Blue (absent) | 0.01% | No blue, blue appears green |

### Complete Color Blindness (Very Rare)

| Type | Affects | Prevalence | What They See |
|------|---------|------------|---------------|
| **Achromatopsia** | All color | 0.003% | Grayscale only |

---

## Color Combinations to AVOID

### Problematic Pairs

| Combination | Why It Fails | Affects |
|-------------|--------------|---------|
| **Red + Green** | Indistinguishable | 99% of colorblind users |
| **Green + Brown** | Appear identical | Deuteranopia, protanopia |
| **Red + Black** | Red appears very dark | Protanopia |
| **Blue + Purple** | Difficult to distinguish | Tritanopia |
| **Green + Yellow** | Too similar | Deuteranopia |
| **Light gray + White** | Low contrast | All users, especially low vision |
| **Yellow + White** | Extremely low contrast | Everyone |
| **Blue + Green** | Can merge | Some tritanopia |

### Absolute Avoid List

```
❌ Red (#FF0000) + Green (#00FF00)
❌ Light Green (#90EE90) + Light Gray (#D3D3D3)
❌ Yellow (#FFFF00) on White (#FFFFFF)
❌ Pink (#FFC0CB) + Light Gray (#D3D3D3)
❌ Blue (#0000FF) + Purple (#800080)
```

---

## Colorblind-Safe Color Palettes

### Wong Palette (8 Colors - Scientific Standard)

Developed by Bang Wong for Nature Methods, widely used in scientific visualization.

| Color | Name | Hex | RGB |
|-------|------|-----|-----|
| 🟠 | Orange | `#E69F00` | 230, 159, 0 |
| 🔵 | Sky Blue | `#56B4E9` | 86, 180, 233 |
| 🟢 | Bluish Green | `#009E73` | 0, 158, 115 |
| 🟡 | Yellow | `#F0E442` | 240, 228, 66 |
| 🔷 | Blue | `#0072B2` | 0, 114, 178 |
| 🟤 | Vermillion | `#D55E00` | 213, 94, 0 |
| 🟣 | Reddish Purple | `#CC79A7` | 204, 121, 167 |
| ⬛ | Black | `#000000` | 0, 0, 0 |

**Use case:** Charts, graphs, data visualization

---

### Tol Palette (Qualitative - 12 Colors)

Designed by Paul Tol for distinguishable categorical data.

| Color | Hex | Description |
|-------|-----|-------------|
| Tol 1 | `#332288` | Dark purple |
| Tol 2 | `#117733` | Forest green |
| Tol 3 | `#44AA99` | Teal |
| Tol 4 | `#88CCEE` | Light blue |
| Tol 5 | `#DDCC77` | Sand |
| Tol 6 | `#CC6677` | Rose |
| Tol 7 | `#AA4499` | Purple |
| Tol 8 | `#882255` | Wine |
| Tol 9 | `#661100` | Brown |
| Tol 10 | `#999933` | Olive |
| Tol 11 | `#6699CC` | Blue |
| Tol 12 | `#DDDDDD` | Gray |

---

### IBM Carbon Design System (Accessible)

IBM's accessibility-first color system.

| Purpose | Color | Hex |
|---------|-------|-----|
| Primary | Blue 60 | `#0F62FE` |
| Success | Green 50 | `#24A148` |
| Warning | Yellow 30 | `#F1C21B` |
| Danger | Red 60 | `#DA1E28` |
| Support | Purple 60 | `#8A3FFC` |
| Neutral | Gray 80 | `#393939` |

---

### Blue-Orange Safe Palette

The safest two-color combination for all color blindness types.

| Color | Hex | Use |
|-------|-----|-----|
| Dark Blue | `#1F77B4` | Primary |
| Orange | `#FF7F0E` | Accent/contrast |
| Medium Blue | `#2C9FCB` | Secondary |
| Light Orange | `#FFB74D` | Highlight |

**Why it works:** Blue and orange are on opposite ends of the color spectrum and remain distinguishable for virtually all color vision deficiencies.

---

## High Contrast for Low Vision

### Maximum Contrast Pairs

| Background | Text | Contrast | Use Case |
|------------|------|----------|----------|
| `#000000` | `#FFFFFF` | 21:1 | Maximum, can be harsh |
| `#1A1A1A` | `#F5F5F5` | 17.4:1 | Softer maximum |
| `#FFFFFF` | `#000000` | 21:1 | Light mode maximum |
| `#0D0D0D` | `#FFFF00` | 19.6:1 | High visibility |
| `#000080` | `#FFFFFF` | 12.6:1 | Navy + white |
| `#004D40` | `#FFFFFF` | 10.1:1 | Dark teal + white |

### Avoid Low Contrast

| Background | Text | Contrast | Problem |
|------------|------|----------|---------|
| `#FFFFFF` | `#808080` | 3.9:1 | Fails AA |
| `#F5F5F5` | `#C0C0C0` | 1.6:1 | Unreadable |
| `#333333` | `#666666` | 2.8:1 | Fails AA |
| `#FFFF00` | `#FFFFFF` | 1.07:1 | Nearly invisible |

---

## Universal Design Principles

### 1. Never Rely on Color Alone

**Bad:**
```
❌ "Required fields are marked in red"
❌ Error states only indicated by color
❌ Chart segments differentiated only by color
```

**Good:**
```
✅ "Required fields are marked with * and red"
✅ Error states have icon + color + text
✅ Chart segments have color + pattern + labels
```

### 2. Use Patterns and Textures

For data visualization:

| Pattern | Description | Paired With |
|---------|-------------|-------------|
| Solid | No pattern | Blue |
| Diagonal lines | /// | Orange |
| Dots | ●●● | Green |
| Crosshatch | +++ | Purple |
| Horizontal lines | === | Teal |

### 3. Provide Color Customization

Allow users to:
- Choose their own color schemes
- Enable high contrast mode
- Adjust text/background colors
- Use system accessibility settings

### 4. Test with Simulators

**Tools:**
- Chrome DevTools → Rendering → Emulate vision deficiencies
- [Coblis Colorblind Simulator](https://www.color-blindness.com/coblis-color-blindness-simulator/)
- [Stark Figma Plugin](https://www.getstark.co/)

---

## Status Colors (Universal)

### Traffic Light Alternative

Don't use red/green alone. Add shapes and text.

| Status | Color | Shape | Text |
|--------|-------|-------|------|
| Error | Red `#DC2626` | ✕ (X) | "Error" |
| Success | Blue-Green `#059669` | ✓ (check) | "Success" |
| Warning | Orange `#D97706` | ⚠ (triangle) | "Warning" |
| Info | Blue `#2563EB` | ℹ (info) | "Info" |

### Safe Status Palette

| Status | Primary | Secondary | Works For |
|--------|---------|-----------|-----------|
| Positive | `#059669` (teal) | `#10B981` | All CVD |
| Negative | `#DC2626` (red) | `#EF4444` | All CVD |
| Neutral | `#3B82F6` (blue) | `#60A5FA` | All CVD |
| Alert | `#F59E0B` (amber) | `#FBBF24` | All CVD |

---

## Testing Checklist

### Visual Testing

- [ ] Test with Chrome DevTools color blindness emulation
- [ ] Test with Deuteranopia simulation
- [ ] Test with Protanopia simulation
- [ ] Test with Tritanopia simulation
- [ ] Test with Achromatopsia simulation
- [ ] Test with high contrast mode
- [ ] Test with inverted colors
- [ ] Test in grayscale

### Design Validation

- [ ] No information conveyed by color alone
- [ ] All text meets 4.5:1 contrast minimum
- [ ] Large text meets 3:1 contrast minimum
- [ ] Adjacent colors are distinguishable
- [ ] Icons/shapes support color meaning
- [ ] Labels are present where needed
- [ ] Works when printed in grayscale

---

## Quick Reference: Safe Combinations

### Always Safe

| Pair | Use Case |
|------|----------|
| Blue + Orange | Primary contrast |
| Blue + Yellow | Caution/action |
| Dark blue + White | Text/background |
| Black + Yellow | High visibility |
| Purple + Orange | Creative accent |

### Conditionally Safe (Use with Patterns)

| Pair | Condition |
|------|-----------|
| Red + Blue | Add icons/text |
| Green + Blue | Add patterns |
| Purple + Pink | Ensure contrast |

### Always Add Redundancy For

| Use | Redundancy Needed |
|-----|-------------------|
| Error/success states | Icon + text + color |
| Charts/graphs | Pattern + label + color |
| Navigation states | Shape + text + color |
| Form validation | Icon + text + color |

---

## Sources

- [Visme: Color Blind Friendly Palettes](https://visme.co/blog/color-blind-friendly-palette/)
- [Venngage: Colorblind-Friendly Palettes](https://venngage.com/blog/color-blind-friendly-palette/)
- [Martin Krzywinski Palettes](https://mk.bcgsc.ca/colorblind/palettes.mhtml)
- [Coloring for Colorblindness](https://davidmathlogic.com/colorblind/)
- [Perkins School: High Contrast for Low Vision](https://www.perkins.org/resource/choosing-high-contrast-color-schemes-for-low-vision/)
- [Komodo Digital: Colour Accessibility](https://www.komododigital.co.uk/insights/inclusive-design-colour-accessibility/)

---

## AutoMates Alignment

This guide ensures AutoMates products work for everyone:

- **Builder** - Implementing accessible color systems
- **Checker** - Validating color accessibility
- **BrainStorm** - Designing inclusive features
- **Orca** - Agent identity colors that work for all users

**For Claude-Mates terminals:** The recommended colors in `terminal_colors.md` maintain color identity while prioritizing contrast. Users with color vision deficiencies can still distinguish agents by terminal position and the agent name in the prompt.

**Key insight:** True accessibility means designing for the widest possible range of users from the start, not as an afterthought.
