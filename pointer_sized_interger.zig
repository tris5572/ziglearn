const expect = @import("std").testing.expect;

// usize と isize は、ポインタと同じサイズの符号なし整数および符号付き整数として定義される。

test "usize" {
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(isize) == @sizeOf(*u8));
}
