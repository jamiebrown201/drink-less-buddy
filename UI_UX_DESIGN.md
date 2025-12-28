## UI/UX Design System - Drink Less Buddy

### Brand Identity & Visual Design

The app features a **modern, wellness-focused** design that feels professional yet approachable. Unlike generic AI-generated apps, we've created a distinct brand with:

- **Soft, calming colors** with vibrant accents
- **Smooth, subtle animations** that enhance UX
- **Haptic feedback** for tactile engagement
- **Glass-morphism effects** for modern aesthetics
- **Micro-interactions** that delight users

---

## Design Principles

### 1. **Calm & Supportive**
- Soft color palette (blues, teals, purples)
- No harsh reds or aggressive warnings
- Encouragement over judgment

### 2. **Delightfully Responsive**
- Every interaction has feedback (haptic + visual)
- Smooth animations (200-500ms)
- Instant visual response

### 3. **Clear Hierarchy**
- Important metrics stand out (gradients, shadows)
- Secondary info recedes (soft grays)
- Clear call-to-action buttons

### 4. **Modern & Polished**
- Glass-morphism cards
- Gradient accents
- Smooth shadows and glows

---

## Color System

### Brand Colors
```dart
Primary Blue:    #5B8DEF (Softer, friendlier than harsh blue)
Secondary Teal:  #2DD4BF (Fresh, positive)
Accent Purple:   #8B5CF6 (Unique, memorable)
Warning Amber:   #FBBF24 (Warm, not alarming)
Danger Rose:     #F43F5E (Softer than pure red)
```

### Gradients
```dart
Primary:  Blue → Purple (Modern, tech-forward)
Success:  Teal → Green  (Achievement, wellness)
Warning:  Amber → Orange (Caution without stress)
```

### Neutrals
```dart
Background: #FAFAF8 (Off-white, reduces eye strain)
Surface:    #FFFFFF (Pure white for cards)
Text:       #1F2937 (Near-black, easier to read)
Secondary:  #6B7280 (Gray for less important text)
```

---

## Typography

**Font Family:** Inter (Clean, modern, highly readable)

### Type Scale
```
Display Large:   32px Bold   (Main headings)
Display Medium:  28px Bold   (Section headings)
Headline Large:  24px Bold   (Card titles)
Headline Medium: 20px Semibold
Title Large:     18px Semibold
Title Medium:    16px Semibold
Body Large:      16px Regular
Body Medium:     14px Regular (Most common)
Body Small:      12px Regular (Captions)
Label Large:     14px Semibold (Buttons)
```

### Typography Rules
- **Negative letter-spacing** on large headings (-0.5px to -0.3px)
- **Increased line-height** for body text (1.5)
- **Weight variations** for hierarchy (400, 600, 700)

---

## Spacing System

**8pt Grid** for consistency

```
4px   - Tight spacing
8px   - Small gaps
12px  - Medium gaps
16px  - Standard padding
20px  - Section spacing
24px  - Large padding
32px  - Section breaks
40px  - Major sections
48px  - Page sections
```

---

## Animations

### Duration
```dart
Fast:   200ms - Micro-interactions (button press)
Normal: 300ms - Standard transitions (page nav)
Slow:   500ms - Emphasis animations (progress bars)
```

### Curves
```dart
Default:     easeInOutCubic - Smooth, professional
Emphasized:  easeOutCubic   - Attention-grabbing
Decelerate:  easeOut        - Natural ending
Accelerate:  easeIn         - Quick start
Spring:      elasticOut     - Playful (use sparingly)
```

### Animation Types

#### 1. **Scale Button** (AnimatedScaleButton)
- Scales to 95% on press
- Haptic feedback on touch down
- Duration: 200ms
- **Use for:** All buttons, tappable cards

#### 2. **Slide Fade** (SlideFadeRoute)
- Slight upward slide (3% of height)
- Fades in simultaneously
- Duration: 300ms
- **Use for:** Page transitions

#### 3. **Staggered List** (StaggeredList)
- Items appear one after another
- 50ms delay between items
- Slide + fade combo
- **Use for:** Lists of drinks, tactics

