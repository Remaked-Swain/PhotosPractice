import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.app.name,
    product: .app,
    infoPlist: .extendingDefault(with: [
        "UILaunchScreen": [:]
    ]),
    resources: ["Resources/**"],
    dependencies: [
        .feature(.archive, layer: .presentation),
    ]
)
