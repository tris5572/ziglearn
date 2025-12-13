// Zig は実行時に問題を検出できる安全性を提供する。
// 安全モードは有効化または無効化が可能。
// Zig にはいわゆる「検出可能な不正動作」が多数存在する。
// これは安全モード有効時には不正動作が捕捉され（パニックを引き起こす）、無効時には未定義動作となることを意味する。
// 速度低下という代償はあるものの、安全モードを有効にしてソフトウェアの開発とテストを行うことを強く推奨する。
// 一部のビルドモードでは安全性がオフになる。

const print = @import("std").debug.print;
// 例えば、実行時安全機能は範囲外インデックスから保護します。
test "out of bounds" {
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    const b = a[index]; // 範囲外アクセスで実行時エラーとなる

    _ = b;
    index = index;
}

// 組み込み関数 @setRuntimeSafety を使用して、現在のブロックの実行時安全性を無効にすることができる。
test "out of bounds, no safety" {
    @setRuntimeSafety(false);
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    const b = a[index]; // 実行時安全性を無効化しているので、範囲外アクセスで実行時エラーとならない

    print("{d}", .{b}); // アクセスできるが、値は不定（なはず）
    // _ = b;
    index = index;
}

// unreachable は、この文が到達されないことをコンパイラに保証するもの。
// 分岐が不可能であることをコンパイラに伝え、最適化処理がこれを活用できるようにする。
// unreachable の到達は検出可能な不正行為。

// noreturn 型であるため、他のすべての型と互換性があります。ここでは u32 型に強制変換される。

test "unreachable" {
    const x: i32 = 1;
    const y: u32 = if (x == 2) 5 else unreachable; // unreachable に到達しているので panic
    _ = y;
}

const expect = @import("std").testing.expect;

fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable,
    };
}

test "unreachable switch" {
    try expect(asciiToUpper('a') == 'A');
    try expect(asciiToUpper('A') == 'A');
}
