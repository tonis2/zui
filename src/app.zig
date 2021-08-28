pub fn App(comptime state: type) type {
    return struct { state: state = null, width: u32 = 100.0, height: u32 = 100.0, title: []const u8 = "App" };
}
