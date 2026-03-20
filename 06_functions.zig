const expect = @import("std").testing.expect;

// 関数の引数はすべて immutable。
// 変更するときは明示的にコピーする必要がある。
// 変数名は snake_case だが、関数名は camelCase。

fn addFive(x: u32) u32 {
    return x + 5;
}

test "function" {
    const y = addFive(0);
    try expect(@TypeOf(y) == u32);
    try expect(y == 5);
}

// 再帰呼び出しも可能。
// 再帰ではコンパイラが最大スタックサイズを計算できず、スタックオーバーフローを起こす可能性がある。安全な再帰の実現方法もある。
fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function recursion" {
    const x = fibonacci(10);
    try expect(x == 55);
}

test "function2" {
    // addFive(0); // 関数の戻り値を受け取らないことはできない。
    _ = addFive(0); // _ を使って無視できる。これはグローバルスコープでは機能せず、関数やブロック内でのみ有効。
}
