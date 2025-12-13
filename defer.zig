const expect = @import("std").testing.expect;

// deferは、現在のブロックを終了する際にステートメントを実行するために使用される。
test "defer" {
    var x: i16 = 5;
    {
        defer x += 2;
        try expect(x == 5);
    }
    try expect(x == 7);
}

// 単一のブロック内に複数の defer がある場合、それらは逆順で実行される。
test "multi defer" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
    }
    try expect(x == 4.5); // 2 で割ったあとに +2 される
}

// deferは、リソースが不要になった際に確実にクリーンアップされるようにするために有用。
// リソースを手動で解放することを覚えておく必要はなく、リソースを割り当てるステートメントのすぐ隣に defer ステートメントを追加できる。
