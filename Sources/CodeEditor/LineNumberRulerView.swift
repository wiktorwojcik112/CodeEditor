//
//  LineNumberRulerView.swift
//  Based on https://developer.apple.com/forums/thread/683064 by Marcin Krzyżanowski.

import Cocoa

class LineNumberRulerView: NSRulerView {
	private weak var textView: NSTextView?
	
	init(textView: NSTextView) {
		self.textView = textView
		super.init(scrollView: textView.enclosingScrollView!, orientation: .verticalRuler)
		clientView = textView.enclosingScrollView!.documentView
		
		NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: textView, queue: nil) { [weak self] _ in
			self?.needsDisplay = true
		}
		
		NotificationCenter.default.addObserver(forName: NSText.didChangeNotification, object: textView, queue: nil) { [weak self] _ in
			self?.needsDisplay = true
		}
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func drawHashMarksAndLabels(in rect: NSRect) {
		guard let context = NSGraphicsContext.current?.cgContext,
			  let textView = textView,
			  let layoutManager = textView.layoutManager
		else {
			return
		}
		
		var relativePoint = self.convert(NSZeroPoint, from: textView)
		
		relativePoint.y += 18
		
		context.saveGState()
		
		context.textMatrix = CGAffineTransform(scaleX: 1, y: isFlipped ? -1 : 1)
		
		let attributes: [NSAttributedString.Key: Any] = [
			.font: textView.font!,
			.foregroundColor: NSColor.secondaryLabelColor
		]
		
		var lineNumber = 1
		
		layoutManager.enumerateLineFragments(forGlyphRange: layoutManager.glyphRange(for: textView.textContainer!)) { rect, usedRect, textContainer, glyphRange, stop in
			
			let fragmentFrame = usedRect
			
			let locationForFirstCharacter = CGPoint(x: 5, y: 3)
			let ctline = CTLineCreateWithAttributedString(CFAttributedStringCreate(nil, "\(lineNumber)" as CFString, attributes as CFDictionary))
			context.textPosition = fragmentFrame.origin.applying(.init(translationX: -1, y: locationForFirstCharacter.y + relativePoint.y))
			CTLineDraw(ctline, context)
			
			lineNumber += 1
		}
		
		context.restoreGState()
	}
}
