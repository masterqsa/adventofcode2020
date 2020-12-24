namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Win = (int, vec<int>); 

final class Cup {
    public int $val;
    public Cup $next;

    public function __construct(int $val, Cup $next = null) {
        $this->val = $val;
        $this->next = $next ?? $this;
    }
}

final class Day23 {
    use UtilsTrait;

    public $cups = dict<int, Cup>[];

    public $len = 9;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
389125467
EOD;
$sample2 = null;
$sample3 = null;
        static::runSamplesAndActual(
            vec[$sample1, $sample2, $sample3],
            $s,
            inst_meth($this, 'doCase'),
        );
    }

    public function doCase(
        string $input,
    ): string {

        $lines = Str\split($input, "\n");
        $count = 0;
        $this->cups = dict<int, Cup>[];
        $this->len = 1000000;
        $root = new Cup(0);
        $current = $root;
        foreach($lines as $line) {
            for($i = 0; $i < Str\length($line); $i++) {
                $cup = new Cup(Str\to_int($line[$i]));
                $current->next = $cup;
                $current = $cup;
                $this->cups[$cup->val] = $cup;
            }
            for($i = 10;$i <= $this->len; $i++){
                $cup = new Cup($i);
                $current->next = $cup;
                $current = $cup;
                $this->cups[$i] = $cup;
            }
        }

        // $current = $root->next;
        // for($i = 0; $i < Str\length($line); $i++) {
        //     print($current->val."\n");
        //     $current = $current->next;
        // }
        $current->next = $root->next;
        $current = $root->next;

        for($i = 0; $i < 10000000; $i++) {
            if ($i % 1000 === 0) {
                print("turn: ".$i."\n");
            }
            $current = $this->turn($current);
        }

        $current = $this->cups[1];
        print("one: ".$current->val."\n");

        $mult = 1;
        for($i = 0; $i < 2; $i++) {
            $current = $current->next;
            $mult *= $current->val;
            print($current->val." ");
        }
        
        print("\n");
        print($mult."\n");
            
        //You got rank 736 on this star's leaderboard.
        return "".$count;
    }

    public function turn(Cup $current): Cup {
        $val = $current->val;

        $cut = $current->next;
        $cut_end = $cut->next->next;

        $current->next = $cut_end->next;
        $excluded_keys = keyset[$cut->val, $cut->next->val, $cut->next->next->val];
        $pos = null;

        $look_for_max = false;
        if (C\contains_key($excluded_keys,$val - 1)) {
            if (C\contains_key($excluded_keys,$val - 2)) {
                if (C\contains_key($excluded_keys,$val - 3)) {
                    if ($val - 4 > 0) {
                        $pos = $this->cups[$val-4];
                    } else {
                        $look_for_max = true;
                    }
                } else {
                    if ($val - 3 > 0) {
                        $pos = $this->cups[$val-3];
                    } else {
                        $look_for_max = true;
                    }
                }
            } else {
                if ($val - 2 > 0) {
                    $pos = $this->cups[$val-2];
                } else {
                    $look_for_max = true;
                }
            }
        } else {
            if ($val - 1 > 0) {
                $pos = $this->cups[$val-1];
            } else {
                $look_for_max = true;
            }
        }
        if ($look_for_max) {
            if (C\contains_key($excluded_keys,$this->len)) {
                if (C\contains_key($excluded_keys,$this->len - 1)) {
                    if (C\contains_key($excluded_keys,$this->len - 2)) {
                        $pos = $this->cups[$this->len - 3];
                    } else {
                        $pos = $this->cups[$this->len - 2];
                    }
                } else {
                    $pos = $this->cups[$this->len - 1];
                }
            } else {
                $pos = $this->cups[$this->len];
            }
        }
        
        $next = $pos->next;
        $pos->next = $cut;
        $cut_end->next = $next;
        return $current->next;
    }
    
}
