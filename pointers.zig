const expect = @import("std").testing.expect;

// ポインターは *T という構文であり、T は子型を表す。
// Zigにおける通常のポインタは、値として 0 や null を持つことができない。

// 参照は `&variable` で行い、参照外しは variable.* で行う。

fn increment(num: *u8) void {
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try expect(x == 2);
}

// *T を値 0 に設定しようとする行為は、検出可能な不正な動作である

test "naughty pointer" {
    var x: u16 = 5;
    x -= 5;
    var y: *u8 = @ptrFromInt(x); // 検出されてエラーになる。 error: pointer type '*u8' does not allow address zero
    y = y;
}

// Zig には const ポインタも存在し、参照先のデータを変更することはできない。
// const 変数を参照すると const ポインタが生成される。

test "const pointers" {
    const x: u8 = 1;
    var y = &x;
    y.* += 1;
}
