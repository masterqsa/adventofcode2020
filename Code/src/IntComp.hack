namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Op = (string, int);

final class IntComp {
    // use UtilsTrait;

    public static $program = vec<Op>[];

    public int $pos;
    public int $acc;

    public function __construct(int $start_pos = 0, int $start_acc = 0) {
        $this->pos = $start_pos;
        $this->acc = $start_acc;
    }

    public function Run(): int {
        while(self::$pos >= 0 && self::$pos < C\count(self::$program)) {
            $op = self::$program[self::$pos][0];
            $val = self::$program[self::$pos][1];
            //print($op." ".$val."=");
            switch($op){
                case "acc":
                    self::$acc+=$val;
                    self::$pos++;
                    break;
                case "jmp":
                    self::$pos+=$val;
                    break;
                case "nop":
                    self::$pos++;
                    break;
            }
            //print(self::$acc."\n");
        }
        return self::$acc;
    }
}