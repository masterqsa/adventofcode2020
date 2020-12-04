namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec};

final class Day3 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
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
        $height = C\count($lines);
        $width = Str\length($lines[0]);
        // print($height."\n");
        // print($width."\n");
        $map = vec<vec<bool>>[];
        for($i = 0; $i < $height; $i++) {
            $map[] = vec<bool>[];
            $line = $lines[$i];
            //print($line." ");
            for($j = 0; $j < $width; $j++){
                $map[$i][] = $line[$j]==="#";
                //print($map[$i][$j] ? "#" : ".");

            }
            $x = ($i * 3) % $width;
            if ($map[$i][$x]) {
                $count++;
            }
            //print("\n");
        }
        $steps = vec[1, 3 ,5 ,7];
        $product = 1;
        foreach($steps as $step){
            $count = 0;
            for($i = 0; $i < $height; $i++) {
                $x = ($i * $step) % $width;
                if ($map[$i][$x]) {
                    $count++;
                }
            }
            $product = $product * $count;
        }

        $count = 0;
        for($i = 0; $i < $height; $i=$i + 2) {
            $x = (int)(($i / 2) % $width);
            if ($map[$i][$x]) {
                $count++;
            }
        }
        $product = $product * $count;

        
        return "".$count." ".$product;
    }

}