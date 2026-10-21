import SwiftData
import SwiftUI

@Model
public final class ProjectModel: Equatable {
	private static let noProjectId = UUID(uuid: UUID_NULL)
	
	public static let noProject: ProjectModel = {
		var project = ProjectModel(id: ProjectModel.noProjectId)
		project.title = "Без проекта"
		return project
	}()
	
	public var title: String = ""
	public var icon: String?
	public var color = ProjectColor.none
	@Attribute(.unique) public var id: UUID
	
	public static func ==(lhs: borrowing ProjectModel, rhs: borrowing ProjectModel) -> Bool {
		return lhs.id == rhs.id
	}
	
	public convenience init() {
		self.init(id: UUID())
	}
	
	private init(id: UUID) {
		self.id = UUID()
	}
}

public enum ProjectColor: Codable, CaseIterable {
	case none
	case gray2
	case gray
	case black
	case blue
	case indigo
	case blue2
	case cyan
	case mint
	case green
	case green2
	case brown
	case red
	case orange
	case yellow
	case purple
	case pink
}

public extension ProjectColor {
	func toColor() -> Color {
		switch self {
		case .none:
			Color(uiColor: .systemGray5)
		case .gray2:
			Color(uiColor: .systemGray2)
		case .gray:
			Color(uiColor: .gray)
		case .black:
			.black
		case .blue:
			Color(red: 0, green: 0.235, blue: 1.0)
		case .indigo:
			.indigo
		case .blue2:
			.blue
		case .cyan:
			.cyan
		case .mint:
			.mint
		case .green:
			Color(red: 0.031, green: 0.533, blue: 0.047)
		case .green2:
			.green
		case .brown:
			.brown
		case .red:
			.red
		case .orange:
			.orange
		case .yellow:
			.yellow
		case .purple:
			.purple
		case .pink:
			Color(red: 1, green: 0.4, blue: 0.8)
		}
	}
}
