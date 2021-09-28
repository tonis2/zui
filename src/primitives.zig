const Color = @import("layout.zig").Color;

pub const Rectangle = struct {
    width: f32,
    height: f32,
    x: f32,
    y: f32,
    color: Color = Color{},
};

pub const Circle = struct {
    x: f32,
    y: f32,
    radius: f32,
    color: Color = Color{},
};
