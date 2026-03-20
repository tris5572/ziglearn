const expect = @import("std").testing.expect;

// Zigのwhileループは、条件、ブロック、そして continue 式という3つの部分で構成されている。

// continue 式がない場合。
test "while" {
    var i: u8 = 2;
    while (i < 100) {
        i *= 2;
    }
    try expect(i == 128);
}

// continue 式がある場合。
// for 文っぽく、continue （次のループ突入時）で実行される式を、ループ条件の横に書ける
test "while with continue expression" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 10) : (i += 1) { // ← continue 式
        sum += i;
    }
    try expect(sum == 55);
    try expect(i == 11);
}

// continue
test "while with continue" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) continue;
        sum += i;
    }
    try expect(sum == 4); // 0 + 1 + 3
    try expect(i == 4);
}

// break
test "while with break" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) break;
        sum += i;
    }
    try expect(sum == 1);
}
