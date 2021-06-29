pub fn App(comptime state: type) type {
    return struct { state: state = null, width: f32 = 100.0, height: f32 = 100.0, title: []const u8 = "App" };
}
