namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

final class Day10 {
    use UtilsTrait;

    public static $adapters = keyset<int>[];

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = null;
// <<<EOD
// 16
// 10
// 15
// 5
// 1
// 11
// 7
// 19
// 6
// 12
// 4
// EOD;
$sample2 = null; 
// <<<EOD
// 28
// 33
// 18
// 42
// 31
// 14
// 46
// 20
// 48
// 47
// 24
// 23
// 49
// 45
// 19
// 38
// 39
// 11
// 1
// 32
// 25
// 35
// 8
// 17
// 7
// 9
// 4
// 2
// 34
// 10
// 3
// EOD;
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

        $counts = dict<int, int>[];
        $counts[1]=0;
        $counts[2]=0;
        $counts[3]=0;
        $count = 0;
        $max = 0;
        
        $pos = 0;
        foreach($lines as $line) {            
            $val = Str\to_int($line);
            static::$adapters[] = $val;
            if ($val > $max) {
                $max = $val;
            }
        }
        $visited = keyset<int>[];
        $current = 0;
        ////Part 1
        // $used = 0;
        // while($used < C\count($adapters)) {
        //     if(C\contains_key($adapters, $current+1)) {
        //         $counts[1]++;
        //         $current+=1;
        //     } else if(C\contains_key($adapters, $current+2)) {
        //         $counts[2]++;
        //         $current+=2;
        //     } else if(C\contains_key($adapters, $current+3)) {
        //         $counts[3]++;
        //         $current+=3;
        //     }
        //     $used++;
        // }
        // return "".($counts[1]*($counts[3]+1));

        //Part 2
        $count = self::countVariations(0, $max);

        //84627647627264
        
        return "".$count;
    }

    <<__Memoize>>
    public function countVariations(int $start, int $goal): int {
        //print($start);
        if ($start === $goal) {
            return 1;
        }
        
        $count = 0;
        if(C\contains_key(static::$adapters, $start+1)) {
            $count+=self::countVariations($start+1, $goal);
        }
        if(C\contains_key(static::$adapters, $start+2)) {
            $count+=self::countVariations($start+2, $goal);
        }
        if(C\contains_key(static::$adapters, $start+3)) {
            $count+=self::countVariations($start+3, $goal);
        }
        //print(" -> ".$count."\n");
        return $count;
    }

    
}
