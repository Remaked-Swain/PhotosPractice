import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(name: ModulePath.core(.networking).name, dependencies: [.core(.common)])
