import Foundation
import SwiftUI

public final class SharedViews {
	public static func Timer(initialTime: TimeInterval, playingDate: Date?) -> Text {
		let range: ClosedRange<Date>
		if let playingDate = playingDate {
			let initialDeltaTime = Date.now - playingDate
			let initialDate = initialDeltaTime + initialTime
			range = (Date.now - initialDate)...(Date.now + (7.0 * 24.0 * 60.0 * 60.0))
		} else {
			range = (Date.now - initialTime)...(Date.now)
		}
		return Text(timerInterval: range, countsDown: false)
	}
}
