# Sleep Tracker — EAP Gamified Sleep Monitoring

A mobile-first, gamified sleep tracker built for Employee Assistance Programmes. Features an Oura Ring-inspired score visualization, cross-tracker insights, and multi-language support.

## Tech Stack

- **Frontend:** React 18 + TypeScript + Vite
- **Styling:** Tailwind CSS + shadcn/ui + Framer Motion
- **Backend:** Lovable Cloud (PostgreSQL with RLS)
- **Translation:** Google Translate API

## Features

- 🌙 **Sleep Score Ring** — Animated circular score (0-100) with color-coded tiers
- 📝 **Sleep Logging** — Native HTML5 time inputs with auto-calculated duration
- 📊 **Weekly Chart** — 7-day bar chart with scores per night
- 📅 **30-Day Heatmap** — Color-coded history grid
- 💡 **Optimization Tips** — Personalized sleep advice
- 🔗 **Cross-Tracker Insights** — Correlations with craving, energy, mood
- ⚠️ **Expert Booking** — Sleep deprivation alerts
- 🌍 **Multi-Language** — 10 languages via Google Translate
- 🎉 **Gamification** — Personal best celebrations

## Authentication

Token-based handshake with MantraCare API:
1. Check URL for `?token=UUID`
2. POST to `https://api.mantracare.com/user/user-info`
3. Store `user_id` in `sessionStorage`
4. Redirect to `/token` on failure

## Score Algorithm

- **Duration** (max 60 pts): 8hr = 50 baseline; ±5 per 30min
- **Quality** (max 20 pts): 4 pts per level (1-5)
- **Penalties**: -3 per wake-up, -2 per symptom
- **Final**: Clamped 0-100

## Time Input Styling

Uses native HTML5 `<input type="time">` elements with `color-scheme: dark`. Calendar picker indicators are inverted for dark theme. This ensures native mobile time pickers work across all devices.

## Language Support

Pass `?lang=XX` in URL or use dropdown. Supported: EN, ES, FR, DE, HI, TA, TE, KN, ML, MR.

## Getting Started

```bash
npm install
npm run dev
```
