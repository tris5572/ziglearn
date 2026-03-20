const expect = @import("std").testing.expect;

// エラーセットは列挙型に似ており、セット内の各エラーが値となる。
// Zigには例外はなく、エラーは値である。

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};
const AllocationError = error{OutOfMemory};

// エラーセットはその上位集合に強制される
test "coerce error from a subset to a superset" {
    const err: FileOpenError = AllocationError.OutOfMemory;
    try expect(err == FileOpenError.OutOfMemory);
}

// エラー集合型と別の型は、`!` 演算子を用いてエラー共用体型を形成できる。これらの型の値は、エラー値または別の型の値のいずれかになる。
// エラー共用型（error union type）の値を作成してみる。ここでは catch が使用され、その後に続く式は先行する値がエラーである場合に評価される。
// この catch はフォールバック値を提供するために使用されているが、代わりに noreturn (戻り値の型)、while (true)、その他を使用することも可能。
test "error union" {
    const maybe_error: AllocationError!u16 = 10;
    const no_error = maybe_error catch 0;

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);
}

// 関数はしばしばエラーユニオンを返す。
// 以下は catch を使用した例で、|err| 構文がエラー値を受け取る。
// これはペイロードキャプチャと呼ばれ、多くの場所で同様に使用される。詳細は後述。
// 補足：一部の言語ではラムダ式に類似した構文を使用するが、Zigではそうではない。
fn failingFunction() error{Oops}!void {
    return error.Oops; // 必ず失敗する
}

test "returning an error" {
    failingFunction() catch |err| {
        try expect(err == error.Oops);
        return;
    };
}

// `try x` は `x catch |err| return err` の省略形であり、エラー処理が適切でない場面で一般的に使用される。
// Zig の try と catch は、他の言語の try-catch とは無関係。
fn failFn() error{Oops}!i32 {
    try failingFunction(); // 必ず失敗する関数なので、error を返す
    return 12;
}

test "try" {
    const v = failFn() catch |err| {
        try expect(err == error.Oops);
        return; // エラーが発生するのでここで return
    };
    try expect(v == 12); // ここには到達しない
}

// errdefer は deferと同様に動作するが、errdefer のブロック内でエラーが発生した関数が返された場合にのみ実行される。
var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1; // このブロック(関数)でエラーが発生したときのみ実行される処理 → 必ず失敗するので、実行される
    try failingFunction(); // 必ず失敗する関数
}

test "errdefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problems == 99); // failFnCounter() で失敗したので、errdefer でインクリメントされている
        return;
    };
}

// 関数から返されるエラーユニオンは、明示的なエラーセットを持たないことで、そのエラーセットを推論されることがある。
// この推論されたエラーセットには、関数が返す可能性のあるすべてのエラーが含まれる。
fn createFile() !void {
    return error.AccessDenied;
}

test "inferred error set" {
    //type coercion successfully takes place
    const x: error{AccessDenied}!void = createFile();

    // Zig ではエラーユニオンを `_ = x;` で無視することはできない。
    // 必ず `try`, `catch` または `if` でアンラップする必要がある。
    _ = x catch {};
    // _ = createFile(); // これはできないということ。error union is discarded になる。
}

// エラーセットはマージ可能。
const A = error{ NotDir, PathNotFound };
const B = error{ OutOfMemory, PathNotFound };
const C = A || B;

// anyerror はグローバルエラーセットであり、全てのエラーセットの超集合であるため、任意のセットのエラーを強制的に割り当てられる可能性がある。その使用は一般的に避けるべきである。
