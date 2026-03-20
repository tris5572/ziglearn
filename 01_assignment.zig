const print = @import("std").debug.print;

// 値の代入は、次の構文に従う： `(const|var) identifier[: type] = value`
//
// - `const` は `identifier` が不変の値を格納する定数であることを示す
// - `var` は `identifier` が可変の値を格納する変数であることを示す
// - `: type` は `identifier` の型注釈であり、値のデータ型が推論可能な場合は省略できる

pub fn main() void {
    const constant: i32 = 5; // signed 32-bit constant
    var variable: u32 = 5000; // unsigned 32-bit variable

    constant = 1; // const 変数への代入は、エディタではエラーとならず、ビルド時にエラーとなる
    variable = 100;

    // @as は明示的な型変換を行う
    const inferred_constant = @as(i32, 5);
    var inferred_variable = @as(u32, 5000);

    inferred_constant = -5; // ビルド時にエラーとなる
    inferred_variable = 500;

    // 未定義値として undefined を使用できるが、JS とは異なり、undefined であるということを検知できない
    // undefined では型の指定が必須。推論すると、ビルド時にエラーになる
    const a: i32 = undefined;
    var b: u32 = undefined;

    a = -1;
    b = 1;
    print("{d}", .{b});
}
