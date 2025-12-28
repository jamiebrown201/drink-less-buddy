# Drink Less Buddy - Architecture Documentation

## System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Mobile App                       │
│  ┌────────────┐  ┌────────────┐  ┌─────────────────────┐   │
│  │  UI Layer  │  │  Provider  │  │  Local Storage      │   │
│  │  (Screens) │→ │  (State)   │→ │  (Hive/SharedPrefs) │   │
│  └────────────┘  └────────────┘  └─────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                          ↓
                    (Premium Users)
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                    Supabase Backend                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │ PostgreSQL   │  │ Auth Service │  │  Edge Functions  │  │
│  │ (Data Store) │  │ (JWT/OAuth)  │  │  (Serverless)    │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                    Third-Party Services                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │   Stripe     │  │  OpenAI API  │  │  FCM/APNS        │  │
│  │  (Payments)  │  │  (AI Coach)  │  │  (Push Notify)   │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow Architecture

### Free Tier Users (Local-First)
```
User Action → Provider → Hive/SharedPreferences → Local Storage
                ↓
          UI Update
```

### Premium Users (Cloud Sync)
```
User Action → Provider → Local Storage → Supabase Sync
                ↓              ↓
          UI Update    Background Sync
```

## Cost Optimization Strategies

### 1. Local-First Architecture
- **Free users**: 100% local storage (zero backend cost)
- **Premium users**: Local + cloud sync (pay-per-use)
- **Benefit**: Only 20-30% of users generate backend costs

### 2. Lazy Loading & Caching
- Cache research citations locally
- Load tactics on-demand
- Minimize API calls

### 3. Supabase vs Firebase Cost Comparison

| Metric | Supabase | Firebase | Savings |
|--------|----------|----------|---------|
| 100K users | £200-300/mo | £500-800/mo | 60% |
| Database | PostgreSQL (cheaper) | Firestore (expensive writes) | 70% |
| Auth | Included | Included | Equal |
| Storage | £0.021/GB | £0.18/GB | 88% |

### 4. Serverless Functions (Edge Functions)
- Only run for premium features
- Cold starts acceptable for non-critical features
- Scale to zero when not in use

## Security & Privacy Architecture

### Data Privacy (GDPR/CCPA Compliant)
```
┌──────────────────────────────────────────┐
│        Row Level Security (RLS)          │
│  Each user can only access their data    │
└──────────────────────────────────────────┘
                ↓
┌──────────────────────────────────────────┐
│         Encryption at Rest               │
│  Supabase encrypts all data              │
└──────────────────────────────────────────┘
                ↓
┌──────────────────────────────────────────┐
│      Encryption in Transit (TLS)         │
│  All API calls over HTTPS                │
└──────────────────────────────────────────┘
```

### Authentication Flow
```
User → Email/Password → Supabase Auth → JWT Token
                              ↓
                        Store in Secure Storage
                              ↓
                    Use for API Authorization
```

## State Management (Provider Pattern)

### Why Provider?
- **Simplicity**: Easy to understand and implement
- **Performance**: Rebuilds only affected widgets
- **Testability**: Easy to mock and test
- **Scalability**: Sufficient for app complexity

### Provider Structure
```
UserProvider
├── User profile data
├── Premium status
└── Onboarding state

DrinkProvider
├── Drink logs
├── Analytics calculations
└── Weekly summaries

IntentionProvider
├── Daily intentions
├── Completion tracking
└── Reminder logic
```

## Database Schema Design

### Key Design Decisions

1. **User-centric partitioning**: All data partitioned by user_id
2. **Indexes for performance**: user_id + timestamp for fast queries
3. **JSONB for flexibility**: Preferences stored as JSON for easy extension
4. **Minimal joins**: Denormalized for read performance

### Schema Optimization
- **No cascading deletes** except user deletion (data safety)
- **Indexes on query patterns** (user_id, timestamp, date)
- **Updated_at triggers** for automatic timestamp management

## Premium Feature Architecture

### AI Coach Implementation
```
User Message → Edge Function → OpenAI API
                    ↓
              Parse Response
                    ↓
         Store in Conversation History
                    ↓
           Return to Flutter App
```

**Cost Control**:
- Rate limit: 10 messages/day for premium users
- Context window: Last 5 messages only
- Model: GPT-3.5-turbo (cheaper than GPT-4)
- Estimated cost: £0.002 per conversation

### Smart Reminders
```
Cron Job (Daily) → Query Users → Analyze Patterns
                         ↓
                  Generate Reminders
                         ↓
                Send via FCM/APNS
```

**Cost Control**:
- Run once daily (not real-time)
- Batch processing (all users at once)
- Firebase Cloud Messaging (free tier sufficient)

## Freemium Conversion Funnel

### User Journey
```
Download → Onboarding → Free Tier → Premium Trigger → Upgrade
   100%        80%         60%           15%            10%
```

### Premium Triggers
1. **Hit logging limit** (5 drinks/day on free tier)
2. **Request AI coach** (paywall prompt)
3. **Want cloud backup** (device switching)
4. **See advanced analytics** (teaser → paywall)

### Conversion Optimization
- **7-day free trial** reduces friction
- **Contextual upsells** when user hits limits
- **Feature teasers** throughout free experience

## Scalability Considerations

### Current Capacity (Single Region)
- **Supabase free tier**: Up to 500MB database
- **Expected**: ~50K users before hitting limit
- **Upgrade**: £25/month for 8GB (500K-1M users)

### Multi-Region Strategy (Future)
```
US Region ← Supabase → EU Region ← Supabase → APAC Region
   (Primary)                         (Replica)
```

## Monitoring & Analytics

### Key Metrics to Track
1. **DAU/MAU** (Daily/Monthly Active Users)
2. **Retention** (D1, D7, D30)
3. **Conversion Rate** (Free → Premium)
4. **Churn Rate** (Premium cancellations)
5. **Average Revenue Per User (ARPU)**

### Cost Monitoring
- Supabase dashboard for database usage
- Stripe dashboard for revenue
- OpenAI usage dashboard for AI costs

## Deployment Architecture

### CI/CD Pipeline
```
GitHub Push → GitHub Actions → Run Tests
                    ↓
            Build iOS/Android
                    ↓
        Upload to App Store/Play Store
```

### Environment Strategy
- **Development**: Local-only (no Supabase)
- **Staging**: Separate Supabase project
- **Production**: Production Supabase project

## Technical Debt & Future Refactoring

### Known Limitations
1. **No offline queue**: Changes lost if offline (future: offline queue)
2. **No conflict resolution**: Last-write-wins (future: CRDT)
3. **No analytics aggregation**: Real-time only (future: batch jobs)

### Refactoring Priorities
1. **Add integration tests** (current: unit tests only)
2. **Implement offline support** with sync queue
3. **Add telemetry** for crash reporting (Sentry)
4. **Optimize image loading** (current: placeholders only)

## Conclusion

This architecture prioritizes:
1. **Low cost** through local-first design
2. **Privacy** through RLS and encryption
3. **Scalability** through serverless architecture
4. **User experience** through fast, offline-first UX

The freemium model ensures profitability while providing free access to evidence-based tools for alcohol reduction.
