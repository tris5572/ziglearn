const expect = @import("std").testing.expect;

// forループは、配列（および後述するその他の型）を反復処理するために使用される。
//
// while ループと同様に、for ループでも break や continue を使用できる。
// （ここでは、Zig では未使用の変数を保持できないため、_ に値を代入する必要がある）

test "for" {
    //character literals are equivalent to integer literals
    const string = [_]u8{ 'a', 'b', 'c' };

    for (string, 0..) |character, index| {
        _ = character;
        _ = index;
    }

    for (string) |character| {
        _ = character;
    }

    for (string, 0..) |_, index| {
        _ = index;
    }

    for (string) |_| {}
}
