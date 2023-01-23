import SwiftUI
import WebKit
import SafariServices

internal struct Webview: UIViewRepresentable {
    
    @Binding var dynamicHeight: Double
    let html: String
    
    let configuration: RichTextConfiguration
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var updateCount = 0
    
    init(dynamicHeight: Binding<Double>, html: String, configuration: RichTextConfiguration) {
        self._dynamicHeight = dynamicHeight
        self.html = html
        self.configuration = configuration
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        let webview = WKWebView()
        
        webview.navigationDelegate = context.coordinator
        webview.scrollView.bounces = false
        webview.scrollView.isScrollEnabled = false
        webview.isOpaque = false
        webview.backgroundColor = UIColor.clear
        webview.scrollView.backgroundColor = UIColor.clear
        webview.loadHTMLString(htmlContent, baseURL: nil)
        
        context.coordinator.webView = webview
        return webview
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.webView = uiView
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
    
    var htmlContent: String {
        return """
        <html>
            <head>
                <meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no'>
            </head>
            \(css)
            <body>
                \(html)
            </body>
        </html>
        """
    }
    
    var css: String {
        return """
        <style type='text/css'>
            img {
                max-height: 100%;
                min-height: 100%;
                height: auto;
                max-width: 100%;
                width: auto;
                margin-bottom: 5px;
                border-radius: \(configuration.imageCornerRadius)px;
            }
        
            html, h1, h2, h3, h4, h5, h6, p, dl, ol, ul, pre, blockquote, a {
                text-align: left|right|center;
                font-size: \(Int(configuration.textSize))sp;
                font-family: '\(configuration.font?.fontName ?? "-apple-system")';
                color: #\(colorScheme == .dark ? "FFFFFF" : "000000");
            }
            
            iframe {
                width: 100%;
                height: 250px;
            }
        
            a:link {
                color: \(UIColor(configuration.linkColor).resolvedColor(with: colorScheme.traitCollection).hexString);
            }
        </style>
        """
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(heightBinding: $dynamicHeight, linkBehaviour: configuration.linkBehaviour)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        weak var webView: WKWebView?
        var heightBinding: Binding<Double>
        var linkBehaviour: RichTextLinkBehaviour
        
        init(heightBinding: Binding<Double>, linkBehaviour: RichTextLinkBehaviour) {
            self.heightBinding = heightBinding
            self.linkBehaviour = linkBehaviour
            super.init()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight") { heightResult, error in
                if let heightDimension = heightResult as? Double {
                    DispatchQueue.main.async {
                        self.heightBinding.wrappedValue = heightDimension
                    }
                }
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated else {
                decisionHandler(.allow)
                return
            }
            
            defer {
                decisionHandler(.cancel)
            }
            
            switch linkBehaviour {
            case .externalBrowser:
                UIApplication.shared.open(url)
            case .inAppWebView(let readerMode):
                var viewController: UIViewController?
                if #available(iOS 15.0, *) {
                    viewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController
                } else {
                    viewController = UIApplication.shared.windows.first?.rootViewController
                }
                
                let configuration = SFSafariViewController.Configuration()
                configuration.entersReaderIfAvailable = readerMode
                viewController?.present(SFSafariViewController(url: url, configuration: configuration), animated: true, completion: nil)
            }
        }
    }
}
