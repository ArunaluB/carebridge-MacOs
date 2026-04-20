// ReportGeneratorView.swift
// NurseryConnect — Setting Manager (macOS)
// Premium report controls panel — optimized for narrow Column 2 sidebar width
// PDF preview is shown in Column 3 (DetailColumnView)

import SwiftUI
import NaturalLanguage

struct ReportGeneratorView: View {
    @Environment(ReportViewModel.self) private var reportVM
    @State private var isHoveringGenerate = false
    
    var body: some View {
        @Bindable var vm = reportVM
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // Header
                reportHeader
                
                // Controls
                VStack(spacing: 14) {
                    dateRangeSection
                    reportTypeSection
                    wellbeingSection
                    generateButton
                    
                    // Success indicator
                    if !vm.generatedReport.isEmpty {
                        successBanner
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 16)
                
                // Compliance warning
                if !vm.nonEnglishEntries.isEmpty && !vm.generatedReport.isEmpty {
                    complianceWarning
                        .padding(.horizontal, 14)
                        .padding(.bottom, 16)
                }
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .navigationTitle(ManagerText.Reports.title)
    }
    
    // MARK: - Header
    private var reportHeader: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.ncPrimary.opacity(0.85),
                    Color.ncGradientEnd.opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Decorative
            HStack {
                Spacer()
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 80, height: 80)
                    .offset(x: 30, y: -20)
            }
            
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white.opacity(0.2))
                        .frame(width: 38, height: 38)
                    
                    Image(systemName: "doc.richtext.fill")
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Report Generator")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Generate PDF reports")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.75))
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 66)
    }
    
    // MARK: - Date Range
    private var dateRangeSection: some View {
        @Bindable var vm = reportVM
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Date Range", systemImage: "calendar")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                // Quick presets
                Menu {
                    Button("Last 7 Days") {
                        vm.startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
                        vm.endDate = Date()
                    }
                    Button("Last 14 Days") {
                        vm.startDate = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
                        vm.endDate = Date()
                    }
                    Button("Last 30 Days") {
                        vm.startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
                        vm.endDate = Date()
                    }
                } label: {
                    Label("Quick", systemImage: "clock.arrow.circlepath")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.ncPrimary)
                }
                .buttonStyle(.plain)
                .menuStyle(.borderlessButton)
            }
            
            // Start date
            HStack {
                Text("From")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 36, alignment: .leading)
                
                DatePicker("", selection: $vm.startDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            
            // End date
            HStack {
                Text("To")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 36, alignment: .leading)
                
                DatePicker("", selection: $vm.endDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            
            // Day count
            let days = max(1, Calendar.current.dateComponents([.day], from: vm.startDate, to: vm.endDate).day ?? 1)
            Text("\(days) day\(days == 1 ? "" : "s") selected")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.ncPrimary.opacity(0.12), lineWidth: 1)
        )
    }
    
    // MARK: - Report Type
    private var reportTypeSection: some View {
        @Bindable var vm = reportVM
        return VStack(alignment: .leading, spacing: 10) {
            Label("Report Type", systemImage: "doc.text.below.ecg")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.primary)
            
            ForEach(ReportType.allCases) { type in
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        vm.reportType = type
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: type.icon)
                            .font(.system(size: 12))
                            .foregroundStyle(vm.reportType == type ? .white : reportTypeColor(type))
                            .frame(width: 26, height: 26)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(vm.reportType == type ? reportTypeColor(type) : reportTypeColor(type).opacity(0.12))
                            )
                        
                        Text(type.rawValue)
                            .font(.system(size: 12, weight: vm.reportType == type ? .semibold : .regular))
                            .foregroundStyle(vm.reportType == type ? .primary : .secondary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if vm.reportType == type {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundStyle(reportTypeColor(type))
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(vm.reportType == type ? reportTypeColor(type).opacity(0.08) : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "A29BFE").opacity(0.12), lineWidth: 1)
        )
    }
    
    // MARK: - Wellbeing Filter
    private var wellbeingSection: some View {
        @Bindable var vm = reportVM
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Wellbeing Filter", systemImage: "heart.text.square")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                // Score badge
                HStack(spacing: 2) {
                    Text("≤")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text("\(Int(vm.minimumWellbeingScore))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(wellbeingColor(vm.minimumWellbeingScore))
                }
            }
            
            Slider(value: $vm.minimumWellbeingScore, in: 0...100, step: 1)
                .tint(wellbeingColor(vm.minimumWellbeingScore))
            
            // Dynamic description based on value
            HStack(spacing: 4) {
                Image(systemName: vm.minimumWellbeingScore >= 100 ? "person.3.fill" : "person.fill.viewfinder")
                    .font(.system(size: 9))
                    .foregroundStyle(wellbeingColor(vm.minimumWellbeingScore))
                
                Text(wellbeingFilterDescription(vm.minimumWellbeingScore))
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.ncWarning.opacity(0.12), lineWidth: 1)
        )
    }
    
    // MARK: - Generate Button
    private var generateButton: some View {
        @Bindable var vm = reportVM
        return Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                vm.generateReport()
            }
        } label: {
            HStack(spacing: 8) {
                if vm.isGenerating {
                    ProgressView()
                        .controlSize(.small)
                        .tint(.white)
                } else {
                    Image(systemName: "sparkles")
                        .font(.system(size: 13, weight: .semibold))
                }
                
                Text(vm.isGenerating ? "Generating..." : "Generate Report")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: vm.isGenerating
                                ? [.gray, .gray.opacity(0.7)]
                                : [.ncPrimary, .ncGradientEnd],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(
                        color: .ncPrimary.opacity(isHoveringGenerate ? 0.35 : 0.15),
                        radius: isHoveringGenerate ? 10 : 5,
                        x: 0,
                        y: 3
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(vm.isGenerating)
        .onHover { h in
            withAnimation(.easeOut(duration: 0.15)) { isHoveringGenerate = h }
        }
        .scaleEffect(isHoveringGenerate ? 1.02 : 1.0)
        .animation(.easeOut(duration: 0.15), value: isHoveringGenerate)
    }
    
    // MARK: - Success Banner
    private var successBanner: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.ncSuccess)
                
                Text("Report Ready")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            Text("View the PDF preview in the right panel →")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Download button
            Button {
                downloadPDF()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.down.doc.fill")
                        .font(.system(size: 12))
                    Text("Download PDF")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(.ncPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ncPrimary.opacity(0.1))
                        .stroke(.ncPrimary.opacity(0.25), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ncSuccess.opacity(0.06))
                .stroke(.ncSuccess.opacity(0.2), lineWidth: 1)
        )
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    // MARK: - Compliance Warning
    private var complianceWarning: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.ncWarning)
                
                Text(ManagerText.Reports.complianceTitle)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.ncWarning)
                
                Spacer()
                
                Text("\(reportVM.nonEnglishEntries.count)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.ncWarning)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(.ncWarning.opacity(0.15)))
            }
            
            Text(ManagerText.Reports.complianceMessage(reportVM.nonEnglishEntries.count))
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ncWarning.opacity(0.05))
                .stroke(.ncWarning.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Download PDF
    private func downloadPDF() {
        let filename = "\(reportVM.reportType.rawValue.replacingOccurrences(of: " ", with: "_"))_\(Date().shortDateString).pdf"
        
        if let pdfData = reportVM.generatedPDFData {
            PDFGenerator.savePDF(data: pdfData, defaultFileName: filename)
        } else {
            PDFGenerator.savePDF(from: reportVM.generatedReport, defaultFileName: filename)
        }
    }
    
    // MARK: - Helpers
    private func reportTypeColor(_ type: ReportType) -> Color {
        switch type {
        case .weeklySummary: return .ncPrimary
        case .incidentReport: return .ncSecondary
        case .eyfsCoverage: return Color(hex: "A29BFE")
        }
    }
    
    private func wellbeingColor(_ score: Double) -> Color {
        if score >= 75 { return .ncSuccess }
        if score >= 50 { return .ncWarning }
        return .ncSecondary
    }
    
    private func wellbeingFilterDescription(_ score: Double) -> String {
        if score >= 100 {
            return "All children included in PDF report"
        } else if score >= 75 {
            return "PDF shows children scoring ≤ \(Int(score))"
        } else if score >= 50 {
            return "PDF focuses on children needing attention"
        } else {
            return "PDF shows only high-risk children (≤ \(Int(score)))"
        }
    }
}
