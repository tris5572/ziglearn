const a = [5]u8{ 'h', 'e', 'l', 'l', 'o' };
const b = [_]u8{ 'w', 'o', 'r', 'l', 'd' }; // 配列リテラルでは `_` でサイズを推論可能

const length = b.len; // 5
