// PDFGenerator.swift
// NurseryConnect — Setting Manager
// PDFKit & AppKit utility to generate paginated PDFs from HTML or text

import SwiftUI
import AppKit
import PDFKit
import WebKit

@MainActor
class PDFGenerator {
    
    /// Generates a paginated PDF document from an HTML string using a proper NSPrintInfo copy.
    /// Uses NSTextView rendering + NSPrintOperation to produce a paginated A4 PDF.
    static func generatePDF(from html: String) -> Data? {
        let paperSize = NSSize(width: 595.2, height: 841.8) // A4
        let margins: CGFloat = 50
        let printableWidth = paperSize.width - (margins * 2)
        let printableHeight = paperSize.height - (margins * 2)
        
        // Create a text view with proper printable size
        let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: printableWidth, height: printableHeight))
        textView.isEditable = false
        textView.isSelectable = false
        
        // Convert HTML to NSAttributedString
        guard let data = html.data(using: .utf8) else {
            print("PDFGenerator: Failed to encode HTML to UTF-8 data")
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attrString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            textView.textStorage?.setAttributedString(attrString)
        } catch {
            print("PDFGenerator: HTML to attributed string conversion failed: \(error)")
            return nil
        }
        
        textView.backgroundColor = .white
        
        // Let the text view layout its content fully
        textView.layoutManager?.ensureLayout(for: textView.textContainer!)
        
        // Create a fresh NSPrintInfo (NOT shared) to avoid side effects
        let printInfo = NSPrintInfo()
        printInfo.paperSize = paperSize
        printInfo.topMargin = margins
        printInfo.bottomMargin = margins
        printInfo.leftMargin = margins
        printInfo.rightMargin = margins
        printInfo.isHorizontallyCentered = false
        printInfo.isVerticallyCentered = false
        
        // Save to a temp file
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".pdf")
        
        let printDict = NSMutableDictionary(dictionary: printInfo.dictionary())
        printDict[NSPrintInfo.AttributeKey.jobDisposition] = NSPrintInfo.JobDisposition.save
        printDict[NSPrintInfo.AttributeKey.jobSavingURL] = tempURL
        
        let customPrintInfo = NSPrintInfo(dictionary: printDict as! [NSPrintInfo.AttributeKey: Any])
        
        let printOp = NSPrintOperation(view: textView, printInfo: customPrintInfo)
        printOp.showsPrintPanel = false
        printOp.showsProgressPanel = false
        printOp.canSpawnSeparateThread = false
        
        let success = printOp.run()
        
        guard success else {
            print("PDFGenerator: NSPrintOperation failed to run")
            return nil
        }
        
        // Small delay to let file system sync
        Thread.sleep(forTimeInterval: 0.1)
        
        if FileManager.default.fileExists(atPath: tempURL.path) {
            if let pdfDocument = PDFDocument(url: tempURL) {
                let pdfData = pdfDocument.dataRepresentation()
                try? FileManager.default.removeItem(at: tempURL)
                return pdfData
            } else {
                // Fallback: Read raw data directly
                let rawData = try? Data(contentsOf: tempURL)
                try? FileManager.default.removeItem(at: tempURL)
                return rawData
            }
        }
        
        print("PDFGenerator: Temp PDF file not found at \(tempURL.path)")
        return nil
    }
    
    /// Shows a macOS save panel to allow the user to save the PDF using pre-generated data.
    /// This avoids regenerating the PDF and uses the already-created data.
    static func savePDF(data pdfData: Data, defaultFileName: String) {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.pdf]
        savePanel.nameFieldStringValue = defaultFileName
        savePanel.title = "Save Report as PDF"
        savePanel.prompt = "Save"
        savePanel.canCreateDirectories = true
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                do {
                    try pdfData.write(to: url)
                    HapticManager.notification(.success)
                    NSWorkspace.shared.activateFileViewerSelecting([url])
                } catch {
                    print("PDFGenerator: Error saving PDF: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Fallback: Shows a macOS save panel and generates PDF from HTML before saving.
    static func savePDF(from html: String, defaultFileName: String) {
        guard let pdfData = generatePDF(from: html) else {
            print("PDFGenerator: Could not generate PDF from HTML for save")
            return
        }
        savePDF(data: pdfData, defaultFileName: defaultFileName)
    }
}