#### 4. **Pulse** (PulseAnimation)
- Gentle scale (100% → 105%)
- 1.5s duration
- Repeating
- **Use for:** New achievements, alerts

#### 5. **Progress Bar** (AnimatedProgressBar)
- Animated fill from 0% to target
- 500ms duration
- Eased curve
- **Use for:** Week progress, goals

#### 6. **Shimmer** (ShimmerLoading)
- Gradient shimmer effect
- 1.5s duration
- Repeating
- **Use for:** Skeleton loading states

---

## Haptic Feedback

### Feedback Types
```dart
Light Impact:    Subtle interactions (selecting items)
Medium Impact:   Standard actions (button press)
Heavy Impact:    Important actions (delete)
Selection Click: Radio/checkbox selection
Vibrate:         Errors, warnings

// Custom patterns
Success:         Two light impacts (50ms apart)
Error:           One heavy impact
```

### When to Use
- ✅ Button press (medium)
- ✅ Item selection (light)
- ✅ Delete action (heavy)
- ✅ Success action (success pattern)
- ✅ Error state (error pattern)
- ❌ Don't overuse - only for direct user actions

---

## Components

### 1. **GlassButton**
```dart
// Primary action button
GlassButton(
  text: 'Log a Drink',
  icon: Icons.add_circle_outline,
  onPressed: () {},
  gradient: AppTheme.primaryGradient, // Optional
  isLoading: false, // Shows spinner
)
```

**Features:**
- Gradient background
- Glow shadow
- Scale animation on press
- Haptic feedback
- Loading state

### 2. **AnimatedCard**
```dart
// Interactive card with hover effect
AnimatedCard(
  onTap: () {},
  gradient: AppTheme.successGradient, // Optional
  child: YourContent(),
)
```

**Features:**
- Elevation animation on hover
- Optional gradient
- Shadow that grows on hover
- Scale animation on tap

### 3. **StatCard**
```dart
// Metric display card
StatCard(
  label: 'Avg per Session',
  value: '2.5',
  icon: Icons.analytics_outlined,
  gradient: AppTheme.primaryGradient, // Optional
  isPulsing: false, // Animate for emphasis
)
```

**Features:**
- Icon with colored background
- Large number display
- Optional gradient
- Optional pulse animation

### 4. **AnimatedProgressBar**
```dart
// Animated progress indicator
AnimatedProgressBar(
  progress: 0.75, // 0.0 to 1.0
  height: 10,
  gradient: AppTheme.successGradient,
  showPercentage: true,
)
```

**Features:**
- Animates from 0% to target
- Gradient fill
- Optional percentage label
- Glow effect

### 5. **StaggeredList**
```dart
// List with staggered entry animation
StaggeredList(
  delay: Duration(milliseconds: 50),
  children: [
    Widget1(),
    Widget2(),
    Widget3(),
  ],
)
```

**Features:**
- Items appear sequentially
- Slide + fade animation
- Customizable delay

---

## Shadows & Depth

### Card Shadow
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.04),
  blurRadius: 16,
  offset: Offset(0, 4),
)
```

### Elevated Shadow
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 24,
  offset: Offset(0, 8),
)
```

### Glow Shadow
```dart
BoxShadow(
  color: AppTheme.primaryBlue.withOpacity(0.3),
  blurRadius: 20,
  offset: Offset(0, 4),
)
```

**When to Use:**
- Card Shadow: Standard cards
- Elevated Shadow: Dialogs, bottom sheets
- Glow Shadow: Primary buttons, important metrics

---

## Border Radius

```dart
Small:   8px  - Chips, badges
Medium:  12px - Buttons, inputs
Large:   16px - Cards
X-Large: 24px - Modals, dialogs
Full:    999px - Pills, tags
```

---

## Micro-Interactions

### 1. **Button Press**
- Scale to 95%
- Haptic feedback
- 200ms duration
- Returns to 100% on release

### 2. **Card Hover**
- Shadow increases
- Slight elevation effect
- 200ms duration

### 3. **List Item Entry**
- Slide from bottom (10% of height)
- Fade in
- Stagger by 50ms
- 300ms duration

