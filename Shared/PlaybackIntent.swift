import AppIntents

public struct PlaybackIntent: LiveActivityIntent {
	public static var title: LocalizedStringResource = "Playback"
	
	public static var openAppWhenRun: Bool = false
	public static let supportedModes: IntentModes = [.background]
	
	@Parameter(title: "Task ID")
	public var id: String
	
	public init() {}
	
	public init(id: String) {
		self.id = id
	}
	
	@MainActor
	public func perform() async throws -> some IntentResult {
		guard let id = UUID(uuidString: id) else {
			return .result()
		}
		
		let tasks: [TaskModel]? = ModelsManager.shared.fetch(predicate: #Predicate {$0.id == id})
		if let task = tasks?.first {
			task.togglePlayback()
			ModelsManager.shared.save()
			
			let manager = LiveActivityManager.shared
			await manager.startOrUpdate(task: task, forceUpdate: true)
		}
		
		return .result()
	}
}
