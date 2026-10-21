import ActivityKit
import AppIntents
import Foundation
import SwiftUI

public struct TrackerAttributes: ActivityAttributes {
	public struct ContentState: Codable, Hashable {
		public var title: String = ""
		public var time: TimeInterval = 0.0
		public var playing: Bool = false
		public var playingDate: Date? = nil
		public var projectName: String? = nil
		public var projectIcon: String? = nil
		public var projectColor: ProjectColor = .none
		
		public init(task: TaskModel) {
			self.title = task.title
			self.time = task.time
			self.playing = task.playing
			self.playingDate = task.playingDate
			self.projectName = task.project?.title
			self.projectIcon = task.project?.icon
			self.projectColor = task.project?.color ?? .none
		}
	}
	
	public var id: UUID
	
	public init(id: UUID) {
		self.id = id
	}
}
