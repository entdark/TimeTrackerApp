import Foundation

final class TaskTimer {
	private let initialOffset: TimeInterval
	private let timeInterval: TimeInterval
	private let repeats: Bool
	private let block: (TimeInterval) -> ()
	private let startDate = Date.now
	
	private var pauseDate = Date.now
	private var fireDate = Date.now
	private var lastScheduledDate = Date.now
	private(set) var elapsed: TimeInterval = 0.0
	private var timer: Timer?
	private(set) var executing = false {
		didSet {
			if !executing {
				pauseDate = .now
			} else {
				lastScheduledDate = .now
				fireDate = .now
			}
		}
	}
	
	init(initialOffset: TimeInterval = 0.0, timeInterval: TimeInterval, repeats: Bool, block: @escaping (TimeInterval) -> Void) {
		self.initialOffset = initialOffset
		self.timeInterval = timeInterval
		self.repeats = repeats
		self.block = block
	}
	
	static func scheduledTimer(initialOffset: TimeInterval = 0.0, withTimeInterval timeInterval: TimeInterval, repeats: Bool, block: @escaping (TimeInterval) -> ()) -> TaskTimer {
		let taskTimer = TaskTimer(initialOffset: initialOffset, timeInterval: timeInterval, repeats: repeats, block: block)
		taskTimer.fire()
		return taskTimer
	}
	
	func pause() {
		if executing {
			timer?.invalidate()
			executing = false
			block(elapsed + initialOffset)
		}
	}
	
	func fire() {
		if executing {
			return
		}
		executing = true
		timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats, block: { [weak self] timer in
			guard let self else {
				return
			}
			elapsed += (Date.now - lastScheduledDate)
			lastScheduledDate = .now
			block(elapsed + initialOffset)
		})
	}
}

enum TaskPlayback {
	case playing
	case paused
}
