import SwiftUI
import Highlightr

public final class CustomHighglightDelegate: HighlightDelegate {
	weak private var textStorage: CodeAttributedString?
	
	init(textStorage: CodeAttributedString) {
		self.textStorage = textStorage
	}
	
	private func highlightCurrentLine(textView: UXTextView) {
		let cursorLocation = textView.selectedRanges.first?.rangeValue.location ?? 1
		
		var line = NSRange(location: 0, length: 0)
		
		textView.layoutManager?.lineFragmentRect(forGlyphAt: cursorLocation, effectiveRange: &line)
		
		let highlightColor = NSColor.systemBlue.withAlphaComponent(0.1)
		
		textView.textStorage?.addAttribute(.backgroundColor, value: NSColor.clear, range: NSRange(location: 0, length: textView.string.count))
		textView.textStorage?.addAttribute(.backgroundColor, value: highlightColor, range: line)
	}
	
	public func didHighlight(_ range: NSRange, success: Bool) {
		if let textStorage = textStorage {
			highlightCurrentLine(textView: textStorage.layoutManagers[0].firstTextView!)
		}
	}
}
