// PDFPreviewView.swift
// NurseryConnect — Setting Manager
// NSViewRepresentable wrapper for PDFKit's PDFView to display PDFs in SwiftUI
// Includes a styled header toolbar with download action

import SwiftUI
import PDFKit

// MARK: - PDF Preview with Header
struct PDFPreviewContainer: View {
    @Environment(ReportViewModel.self) private var reportVM
    let pdfData: Data
    @State private var isHoveringDownload = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header bar
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.ncPrimary.opacity(0.12))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.ncPrimary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(reportVM.reportType.rawValue)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text("\(reportVM.startDate.shortDateString) — \(reportVM.endDate.shortDateString)")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Download button
                Button {
                    let filename = "\(reportVM.reportType.rawValue.replacingOccurrences(of: " ", with: "_"))_\(Date().shortDateString).pdf"
                    PDFGenerator.savePDF(data: pdfData, defaultFileName: filename)
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.down.doc.fill")
                            .font(.system(size: 12))
                        Text("Download")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [.ncPrimary, .ncGradientEnd],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(
                                color: .ncPrimary.opacity(isHoveringDownload ? 0.35 : 0.1),
                                radius: isHoveringDownload ? 8 : 3,
                                x: 0,
                                y: 2
                            )
                    )
                }
                .buttonStyle(.plain)
                .onHover { h in
                    withAnimation(.easeOut(duration: 0.15)) { isHoveringDownload = h }
                }
                .scaleEffect(isHoveringDownload ? 1.03 : 1.0)
                .animation(.easeOut(duration: 0.15), value: isHoveringDownload)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(nsColor: .controlBackgroundColor))
            
            Divider()
            
            // PDF view
            PDFPreviewView(pdfData: pdfData)
        }
    }
}

// MARK: - PDFKit Wrapper
struct PDFPreviewView: NSViewRepresentable {
    let pdfData: Data
    
    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.pageShadowsEnabled = true
        pdfView.backgroundColor = NSColor.windowBackgroundColor
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {
        if let document = PDFDocument(data: pdfData) {
            nsView.document = document
        }
    }
}
