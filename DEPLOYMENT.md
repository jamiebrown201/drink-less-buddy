# Deployment Guide - Drink Less Buddy

This guide covers deploying Drink Less Buddy to production with minimal costs.

## Pre-Deployment Checklist

- [ ] Test app thoroughly on iOS and Android
- [ ] Set up Supabase production project
- [ ] Configure Stripe for payments
- [ ] Set up app store accounts (Apple, Google)
- [ ] Prepare marketing materials
- [ ] Create privacy policy and terms of service pages

## Backend Setup (Supabase)

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Choose region closest to your target users
4. Note your project URL and anon key

### 2. Run Database Schema

```bash
# Copy the schema
cat supabase/schema.sql

# Paste into Supabase SQL Editor and run
```

### 3. Configure Row Level Security

The schema already includes RLS policies. Verify they're enabled:
```sql
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE tablename IN ('users', 'drinks', 'intentions');
```

### 4. Set Up Authentication

In Supabase Dashboard:
1. **Authentication** → **Providers**
2. Enable **Email** provider
3. (Optional) Enable **Google**, **Apple** OAuth
4. Configure email templates

### 5. Update Flutter App

In `lib/utils/constants.dart`:
```dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key';
```

In `lib/main.dart`, uncomment:
```dart
await Supabase.initialize(
  url: AppConstants.supabaseUrl,
  anonKey: AppConstants.supabaseAnonKey,
);
```

## Payment Setup (Stripe)

### 1. Create Stripe Account

