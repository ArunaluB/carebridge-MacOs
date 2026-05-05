// ManagerSampleData.swift
// NurseryConnect — Setting Manager (macOS)
// Extends Assignment 1 SampleData with Setting Manager-specific data
// Includes: Manager profile, realistic UK nursery observation notes with varied sentiment

import Foundation
import SwiftUI

struct ManagerSampleData {
    
    // MARK: - Setting Manager Profile
    static let settingManager = SettingManagerProfile(
        id: UUID(uuidString: "10000001-0001-0001-0001-000000000001")!,
        fullName: "Claire Johnson",
        role: "Setting Manager",
        nurseryName: "Little Stars Nursery & Daycare",
        roomsManaged: ["Sunshine Room", "Rainbow Room", "Star Room"],
        lastLoginAt: Date()
    )
    
    // MARK: - Realistic UK Childcare Observation Notes
    // These generate varied sentiment scores when analyzed by NaturalLanguage
    
    /// Positive development observations
    static let positiveNotes: [String] = [
        "Ollie demonstrated excellent turn-taking skills during group play today, engaging confidently with his peers and sharing resources independently.",
        "Showed brilliant problem-solving skills during the construction activity, carefully balancing blocks and adjusting when the tower wobbled. Lovely concentration!",
        "Made wonderful progress with letter recognition today — confidently identified all letters in their name and attempted to write them independently.",
        "Absolutely thriving during outdoor play, showing fantastic gross motor skills on the climbing frame. Great confidence and independence!",
        "Engaged beautifully in story time, answering questions about the plot with enthusiasm and making wonderful predictions about what might happen next.",
        "Showed lovely empathy today — noticed a friend was upset and offered them a cuddle and their favourite toy. Such kindness!",
        "Brilliant participation in the music session — kept excellent rhythm with the tambourine and sang along confidently with the group.",
        "Made excellent progress with counting today — correctly counted to 15 without support and is beginning to understand one-to-one correspondence.",
        "Really flourishing socially — initiated a game of 'vets' in the role play area and confidently assigned roles to three other children.",
        "Outstanding creative expression during painting — mixed colours independently and described their artwork with wonderful imagination."
    ]
    
    /// Concern / negative observations
    static let concernNotes: [String] = [
        "Amara appeared unsettled throughout the morning session. She was reluctant to engage with activities and required additional comfort from her keyworker.",
        "Showed signs of distress at drop-off and took a long time to settle. Refused breakfast and was tearful during morning circle time.",
        "Unusually withdrawn today — did not interact with peers during free play and chose to sit alone in the book corner for most of the session.",
        "Displayed challenging behaviour during lunch — threw food on the floor and became upset when redirected. Required one-to-one support for 20 minutes.",
        "Had difficulty separating from parent again this morning. Cried for 15 minutes after drop-off and needed continuous reassurance from staff.",
        "Refused to participate in group activities and became distressed when encouraged to join. Spent most of the afternoon clinging to keyworker."
    ]
    
    /// Neutral / factual observations
    static let neutralNotes: [String] = [
        "Muhammad completed his lunch, eating most of his pasta. He was calm during the afternoon rest period.",
        "Participated in the planned water play activity for 20 minutes before moving to the construction area.",
        "Arrived on time for the morning session. Had morning snack and engaged with table-top activities.",
        "Completed the planned phonics activity with the group. Practiced the 's' sound with support.",
        "Napped for 45 minutes after lunch. Woke in good spirits and had afternoon snack.",
        "Played alongside peers in the sand tray during the morning session. Joined in with the singing at circle time.",
        "Ate half of the lunch offered today. Drank water throughout the session as encouraged.",
        "Attended the outdoor session and used the bikes and trikes. Came inside for snack at the usual time."
    ]
    
    // MARK: - Generate Enhanced Diary Entries with Rich Notes
    
