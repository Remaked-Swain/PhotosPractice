import ProjectDescription

public enum ModulePath {
    case app
    case core(Core)
    case feature(Feature)
}


// MARK: - Nested Types

extension ModulePath {
    public enum Core: String {
        case common = "Common"
        case designSystem = "DesignSystem"
        case networking = "Networking"
    }
    
    public enum Feature: String {
        case archive = "Archive"
    }
}


// MARK: - ModulePath + Helpers

public extension ModulePath {
    var path: Path {
        switch self {
        case .app: Path.relativeToRoot("Project/App")
        case let .core(module): Path.relativeToRoot("Projects/Core/\(module.rawValue)")
        case let .feature(module): Path.relativeToRoot("Projects/Features/\(module.rawValue)")
        }
    }
    
    var name: String {
        switch self {
        case .app: "App"
        case let .core(module): module.rawValue
        case let .feature(module): module.rawValue
        }
    }
}


/// Clean Architecture 레이어 정의
public enum FeatureLayer: String {
    case domain = "Domain"
    case data = "Data"
    case presentation = "Presentation"
    case tests = "Tests"
}


// MARK: - TargetDependency + Helpers

/// 모듈 템플릿화를 위한 확장
public extension TargetDependency {
    static func core(_ module: ModulePath.Core) -> TargetDependency {
        .project(target: module.rawValue, path: ModulePath.core(module).path)
    }
    
    static func feature(_ module: ModulePath.Feature, layer: FeatureLayer) -> TargetDependency {
        let targetName = "\(module.rawValue)\(layer.rawValue)"
        return .project(target: targetName, path: ModulePath.feature(module).path)
    }
}
