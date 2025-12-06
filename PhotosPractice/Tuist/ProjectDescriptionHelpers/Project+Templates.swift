import ProjectDescription

public extension Project {
    static let isProduction: Bool = {
        Environment.isProduction.getBoolean(default: false)
    }()
}

public extension Project {
    static func makeModule(
        name: String,
        product: Product = Project.isProduction ? .staticFramework : .framework,
        bundleID: String? = nil,
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil,
        hasExampleApp: Bool = false
    ) -> Project {
        let organizationName: String = "com.photosPractice"
        let targetBundleID: String = bundleID ?? "\(organizationName).\(name)"
        let targetVersion: String = "17.0"
        
        let mainTarget = Target.target(
            name: name,
            destinations: .iOS,
            product: product,
            bundleId: targetBundleID,
            deploymentTargets: .iOS(targetVersion),
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            settings: settings
        )
        
        var targets: [Target] = [mainTarget]
        
        guard hasExampleApp else { return Project(name: name, targets: targets) }
        let exampleTarget = Target.target(
            name: "\(name)Example",
            destinations: .iOS,
            product: .app,
            bundleId: "\(targetBundleID).example",
            deploymentTargets: .iOS(targetVersion),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [:]
            ]),
            sources: ["Example/Sources/**"],
            dependencies: [.target(name: name)]
        )
        targets.append(exampleTarget)
        return Project(name: name, targets: targets)
    }
    
    static func makeFeature(
        module: ModulePath.Feature,
        dependencies: [TargetDependency] = [],
        testNeeded: Bool = false
    ) -> Project {
        let name = module.rawValue
        let bundleID = "com.photosPractice.\(name)"
        let targetVersion: String = "17.0"
        
        var targets: [Target] = []
        
        let dataTarget = Target.target(
            name: "\(name)Data",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleID).Data",
            deploymentTargets: .iOS(targetVersion),
            sources: ["Data/Sources/**"],
            dependencies: [
                .core(.networking)
            ]
        )
        
        let domainTarget = Target.target(
            name: "\(name)Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleID).Domain",
            deploymentTargets: .iOS(targetVersion),
            sources: ["Domain/Sources/**"],
            dependencies: [
                .target(name: dataTarget.name),
                .core(.common)
            ]
        )
        
        let presentationTarget = Target.target(
            name: "\(name)Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleID).Presentation",
            deploymentTargets: .iOS(targetVersion),
            sources: ["Presentation/Sources/**"],
            resources: ["Presentation/Resources/**"],
            dependencies: [
                .target(name: domainTarget.name),
                .core(.designSystem)
            ] + dependencies
        )
        
        targets.append(contentsOf: [domainTarget, dataTarget, presentationTarget])
        guard testNeeded else { return Project(name: name, targets: targets) }
        
        let testTarget = Target.target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleID).Tests",
            deploymentTargets: .iOS(targetVersion),
            infoPlist: .default,
            sources: ["Tests/Sources/**"],
            dependencies: [
                .target(name: domainTarget.name),
                .target(name: dataTarget.name),
                .target(name: presentationTarget.name)
            ]
        )
        
        targets.append(testTarget)
        return Project(name: name, targets: targets)
    }
}