1. Sign up at [stripe.com](https://stripe.com)
2. Complete business verification
3. Get your publishable and secret keys

### 2. Create Products

In Stripe Dashboard:
1. **Products** → **Add Product**
2. Create two products:
   - **Monthly**: £4.99/month
   - **Yearly**: £49.99/year

### 3. Configure Flutter Stripe

Add to `pubspec.yaml` (already included):
```yaml
dependencies:
  flutter_stripe: ^10.1.1
```

Create `lib/services/stripe_service.dart`:
```dart
// Stripe integration code (to be implemented)
```

## iOS Deployment

### 1. Prerequisites

- Mac with Xcode installed
- Apple Developer account (£99/year)
- Valid signing certificate

### 2. Configure App

```bash
cd ios
open Runner.xcworkspace
```

In Xcode:
1. Update **Bundle Identifier**: `com.yourcompany.drinklessbuddy`
2. Set **Team** to your Apple Developer team
3. Update **Display Name**: `Drink Less Buddy`
4. Set **Version**: `1.0.0`
5. Set **Build**: `1`

### 3. App Store Connect Setup

1. Create app in [App Store Connect](https://appstoreconnect.apple.com)
2. Fill in app information
3. Upload screenshots (required sizes)
4. Write app description (see marketing copy below)
5. Set age rating: **17+** (alcohol-related)

### 4. Build & Upload

```bash
# Build release
flutter build ios --release

# Open in Xcode and archive
open ios/Runner.xcworkspace

# In Xcode: Product → Archive → Distribute App
```

### 5. Submit for Review

In App Store Connect:
1. Add build
2. Answer review questions
3. Submit for review (typically 1-3 days)

## Android Deployment

### 1. Prerequisites

- Android Studio installed
- Google Play Developer account ($25 one-time fee)

### 2. Generate Signing Key

```bash
cd android/app
keytool -genkey -v -keystore release-keystore.jks \
  -alias drink-less-buddy -keyalg RSA -keysize 2048 -validity 10000

# Move to secure location
mv release-keystore.jks ~/secure-keys/
```

### 3. Configure Signing

Create `android/key.properties`:
```
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=drink-less-buddy
storeFile=/path/to/release-keystore.jks
```

Add to `android/.gitignore`:
```
key.properties
```

### 4. Update Build Configuration

Already configured in template, but verify `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.drinklessbuddy"
        versionCode 1
        versionName "1.0.0"
    }
}
```

### 5. Build Release

```bash
# Build App Bundle (recommended)
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### 6. Google Play Console Setup

1. Create app in [Google Play Console](https://play.google.com/console)
2. Fill in app details
3. Upload screenshots
4. Set content rating (alcohol reference)
5. Complete privacy policy URL
6. Upload app bundle

### 7. Submit for Review

1. Choose **Production** track
2. Upload AAB file
3. Fill in release notes
4. Submit (typically 1-7 days review)

## Web Deployment (Optional)

### 1. Build Web App

```bash
flutter build web --release
```

### 2. Deploy to Hosting

**Option A: Firebase Hosting** (Free tier sufficient)
```bash
npm install -g firebase-tools
firebase login
firebase init hosting
firebase deploy
```

**Option B: Netlify** (Free tier)
```bash
# Drag and drop build/web folder to Netlify
```

**Option C: Vercel** (Free tier)
```bash
vercel --prod build/web
```

## Environment Variables (Security)

### Production Secrets

Create `lib/utils/secrets.dart` (gitignored):
```dart
class Secrets {
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key';
  static const String stripePublishableKey = 'pk_live_...';
  static const String openAIKey = 'sk-...'; // For premium AI
}
```

**Never commit this file!**

## Post-Deployment

### 1. Monitor Costs

Set up alerts in:
- **Supabase**: Database usage, API calls
- **Stripe**: Revenue, failed payments
- **OpenAI**: API usage (premium only)

### 2. Analytics

Integrate analytics (choose one):
- Google Analytics for Firebase (free)
- Mixpanel (free tier: 100K events/month)
- Amplitude (free tier: 10M events/month)

### 3. Crash Reporting

Add Sentry or Firebase Crashlytics:
```yaml
dependencies:
  sentry_flutter: ^7.0.0
  # OR
  firebase_crashlytics: ^3.0.0
```

### 4. User Feedback

Set up:
- In-app feedback form
- Email support: support@drinklessbuddy.com
- App store review monitoring

## Cost Breakdown (First Year)

| Service | Cost |
|---------|------|
| Apple Developer | £99/year |
| Google Play | $25 one-time |
| Supabase (10K users) | £50/month = £600/year |
| Stripe fees (3%) | Variable |
| Domain & Email | £20/year |
| **Total** | **~£750/year** |

**Revenue target** (10% conversion at £4.99/month):
- 10K users × 10% × £4.99 = £4,990/month
- Minus costs: £4,990 - £50 = £4,940/month profit

## Marketing Copy (App Stores)

### App Name
Drink Less Buddy - Reduce Alcohol

### Subtitle
Evidence-based tools to moderate drinking

### Description
**Are you looking to cut down on drinking, not cut it out entirely?**

Drink Less Buddy helps you reduce alcohol consumption using scientifically proven methods. No judgment, no abstinence pressure—just evidence-based tools for moderation.

**RESEARCH-BACKED FEATURES:**

• Self-Monitoring (85% engagement rate)
Track every drink with mood and context. Studies show tracking alone reduces consumption by 25%.

• Personalized Feedback (31% average reduction)
Compare your drinking to actual guidelines and see patterns you might be missing.

• Daily Intentions (31% reduction)
Set goals for tomorrow's activities you want to do hangover-free. Prospective planning works.

• Evidence-Based Tactics
Learn proven strategies ranked by effectiveness for different situations.

**DESIGNED FOR MODERATION, NOT ABSTINENCE**

Most apps focus on quitting entirely. We're different. Our methods are based on peer-reviewed research for people who want to drink less, not stop completely.

**YOUR PRIVACY MATTERS**

• Data stored locally on your device
• Optional cloud backup (premium)
• GDPR compliant
• We never sell your data

**FREE FEATURES:**
✓ Unlimited drink logging
✓ Weekly insights
✓ All evidence-based tactics
✓ Full research citations

**PREMIUM FEATURES:**
✓ AI-powered personal coach
✓ Smart context-aware reminders
✓ Advanced analytics
✓ Cloud backup

**WHO IS THIS FOR?**

This app is for people who want to moderate their drinking, not for those with diagnosed alcohol dependence. If you experience withdrawal symptoms or can't stop despite wanting to, please seek professional help.

Download now and start your journey to healthier drinking habits backed by science.

### Keywords
alcohol, drink less, moderation, sobriety, health, wellness, self-improvement, mindfulness, tracking, habit change

### Category
- Primary: Health & Fitness
- Secondary: Lifestyle

### Age Rating
- iOS: 17+
- Android: Mature 17+

## Support Channels

Before launch, set up:
1. **Email**: support@drinklessbuddy.com
2. **FAQ page**: Common questions
3. **In-app help**: Context-sensitive tooltips
4. **Community** (optional): Private Discord/Reddit

## Legal Requirements

Ensure you have:
- [ ] Privacy Policy URL (required)
- [ ] Terms of Service URL (required)
- [ ] Age verification (18+)
- [ ] Medical disclaimer
- [ ] Refund policy (for premium)
- [ ] Data deletion process (GDPR)

## Monitoring & Maintenance

### Weekly Tasks
- [ ] Check crash reports
- [ ] Monitor user reviews
- [ ] Review support emails
- [ ] Check backend costs

### Monthly Tasks
- [ ] Analyze conversion rates
- [ ] Review retention metrics
- [ ] Update app content
- [ ] Test premium features

### Quarterly Tasks
- [ ] Review research for updates
- [ ] Plan new features
- [ ] Analyze churn
- [ ] Optimize marketing

## Scaling Strategy

When you hit **10K users**:
1. Upgrade Supabase plan (£25/month)
2. Consider hiring support staff
3. Add more payment methods
4. Expand to more countries

When you hit **100K users**:
1. Move to Pro Supabase plan (£100/month)
2. Hire dedicated developer
3. Add enterprise features
4. Partner with healthcare providers

---

Good luck with your launch! 🚀

For questions: support@drinklessbuddy.com
