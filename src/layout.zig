usingnamespace @import("./meta.zig");
usingnamespace @import("zalgebra");

pub const Color = struct {
    r: f32 = 1.0,
    g: f32 = 1.0,
    b: f32 = 1.0,
    a: f32 = 1.0,

    pub fn raw(self: Color) [4]f32 {
        return [4]f32{ self.r, self.g, self.b, self.a };
    }
};

width: f32 = 100.0,
height: f32 = 100.0,
x: f32 = 10.0,
y: f32 = 10.0,
z: f32 = 1.0,
gap: [2]f16 = [_]f16{ 0.0, 0.0 },
rows: u16 = 0,
columns: u16 = 0,
column: u16 = 0,
row: u16 = 0,
background: Color = Color{},
border: Color = Color{},

shader: u16 = 0,
clip: f32 = 0.0,
zIndex: f32 = 0,
