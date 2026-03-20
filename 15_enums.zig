const expect = @import("std").testing.expect;

const Direction = enum { north, south, east, west };

// 数値型は（整数）タグ型を指定している場合がある
const Value = enum(u2) { zero, one, two };

// 列挙型の順序値は0から始まる。これらは組み込み関数@intFromEnumでアクセスできる。
test "enum ordinal value" {
    try expect(@intFromEnum(Value.zero) == 0);
    try expect(@intFromEnum(Value.one) == 1);
    try expect(@intFromEnum(Value.two) == 2);
}

// 値は上書き可能であり、次の値はその値から継続される。

const Value2 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    million = 1000000,
    next,
};

test "set enum ordinal value" {
    try expect(@intFromEnum(Value2.hundred) == 100);
    try expect(@intFromEnum(Value2.thousand) == 1000);
    try expect(@intFromEnum(Value2.million) == 1000000);
    try expect(@intFromEnum(Value2.next) == 1000001); // million + 1
}

// 列挙型にはメソッドを定義できる。
// これらは名前空間付きの関数として機能し、ドット記法で呼び出すことができる。

const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

test "enum method" {
    // enum 自体だけではなく、enum の値からもメソッドを呼び出せる
    try expect(Suit.spades.isClubs() == Suit.isClubs(.spades));
}

// 列挙型には変数宣言と定数宣言も指定できる。
// これらは名前空間付きのグローバル変数として機能し、その値は列挙型のインスタンスとは無関係で関連付けられていない。

const Mode = enum {
    var count: u32 = 0;
    on,
    off,
};

test "hmm" {
    Mode.count += 1; // 名前空間付きのグローバル変数
    try expect(Mode.count == 1);
    try expect(@intFromEnum(Mode.on) == 0); // count はグローバル変数なので enum の定義とは関係ない
}
