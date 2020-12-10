namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Op = (string, int);

final class Day8 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
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
        $program = vec<Op>[];
        $backlinks = dict<int, vec<int>>[];
        $potential_backlinks = dict<int, vec<int>>[];
        $current = 0;
        $step = 0;
        $pos = 0;
        foreach($lines as $line) {
            $parts = Str\split($line, " ");
            $op = $parts[0];
            $val = Str\to_int(Str\replace($parts[1], "+", ""));
            $program[] = tuple($op, $val);
            //print($parts[1]." ".Str\to_int(Str\replace($parts[1], "+", ""))."\n");
            switch($op){
                case "acc":
                    $to = $pos+1;
                    $potential = null;
                    break;
                case "jmp":
                    $to = $pos + $val;
                    $potential = $pos+1;
                    break;
                case "nop":
                    $to = $pos+1;
                    $potential = $pos + $val;
                    break;
            }
            if (C\contains_key($backlinks, $to)) {
                $backlinks[$to][] = $pos;
            } else {
                $backlinks[$to] = vec[$pos];
            }
            
            if ($potential is nonnull) {
                if (C\contains_key($potential_backlinks, $potential)) {
                    $potential_backlinks[$potential][] = $pos;
                } else {
                    $potential_backlinks[$potential] = vec[$pos];
                }
            }
            $pos++;
        }
        $visited = keyset<int>[];
        while($step < C\count($program)) {
            if (C\contains_key($visited, $current)) {
                break;
            }
            $visited[] = $current;
            $op = $program[$current][0];
            $val = $program[$current][1];
            print($op." ".$val."=");
            switch($op){
                case "acc":
                    $count+=$val;
                    $current++;
                    break;
                case "jmp":
                    $current+=$val;
                    break;
                case "nop":
                    $current++;
                    break;
            }
            print($count."\n");
            $step++;
        }
        
        // $last_index = C\count($program)-1;
        // print("potential_last: ".$potential_backlinks[$last_index][0]."\n");
        $backtracked = keyset<int>[];
        $queue = vec[C\count($program)-1];
        $index = 0;
        while($index < C\count($queue)) {
            $current = $queue[$index];
            if(C\contains_key($backlinks, $current)) {
                foreach($backlinks[$current] as $parent) {
                    if (!C\contains_key($backtracked, $parent)) {
                        $queue[] = $parent;
                    }
                }
            }
            if(
                C\contains_key($potential_backlinks, $current)
                &&
                C\contains_key($visited, $potential_backlinks[$current][0])
            ) {
                $fix_position = $potential_backlinks[$current][0];
                print("fix: ".$fix_position."\n");
                print("fix command: ".$program[$fix_position][0]."\n");
                if ($program[$fix_position][0] === "jmp") {
                    $program[$fix_position][0] = "nop";
                } else {
                    $program[$fix_position][0] = "jmp";
                }
                break;
            }
            $index++;
        }

        $count = 0;
        $current = 0;
        $visited = keyset<int>[];
        while($current < C\count($program)) {
            if (C\contains_key($visited, $current)) {
                break;
            }
            $visited[] = $current;
            $op = $program[$current][0];
            $val = $program[$current][1];
            print($op." ".$val."=");
            switch($op){
                case "acc":
                    $count+=$val;
                    $current++;
                    break;
                case "jmp":
                    $current+=$val;
                    break;
                case "nop":
                    $current++;
                    break;
            }
            print($count."\n");
            $step++;
        }

        
        return "".$count;
    }

    
}
