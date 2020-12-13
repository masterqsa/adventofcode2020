namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Seat = (string, string);

final class Day11 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
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
        $map = vec<vec<Seat>>[];
        $count = 0;
        
        $m = 0;
        $n = 0;
        foreach($lines as $line) {
            $map[] = vec<Seat>[];
            for($n = 0; $n < Str\length($line); $n++){
                $map[$m][] = tuple($line[$n], $line[$n]);
            }
            $m++;
        }
        
        print($m." ".$n."\n");
        $changed = true;
        $orig = 0;
        $ch = 1;
        //part 1
        //$taken_sits_bar = 4;
        //part 2
        $taken_sits_bar = 5;
        while($changed){
            $changed = false;
            for($i = 0; $i < $m; $i++) {
                $top = Math\max(vec[$i-1, 0]);
                $bottom = Math\min(vec[$i+1, $m-1]);
                for($j = 0; $j < $n; $j++) {
                    $left = Math\max(vec[$j-1, 0]);
                    $right = Math\min(vec[$j+1, $n-1]);
                    
                    $empties = 0;
                    $taken = 0;
                    #part 1
                    // for($y = $top; $y <= $bottom; $y++){
                    //     for($x = $left; $x <= $right; $x++){
                    //         if ($y === $i && $x === $j) {
                    //             continue;
                    //         }
                    //         $char = $map[$y][$x][$orig];
                    //         if ($char === 'L') {
                    //             $empties++;
                    //         } else if ($char === '#') {
                    //             $taken++;
                    //         }
                    //     }
                    // }

                    //part 2
                    $directions = vec[
                        tuple(-1,-1),
                        tuple(-1,0),
                        tuple(-1,1),
                        tuple(0,-1),
                        tuple(0,1),
                        tuple(1,-1),
                        tuple(1,0),
                        tuple(1,1),
                    ];
                    foreach($directions as $dir) {
                        $found = false;
                        $x = $j;
                        $y = $i;
                        while(!$found) {
                            $y += $dir[0];
                            $x += $dir[1];

                            if ($y < 0 || $y > $m-1 || $x < 0 || $x > $n-1) {
                                $found = true;
                            } else {
                                $char = $map[$y][$x][$orig];
                                if ($char === 'L') {
                                    $empties++;
                                    $found = true;
                                } else if ($char === '#') {
                                    $taken++;
                                    $found = true;
                                }
                            }
                        }
                    }

                    if ($taken === 0 && $map[$i][$j][$orig] === 'L') {
                        $map[$i][$j][$ch] = '#';
                        $changed = true;
                    } else if ($taken >= $taken_sits_bar && $map[$i][$j][$orig] === '#') {
                        $map[$i][$j][$ch] = 'L';
                        $changed = true;
                    } else {
                        $map[$i][$j][$ch] = $map[$i][$j][$orig];
                    }
                }
            }

            $exchange = $orig;
            $orig = $ch;
            $ch = $exchange;
            
        }

        for($i = 0; $i < $m; $i++) {
            for($j = 0; $j < $n; $j++) {
                if ($map[$i][$j][$orig] === '#') {
                    $count++;
                }
            }
        }

        
        return "".$count;
    }
    
}
