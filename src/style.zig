pub const Color = struct {
    r: u8 = 1.0,
    g: u8 = 1.0,
    b: u8 = 1.0,
    a: u8 = 1.0,

    pub fn value(self: *Color) [4]u8 {
        return [4]u8{ self.r, self.g, self.b, self.a };
    }
};

pub const Style = struct {
    width: u16 = 100.0,
    height: u16 = 100.0,
    x: u16 = 10.0,
    y: u16 = 10.0,
    z: u16 = 0,
    gap: [2]u16 = [_]u16{ 0.0, 0.0 },
    rows: u32 = 0,
    columns: u32 = 0,
    column: u32 = 0,
    row: u32 = 0,
    background: Color = Color{},
    textColor: Color = Color{},
};
