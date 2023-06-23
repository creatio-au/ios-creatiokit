//
//  SwiftUIView.swift
//  
//
//  Created by Davis Allie on 23/6/2023.
//

import PDFKit
import SwiftUI

public struct PDFView: UIViewRepresentable {
    
    let url: URL
    public init(_ url: URL) {
        self.url = url
    }

    public func makeUIView(context: UIViewRepresentableContext<PDFView>) -> PDFView.UIViewType {
        let pdfView = PDFKit.PDFView()
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }

    public func updateUIView(_ uiView: PDFKit.PDFView, context: UIViewRepresentableContext<PDFView>) {
        uiView.document = PDFDocument(url: self.url)
    }
    
}
