const expect = @import("std").testing.expect;

// Zig の switch 文は文であり式でもある。
// すべての分岐の型は、スイッチ対象の型に強制変換されなければならない。
// すべての可能な値には対応する分岐が必要であり、値を省略することはできない。
// ケースが他の分岐にフォールスルーすることはできない。

// switch 文の例。この switch の網羅性を満たすために else は必須で。
test "switch statement" {
    var x: i8 = 10;
    switch (x) {
        -1...1 => {
            x = -x;
        },
        10, 100 => {
            // 符号付き整数を除算する際には特別な考慮が必要
            x = @divExact(x, 10); // 割り切れなかったときにエラーになる
            // x = x / 10; // これはエラーになる ← `signed integers must use @divTrunc, @divFloor, or @divExact`
        },
        else => {},
    }
    try expect(x == 1);
}

// switch 式
test "switch expression" {
    var x: i8 = 10;
    x = switch (x) {
        -1...1 => -x,
        10, 100 => @divExact(x, 10),
        else => x,
    };
    try expect(x == 1);
}