    /// Generate diary entries with varied, realistic observation notes for NL analysis
    static func generateEnhancedDiaryEntries() -> [DiaryEntry] {
        var entries: [DiaryEntry] = []
        let children = SampleData.children
        let kwId = SampleData.keyworker.id
        
        for dayOffset in 0..<14 {
            let date = Date.daysAgo(dayOffset)
            let cal = Calendar.current
            let weekday = cal.component(.weekday, from: date)
            
            // Skip weekends
            if weekday == 1 || weekday == 7 { continue }
            
            for (childIndex, child) in children.enumerated() {
                // Morning wellbeing — with detailed notes
                let wellbeingNote: String
                if dayOffset < 3 && childIndex == 1 { // Tharushi — recent concerns
                    wellbeingNote = concernNotes[dayOffset % concernNotes.count]
                } else if childIndex == 0 { // Dineth — mostly positive
                    wellbeingNote = positiveNotes[dayOffset % positiveNotes.count]
                } else {
                    wellbeingNote = neutralNotes[dayOffset % neutralNotes.count]
                }
                
                entries.append(DiaryEntry(
                    childId: child.id,
                    keyworkerId: kwId,
                    type: .wellbeing,
                    timestamp: date.settingTime(hour: 8, minute: Int.random(in: 15...45)),
                    notes: wellbeingNote,
                    moodRating: childIndex == 1 && dayOffset < 3 ?
                        [.unsettled, .poorly, .upset].randomElement()! :
                        [.happy, .happy, .content, .content, .happy].randomElement()!,
                    wellbeingCheckTime: .arrival,
                    physicalAppearance: "Clean, well-rested",
                    socialEngagement: childIndex == 1 && dayOffset < 3 ?
                        "Reluctant to interact" : "Greeted friends warmly"
                ))
                
                // Breakfast
                let breakfastFoods = ["Porridge with banana", "Wholegrain toast with beans",
                                      "Weetabix with milk", "Scrambled egg on toast", "Muesli with fruit"]
                entries.append(DiaryEntry(
                    childId: child.id,
                    keyworkerId: kwId,
                    type: .meal,
                    timestamp: date.settingTime(hour: 8, minute: Int.random(in: 30...50)),
                    notes: "",
                    mealType: .breakfast,
                    foodOffered: breakfastFoods[dayOffset % breakfastFoods.count],
                    portionConsumed: [.all, .most, .most, .half, .all].randomElement()!,
                    drinkType: child.dateOfBirth.ageInYears < 2 ? .milk : .water,
                    drinkAmountMl: Int.random(in: 80...200)
                ))
                
                // Morning activity with rich observation notes
                let morningActivities: [ActivityType] = [.reading, .artsAndCrafts,
                    .educational, .sensory, .music]
                let activityType = morningActivities[dayOffset % morningActivities.count]
                let activityNote: String
                
                if childIndex == 0 && dayOffset % 2 == 0 {
                    activityNote = positiveNotes[(dayOffset + childIndex) % positiveNotes.count]
                } else if childIndex == 1 && dayOffset < 2 {
                    activityNote = concernNotes[(dayOffset + childIndex) % concernNotes.count]
                } else {
                    activityNote = SampleData.generateActivityNote(for: activityType)
                }
                
                let eyfsAreas = ["Communication & Language", "Physical Development",
                                 "Personal, Social & Emotional Development",
                                 "Literacy", "Mathematics",
                                 "Understanding the World", "Expressive Arts & Design"]
                
                entries.append(DiaryEntry(
                    childId: child.id,
                    keyworkerId: kwId,
                    type: .activity,
                    timestamp: date.settingTime(hour: 9, minute: Int.random(in: 15...45)),
                    notes: activityNote,
                    activityType: activityType,
                    activityDuration: Int.random(in: 20...45),
                    eyfsArea: eyfsAreas[(dayOffset + childIndex) % eyfsAreas.count]
                ))
                
                // Outdoor play
                entries.append(DiaryEntry(
                    childId: child.id,
                    keyworkerId: kwId,
                    type: .activity,
                    timestamp: date.settingTime(hour: 11, minute: Int.random(in: 0...30)),
                    notes: "Enjoyed outdoor exploration in the garden area",
                    activityType: .outdoorPlay,
                    activityDuration: Int.random(in: 30...50),
                    eyfsArea: "Physical Development"
                ))
                
                // Midday wellbeing
                entries.append(DiaryEntry(
                    childId: child.id,
                    keyworkerId: kwId,
                    type: .wellbeing,
                    timestamp: date.settingTime(hour: 11, minute: 45),
                    notes: childIndex == 1 && dayOffset < 2 ?
                        "Still appearing unsettled, not engaging well with peers" :
                        "In good spirits, playing well with friends",
                    moodRating: childIndex == 1 && dayOffset < 2 ?
                        .unsettled : [.happy, .content, .content].randomElement()!,
                    wellbeingCheckTime: .midday,
                    socialEngagement: "Playing with peers"
                ))
                
                // Lunch
                let lunchFoods = ["Chicken with roast vegetables", "Pasta bolognese",
                                  "Salmon fishcakes with peas", "Beef stew with mash",
                                  "Cheese & veg quesadilla"]
                entries.append(DiaryEntry(
                    childId: child.id,
                    keyworkerId: kwId,
                    type: .meal,
                    timestamp: date.settingTime(hour: 12, minute: Int.random(in: 0...15)),
                    notes: "",
                    mealType: .lunch,
                    foodOffered: lunchFoods[dayOffset % lunchFoods.count],
                    portionConsumed: [.all, .most, .half, .most, .all].randomElement()!,
                    drinkType: .water,
                    drinkAmountMl: Int.random(in: 100...250)
                ))
                
                // Sleep (younger children)
                if child.dateOfBirth.ageInYears < 3 || dayOffset % 3 == 0 {
                    let napStart = date.settingTime(hour: 12, minute: 45)
                    let napDuration = Int.random(in: 30...90)
                    let napEnd = Calendar.current.date(byAdding: .minute,
                        value: napDuration, to: napStart)!
                    
                    entries.append(DiaryEntry(
                        childId: child.id,
                        keyworkerId: kwId,
                        type: .sleep,
                        timestamp: napStart,
                        notes: napDuration > 60 ? "Slept well, no disturbances" : "Short rest",
                        sleepStartTime: napStart,
                        sleepEndTime: napEnd,
                        sleepPosition: [.back, .back, .side].randomElement()!,
                        sleepDurationMinutes: napDuration
                    ))
                }
                
                // Afternoon activity
                let pmNote: String
                if childIndex == 2 {
                    pmNote = positiveNotes[(dayOffset + 3) % positiveNotes.count]
                } else {
                    pmNote = "Engaged in creative play activity"
                }
                
                entries.append(DiaryEntry(
                    childId: child.id,
                    keyworkerId: kwId,
                    type: .activity,
                    timestamp: date.settingTime(hour: 14, minute: Int.random(in: 30...50)),
                    notes: pmNote,
                    activityType: [.freePlay, .socialPlay, .indoorPlay, .artsAndCrafts].randomElement()!,
                    activityDuration: Int.random(in: 25...45),
                    eyfsArea: "Expressive Arts & Design"
                ))
                
                // Departure wellbeing
                if dayOffset > 0 {
                    entries.append(DiaryEntry(
                        childId: child.id,
                        keyworkerId: kwId,
                        type: .wellbeing,
                        timestamp: date.settingTime(hour: 16, minute: Int.random(in: 30...50)),
                        notes: childIndex == 1 && dayOffset < 2 ?
                            "Remained somewhat withdrawn today, monitor tomorrow" :
                            "Had a lovely day, waved goodbye to friends",
                        moodRating: childIndex == 1 && dayOffset < 2 ?
                            .unsettled : [.happy, .happy, .content].randomElement()!,
                        wellbeingCheckTime: .departure,
                        socialEngagement: "Waved goodbye to friends"
                    ))
                }
            }
        }
        
        return entries.sorted { $0.timestamp > $1.timestamp }
    }
    
