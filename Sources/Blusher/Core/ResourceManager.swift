public class ResourceManager {
    nonisolated(unsafe) public static var shared: ResourceManager = ResourceManager()

    private var _resources: [Resource] = []

    internal init() {
        //
    }

    public func register(_ resource: Resource) {
        _resources.append(resource)
    }

    public func getResource(_ path: String) -> Resource? {
        for resource in _resources {
            if resource.path == path {
                return resource
            }
        }

        return nil
    }
}
