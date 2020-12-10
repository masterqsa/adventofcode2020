namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Op = (string, int);

final class Day9 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
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
        $p_len = 25;
        $numbers = vec[];
        $count = 0;
        
        foreach($lines as $line) {
            $val = Str\to_int($line);
            $numbers[] = $val;
        
        }
        
        for($i = $p_len; $i < C\count($numbers); $i++) {
            $current = $numbers[$i];
            if (!static::findPair(Vec\slice($numbers, $i-$p_len, $p_len), $current)) {
                $target = $current;
                break;
            }
        }

        $start = 0;
        $current = 0;
        
        for($i = 0; $i < C\count($numbers); $i++) {
            $current += $numbers[$i];
            while ($current > $target) {
                $current -= $numbers[$start];
                $start++;
            }
            if ($current === $target) {
                $min = 100000000000000000;
                $max = 0;
                for($j = $start; $j <= $i; $j++) {
                    if ($min > $numbers[$j]) {
                        $min = $numbers[$j];
                    }
                    if ($max < $numbers[$j]) {
                        $max = $numbers[$j];
                    }

                }
                return "".($min + $max);
            }
        }
        

        
        return "".$count;
    }

    public static function findPair(vec<int> $numbers, int $target): bool {
        $d = keyset[];
        foreach($numbers as $num) {
            if (C\contains_key($d, $num)) {
                return true;
            }
            $d[]= ($target - $num); 
        }
        return false;
    }
    
}
