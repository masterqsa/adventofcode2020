namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Op = (string, int);

final class IntComp {
    // use UtilsTrait;

    public static $program = vec<Op>[];

    public int $pos;
    public int $acc;

    public function __construct(int $start_pos = 0, int $start_acc = 0) { // instance method
        $this->pos = $start_pos;
        $this->acc = $start_acc;
    }

}