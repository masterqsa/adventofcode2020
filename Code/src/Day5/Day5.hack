namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict};

final class Day5 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
FBFBBFFRLR
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL
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

        $max = 0;
        $min = 1000;
        $count = 0;
        $current = 0;
        $map = dict<int,int>[];
        foreach($lines as $line) {
            $part = 64;
            $row = 0;
            for($i = 0; $i < 7; $i++) {
                if($line[$i] === "B") {
                    $row+=$part;
                }
                $part = $part / 2;
            }
            $part = 4;
            $column = 0;
            for($i = 7; $i < 10; $i++) {
                if($line[$i] === "R") {
                    $column+=$part;
                }
                $part = $part / 2;
            }
            $current = $row * 8 + $column;
            $map[$current] = $current;
            print($current."\n");

            if ($current > $max) {
                $max = $current;
            }
            if ($current < $min) {
                $min = $current;
            }
        }
        for($i = $min; $i < $max; $i++) {
            if (!C\contains_key($map, $i)) {
                return "missing: ".$i;
            }
        }

        
        
        return "".$max;
    }

    
}