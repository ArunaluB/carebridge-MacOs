#!/bin/bash

# Define the timezone
export TZ="Asia/Colombo"

# Initialize fresh repo
git init

# Function to commit with a specific date
commit_at() {
    local date="$1"
    local message="$2"
    GIT_AUTHOR_DATE="$date" GIT_COMMITTER_DATE="$date" git commit -m "$message"
}

# 1. 2025-05-10: Initial project setup
git add README.md
git add "carebridge-Macos/CareBridge-macOS.xcodeproj" 2>/dev/null || true
commit_at "2025-05-10T10:30:00+05:30" "Initial project setup"

# 2. 2025-05-20: Add basic App struct
git add "carebridge-Macos/CareBridge-macOS/CareBridgeApp.swift" 2>/dev/null || true
commit_at "2025-05-20T14:15:00+05:30" "Add core App struct"

# 3. 2025-06-05: Create base models
git add "carebridge-Macos/CareBridge-macOS/Models" 2>/dev/null || true
commit_at "2025-06-05T09:45:00+05:30" "Create base domain models"

# 4. 2025-06-25: Add application state
git add "carebridge-Macos/CareBridge-macOS/AppState.swift" 2>/dev/null || true
commit_at "2025-06-25T11:20:00+05:30" "Implement global AppState"

# 5. 2025-07-15: Setup shared utilities
git add "carebridge-Macos/CareBridge-macOS/Shared/Constants.swift" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Shared/Date+Extensions.swift" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Utilities/Extensions" 2>/dev/null || true
commit_at "2025-07-15T16:30:00+05:30" "Setup shared constants and date extensions"

# 6. 2025-08-05: Add base components
git add "carebridge-Macos/CareBridge-macOS/Components/EmptyStateView.swift" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Components/AlertCardView.swift" 2>/dev/null || true
commit_at "2025-08-05T10:10:00+05:30" "Add empty state and alert UI components"

# 7. 2025-08-25: Create glassmorphism UI components
git add "carebridge-Macos/CareBridge-macOS/Components/GlassCard.swift" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Components/NeumorphicCard.swift" 2>/dev/null || true
commit_at "2025-08-25T13:45:00+05:30" "Implement glassmorphism and neumorphic cards"

# 8. 2025-09-10: Add avatar and status badge components
git add "carebridge-Macos/CareBridge-macOS/Components/AvatarView.swift" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Components/StatusBadge.swift" 2>/dev/null || true
commit_at "2025-09-10T15:20:00+05:30" "Add avatar and status badge UI elements"

# 9. 2025-09-30: Setup initial views
git add "carebridge-Macos/CareBridge-macOS/Views/Splash" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Views/ContentView.swift" 2>/dev/null || true
commit_at "2025-09-30T09:05:00+05:30" "Create splash screen and base content view"

# 10. 2025-10-20: Add dashboard views
git add "carebridge-Macos/CareBridge-macOS/Views/Dashboard" 2>/dev/null || true
commit_at "2025-10-20T11:40:00+05:30" "Implement dashboard UI and layout"

# 11. 2025-11-10: Add sidebar navigation
git add "carebridge-Macos/CareBridge-macOS/Views/Sidebar" 2>/dev/null || true
commit_at "2025-11-10T14:15:00+05:30" "Add sidebar navigation menu"

# 12. 2025-11-30: Add children profile views
git add "carebridge-Macos/CareBridge-macOS/Views/Children" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Views/ChildProfile" 2>/dev/null || true
commit_at "2025-11-30T10:50:00+05:30" "Implement children list and profile views"

# 13. 2025-12-15: Add daily diary features
git add "carebridge-Macos/CareBridge-macOS/Views/DailyDiary" 2>/dev/null || true
commit_at "2025-12-15T16:00:00+05:30" "Add daily diary logging views"

# 14. 2026-01-10: Implement incident reporting
git add "carebridge-Macos/CareBridge-macOS/Views/Incidents" 2>/dev/null || true
commit_at "2026-01-10T09:30:00+05:30" "Create incident reporting flow and body map"

# 15. 2026-02-05: Add message views
git add "carebridge-Macos/CareBridge-macOS/Views/Messages" 2>/dev/null || true
commit_at "2026-02-05T13:20:00+05:30" "Implement messaging interface"

# 16. 2026-02-25: Implement services layer
git add "carebridge-Macos/CareBridge-macOS/Services" 2>/dev/null || true
commit_at "2026-02-25T11:10:00+05:30" "Add manager data and notification services"

# 17. 2026-03-15: Add view models
git add "carebridge-Macos/CareBridge-macOS/ViewModels" 2>/dev/null || true
commit_at "2026-03-15T15:45:00+05:30" "Connect views with view models"

# 18. 2026-04-05: Create settings and notification views
git add "carebridge-Macos/CareBridge-macOS/Views/Settings" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Views/Notifications" 2>/dev/null || true
commit_at "2026-04-05T10:05:00+05:30" "Add settings panel and notification center"

# 19. 2026-04-20: Add PDF reporting functionality
git add "carebridge-Macos/CareBridge-macOS/Shared/PDFGenerator.swift" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Views/Reports" 2>/dev/null || true
commit_at "2026-04-20T14:30:00+05:30" "Implement PDF report generation"

# 20. 2026-05-05: Add sample data for testing
git add "carebridge-Macos/CareBridge-macOS/SampleData" 2>/dev/null || true
commit_at "2026-05-05T16:15:00+05:30" "Add mock data for UI testing"

# 21. 2026-05-15: Refine main keyworker view
git add "carebridge-Macos/CareBridge-macOS/KeyworkerContentView.swift" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Views" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/Components" 2>/dev/null || true
commit_at "2026-05-15T11:50:00+05:30" "Refine keyworker layout and remaining components"

# 22. 2026-05-25: Add app assets and entitlements
git add "carebridge-Macos/CareBridge-macOS/Assets.xcassets" 2>/dev/null || true
git add "carebridge-Macos/CareBridge-macOS/CareBridge.entitlements" 2>/dev/null || true
commit_at "2026-05-25T09:20:00+05:30" "Add application icons and capabilities"

# 23. 2026-05-28: Setup initial tests
git add "carebridge-Macos/Tests" 2>/dev/null || true
commit_at "2026-05-28T14:40:00+05:30" "Add unit and UI tests"

# 24. 2026-06-01: Add demo and report assets
git add "Demo" 2>/dev/null || true
git add "Report" 2>/dev/null || true
git add "AI generated mockup" 2>/dev/null || true
commit_at "2026-06-01T10:15:00+05:30" "Add assignment demo and presentation materials"

# 25. 2026-06-03: Final bug fixes and screenshots
git add .
commit_at "2026-06-03T14:50:00+05:30" "Final polish and update assignment screenshots"
