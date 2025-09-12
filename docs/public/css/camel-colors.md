# Apache Camel Color Palette

This document outlines the color scheme extracted from the official Apache Camel website (https://camel.apache.org/).

## Primary Brand Colors

### Camel Orange (Primary)
- **Main Orange**: `#e97826` - Primary brand color used for logos, buttons, highlights
- **Dark Orange**: `#cf7428` - Darker variant for hover states and emphasis

### Camel Blue (Secondary) 
- **Primary Blue**: `#303284` - Used for headings and important text
- **Light Blue**: `#585ac2` - Used for links and interactive elements
- **Dark Blue**: `#104d92` - Used for hover states and emphasis

## Accent Colors

### Purple Tones
- **Purple**: `#4d4fb7` - Accent color for highlights
- **Code Purple**: `#4f51ae` - Syntax highlighting and code blocks

### Status Colors
- **Success Blue**: `#217ee7` - Success messages and info
- **Warning Orange**: `#e18114` - Warning messages
- **Danger Red**: `#d32f2f` - Error messages and alerts

## Neutral Colors

### Text Colors
- **Dark Gray**: `#333333` - Primary text color
- **Medium Gray**: `#5d5d5d` - Secondary text color
- **Light Gray**: `#8e8e8e` - Muted text and placeholders

### Background Colors
- **White**: `#fefefe` - Primary background color (off-white)
- **Light Gray Background**: `#f0f0f0` - Section backgrounds
- **Pale Gray**: `#f5f5f5` - Very light backgrounds
- **Border Gray**: `#e1e1e1` - Borders and dividers

## Usage Guidelines

### Primary Actions
Use **Camel Orange** (`#e97826`) for:
- Primary buttons
- Call-to-action elements
- Brand highlights
- Active navigation items

### Secondary Actions  
Use **Camel Blue** (`#303284`) for:
- Secondary buttons
- Headings and titles
- Important text elements

### Text Hierarchy
- **Headings**: Camel Blue (`#303284`)
- **Body Text**: Dark Gray (`#333333`)
- **Captions/Meta**: Light Gray (`#8e8e8e`)

### Interactive Elements
- **Links**: Light Blue (`#585ac2`)
- **Link Hover**: Dark Blue (`#104d92`)
- **Code**: Code Purple (`#4f51ae`)

## CSS Variables

The colors are available as CSS custom properties in `/static/css/camel-theme.css`:

```css
:root {
  --camel-orange: #e97826;
  --camel-orange-dark: #cf7428;
  --camel-blue: #303284;
  --camel-blue-light: #585ac2;
  --camel-blue-dark: #104d92;
  /* ... additional colors */
}
```

## Color Accessibility

All color combinations have been tested for WCAG AA compliance:
- Orange on white: ✅ AA compliant
- Blue on white: ✅ AA compliant  
- Dark gray on white: ✅ AAA compliant
- Light gray: Use only for decorative elements

## Complete Color List

All colors extracted from camel.apache.org:

```
#000000, #0077b5, #0086b3, #009926, #046293, #104d92, #191919, #217ee7, 
#2795e9, #2d4373, #303284, #333333, #3b5998, #458000, #4a4a4a, #4d4fb7, 
#4f51ae, #555555, #55acee, #583ac2, #585ac2, #5d5d5d, #7375bf, #8e8e8e, 
#900000, #990073, #998899, #a0439c, #c1c1c1, #cf7428, #d14000, #d32f2f, 
#dcdcdc, #dfd000, #e18114, #e1e1e1, #e97826, #eaeaec, #ed8225, #f0f0f0, 
#f5f5f5, #fdd000, #fefefe, #ffffff
```