### 4. **Page Transition**
- Slide from bottom (3% of height)
- Fade in
- 300ms duration

### 5. **Progress Fill**
- Animate from 0% to target
- Eased curve
- 500ms duration

---

## Screen Examples

### Home Screen (Drinks Tab)

**Layout:**
```
App Bar (Floating)
  ├─ Title: "Track Your Drinks"
  └─ Subtitle: "Week of Dec 28"

Week Progress Card (Gradient)
  ├─ This Week header
  ├─ 12.5 / 14 units (Large text)
  ├─ Animated Progress Bar
  └─ Status message

Stats Row
  ├─ Avg per Session (Card)
  └─ Top Location (Card)

Intentions Card (Purple tint)
  ├─ Tomorrow's Intentions header
  ├─ List of intentions
  └─ "Set" button

Log Button (Gradient, Glowing)

Recent Drinks Header

Staggered List of Drinks
  └─ Each drink card with:
      ├─ Gradient icon
      ├─ Drink name (Bold)
      ├─ Units, mood, context
      ├─ Timestamp
      └─ Delete button
```

**Animations:**
1. Cards slide/fade in on load (staggered)
2. Progress bar animates to current value
3. Stats pulse if new data
4. Button scales on press

---

## Implementation Guidelines

### Do's ✅
- Use haptic feedback for all tappable elements
- Animate state changes (loading, error, success)
- Maintain consistent spacing (8pt grid)
- Use gradients for emphasis (primary actions)
- Stagger list animations
- Scale buttons on press

### Don'ts ❌
- Don't animate everything (overwhelming)
- Don't use harsh colors (stay soft)
- Don't skip loading states
- Don't ignore haptic feedback
- Don't use inconsistent spacing
- Don't make animations too long (>500ms)

---

## Accessibility

### Color Contrast
- All text meets WCAG AA standards
- Minimum 4.5:1 ratio for body text
- 3:1 for large text

### Touch Targets
- Minimum 44x44 points (iOS)
- 48x48 dp (Android)
- Spacing between targets: 8px minimum

### Animations
- Respect `prefers-reduced-motion`
- All animations can be disabled
- No essential information in animation-only

---

## Performance

### Animation Performance
- Use `const` constructors where possible
- Dispose controllers in `dispose()`
- Use `RepaintBoundary` for complex animations
- Limit simultaneous animations to 3-4

### Image Loading
- Lazy load images
- Show shimmer while loading
- Optimize image sizes

---

## Future Enhancements

### Phase 2
- [ ] Lottie animations for empty states
- [ ] Custom illustrations (hand-drawn style)
- [ ] Dark mode support
- [ ] Seasonal themes
- [ ] Achievement animations
- [ ] Confetti on milestones

### Phase 3
- [ ] 3D card effects (parallax)
- [ ] Particle effects for celebrations
- [ ] Advanced transitions (hero animations)
- [ ] Custom loading animations
- [ ] Animated charts and graphs

---

## Resources

**Design Inspiration:**
- Calm app (wellness aesthetic)
- Headspace (friendly, approachable)
- Duolingo (gamification, celebrations)
- Apple Health (clean metrics)

**Animation References:**
- Material Motion (Google)
- Apple Human Interface Guidelines
- Framer Motion (web)

**Color Tools:**
- Coolors.co (palette generation)
- Contrast Checker (accessibility)
- Gradient Hunt (gradient inspiration)

---

## Usage

### In New Screens
```dart
import 'package:drink_less_buddy/core/design/app_theme.dart';
import 'package:drink_less_buddy/core/widgets/glass_button.dart';
import 'package:drink_less_buddy/core/animations/staggered_list.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: StaggeredList(
        children: [
          AnimatedCard(
            child: Text('Hello', style: AppTheme.headlineLarge),
          ),
          GlassButton(
            text: 'Press Me',
            onPressed: () async {
              await HapticService.mediumImpact();
              // Action
            },
          ),
        ],
      ),
    );
  }
}
```

---

**Created with ❤️ to make Drink Less Buddy feel unique, polished, and delightful to use.**
