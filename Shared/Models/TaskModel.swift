import Foundation
import SwiftData

@Model
public final class TaskModel: Equatable {
	public var title: String = ""
	public var details: String = ""
	public var project: ProjectModel?
	public var time: TimeInterval = 0.0
	public var comment: String = ""
	public var playingDate: Date?
	public var creationDate: Date
	@Attribute(.unique) public var id: UUID
	
	public static func ==(lhs: borrowing TaskModel, rhs: borrowing TaskModel) -> Bool {
		return lhs.id == rhs.id
	}
	
	public init() {
		self.id = UUID()
		self.creationDate = Date.now
	}
	
	public init(id: UUID) {
		self.id = id
		self.creationDate = Date.now
	}
	
	public init(title: String = "", details: String = "", project: ProjectModel? = nil, time: TimeInterval = 0.0, comment: String = "", playing: Bool = false, playingDate: Date? = nil, creationDate: Date = .now, id: UUID = UUID()) {
		self.title = title
		self.details = details
		self.project = project
		self.time = time
		self.comment = comment
		self.playingDate = playingDate
		self.creationDate = creationDate
		self.id = id
	}
	
	public var playing: Bool { playingDate != nil }
	
	public func play() {
		if playingDate == nil {
			playingDate = .now
		}
	}
	
	public func pause() {
		if let playingDate {
			time += (.now - playingDate)
			self.playingDate = nil
		}
	}
	
	public func togglePlayback() {
		if playing {
			pause()
		} else {
			play()
		}
	}
}
