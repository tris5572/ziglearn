const expect = @import("std").testing.expect;

// 3項演算子はない。

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
