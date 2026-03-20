const expect = @import("std").testing.expect;

// Zig の if 文は bool 型（つまり true または false）の値を受け付ける。
// C や JavaScript のような言語とは異なり、暗黙的に bool 型に変換される値はない。
//
// 3項演算子 (cond ? a : b) は Zig にはない。

test "if statement" {
    const a = true;
    var x: u16 = 0;
    // 条件に書けるのは bool のみ
    if (a) {
        x += 1;
    } else {
        x += 2;
    }
    try expect(x == 1);
}

// if 文も式として動作する。（= 値を返せる）

test "if statement expression" {
    const a = true;
    var x: u16 = 0;
    x += if (a) 1 else 2;
    try expect(x == 1);
}
