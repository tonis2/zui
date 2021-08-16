usingnamespace @import("./meta.zig");

pub const Color = struct {
    r: u8 = 1.0,
    g: u8 = 1.0,
    b: u8 = 1.0,
    a: u8 = 1.0,

    pub fn value(self: *Color) Vec4 {
        return Vec4.new(self.r, self.g, self.b, self.a);
    }
};

width: f32 = 100.0,
height: f32 = 100.0,
x: f32 = 10.0,
y: f32 = 10.0,
z: f32 = 0,
gap: [2]f16 = [_]f16{ 0.0, 0.0 },
rows: u32 = 0,
columns: u32 = 0,
column: u32 = 0,
row: u32 = 0,
material: Color = Color{},
border: Color = Color{},
