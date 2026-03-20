//! ほとんどのプログラムでは、コンパイル時に長さが確定しないバッファを追跡する必要がある。
//! このために多要素ポインタ（複数の要素を持つポインタ）が用いられる。
//! これらは単一要素ポインタと同様に動作するが、構文が *T ではなく [*]T となる。
//!
//! 単一要素ポインタと多要素ポインタの違いは以下の通り。
//!
//! Single-item pointers
//!   - 参照外し可能、 ptr.*
//!   - インデックスアクセスできない
//!   - ポインタ演算できない
//!   - アイテムのサイズは何でもよく、不明
//!   - 配列ポインタからの強制変換できない
//! Multi-item pointers
//!   - 参照外しできない
//!   - インデックスアクセス可能、 ptr[0]
//!   - ポインタ演算可能、 ptr + 1 または ptr - 1
//!   - アイテムのサイズは分かっている必要がある
//!   - 配列ポインタからの強制変換可能
//!
//! Single-item pointers と同様に、Multi-item pointers も const などの属性をすべて持つことができる。

const expect = @import("std").testing.expect;

/// このサンプルコードでは、任意の長さのバッファを受け取れる関数を記述している。
/// バイト配列への Single-item pointers が、バイトの Multi-item pointers に強制変換される点に注目。
fn doubleAllManypointer(buffer: [*]u8, byte_count: usize) void {
    var i: usize = 0;
    while (i < byte_count) : (i += 1) buffer[i] *= 2;
}

test "many-item pointers" {
    var buffer: [100]u8 = [_]u8{1} ** 100; // 100バイトのバッファーを確保（中身はすべて 1）
    const buffer_ptr: *[100]u8 = &buffer;

    const buffer_many_ptr: [*]u8 = buffer_ptr; // 100バイトのバッファーのポインタを、Single から Double へ矯正変換
    doubleAllManypointer(buffer_many_ptr, buffer.len); // バッファーの中身をすべて2倍する
    for (buffer) |byte| try expect(byte == 2);

    const first_elem_ptr: *u8 = &buffer_many_ptr[0];
    const first_elem_ptr_2: *u8 = @ptrCast(buffer_many_ptr);
    try expect(first_elem_ptr == first_elem_ptr_2);
}

// その関数に誤った byte_count を渡した場合に何が起こるかを考えてみるとよい。
// プログラマーはこれらのバッファの長さを追跡（または何らかの方法で把握）することが求められている。
// この関数は、与えられたバッファに対して有効な長さを渡すことを事実上信頼している点に留意すべき。

// 複数の要素を持つポインタから単一要素のポインタへ変換するには、要素をインデックス指定して間接参照するか、@ptrCast を使用してポインタ型をキャストする。
// これはバッファの長さが少なくとも 1 以上の場合にのみ有効。