    // MARK: - Generate Wellbeing Alerts
    
    static func generateWellbeingAlerts() -> [ChildWellbeingAlert] {
        let children = SampleData.children
        
        return [
            ChildWellbeingAlert(
                childId: children[1].id, // Tharushi
                childName: children[1].fullName,
                alertType: .lowWellbeingScore,
                wellbeingScore: 38.5,
                triggeredAt: Date.daysAgo(1),
                recommendedAction: "Review recent diary entries and schedule a check-in with keyworker. Consider parent meeting."
            ),
            ChildWellbeingAlert(
                childId: children[1].id, // Tharushi
                childName: children[1].fullName,
                alertType: .concernFlagged,
                wellbeingScore: 38.5,
                triggeredAt: Date(),
                recommendedAction: "Multiple concern entries detected in last 3 days — arrange meeting with parents and keyworker."
            ),
            ChildWellbeingAlert(
                childId: children[4].id, // Minoli
                childName: children[4].fullName,
                alertType: .eyfsGap,
                wellbeingScore: 62.0,
                triggeredAt: Date.daysAgo(2),
                recommendedAction: "No Mathematics or Literacy activities logged this week. Plan targeted activities."
            ),
            ChildWellbeingAlert(
                childId: children[3].id, // Rizwan
                childName: children[3].fullName,
                alertType: .incidentOverdue,
                wellbeingScore: 55.0,
                triggeredAt: Date(),
                recommendedAction: "Parent notification overdue for sand pit incident. Contact parent immediately."
            )
        ]
    }

    // MARK: - Sentiment Results (Pre-computed)

    static func generateSentimentResults(for entries: [DiaryEntry]) -> [SentimentAnalysisResult] {
        let nlService = NLAnalysisService.shared
        return entries.compactMap { entry in
            let trimmed = entry.notes.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return nil }
            return nlService.analyzeSentimentResult(text: entry.notes, diaryEntryId: entry.id)
        }
    }
}
