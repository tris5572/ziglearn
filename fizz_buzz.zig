//! https://zig.guide/posts/fizz-buzz/
//!
//! 標準出力に書き出す方法が Zig 0.15.1 から大きく変わっているため、書き換えた。
//!  参考: https://ziglang.org/download/0.15.1/release-notes.html#Upgrading-stdiogetStdOutwriterprint
//!  参考: https://dev.to/bkataru/zig-0151-io-overhaul-understanding-the-new-readerwriter-interfaces-30oe

const std = @import("std");

// if を使った実装
// pub fn main() !void {
//     var buf: [4096]u8 = undefined;
//     var stdout_writer = std.fs.File.stdout().writer(&buf);
//     const stdout = &stdout_writer.interface;
//     var count: u8 = 1;

//     while (count <= 16) : (count += 1) {
//         if (count % 15 == 0) {
//             try stdout.print("Fizz Buzz\n", .{});
//         } else if (count % 5 == 0) {
//             try stdout.print("Buzz\n", .{});
//         } else if (count % 3 == 0) {
//             try stdout.print("Fizz\n", .{});
//         } else {
//             try stdout.print("{}\n", .{count});
//         }
//     }
//     try stdout.flush();
// }

// switch を使った実装
// @intFromBool で int を u1 （1ビットの符号なし整数）に変換する
pub fn main() !void {
    var buf: [4096]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&buf);
    const stdout = &stdout_writer.interface;
    var count: u8 = 1;

    while (count <= 16) : (count += 1) {
        const div_3: u2 = @intFromBool(count % 3 == 0); // switch の条件式の計算でより大きな整数型に強制変換されて拡張されるため、型を指定
        const div_5 = @intFromBool(count % 5 == 0);

        switch (div_3 * 2 + div_5) { // 計算はビット演算を使用して div_3 << 1 | div_5 とも書ける
            0b10 => try stdout.print("Fizz\n", .{}),
            0b11 => try stdout.print("Fizz Buzz\n", .{}),
            0b01 => try stdout.print("Buzz\n", .{}),
            0b00 => try stdout.print("{}\n", .{count}),
        }
    }
    try stdout.flush();
}
