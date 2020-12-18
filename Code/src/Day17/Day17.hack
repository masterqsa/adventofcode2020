namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Cell = (int, int);

final class Day17 {
    use UtilsTrait;

    public $map = dict<string, Cell>[];
    public $odd = true;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
.#.
..#
###
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
        $this->map = dict<string, Cell>[];
        $lines = Str\split($input, "\n");
        $count = 0;

        $z = 0;
        $w = 0;
        $x = 0;
        foreach($lines as $line) {
            $last_num = Str\to_int($line);
            for($y = 0; $y < Str\length($line); $y++) {
                $val = $line[$y] === '#' ? 1 : 0;
                $this->setPoint($x, $y, $z, $w, $val);
            }
            $x++;
            $count++;
        }
        $this->odd = !$this->odd;

        print("initial map: \n");
        for($x = 0; $x < $count; $x++){
            $l = "";
            for($y = 0; $y < $count; $y++){
                $l = $l.($this->getPoint($x, $y, 0, 0)===1 ? "#" : ".");
            }
            print($l."\n");
        }
        print("end of map: \n");

        for($i = 1; $i <= 6; $i++) {
            for($z = -$i; $z <= $i; $z++){
                for($x = -$i; $x < $count + $i; $x++){
                    for($y = -$i; $y < $count + $i; $y++){
                        for($w = -$i; $w <= $i; $w++){
                            $this->mutatePoint($x, $y, $z, $w);
                        }
                    }
                }
            }
            $this->odd = !$this->odd;

            $active = 0;
            for($x = -$i; $x < $count + $i; $x++){
                for($y = -$i; $y < $count + $i; $y++){
                    for($z = -$i; $z < $count + $i; $z++){
                        for($w = -$i; $w < $count + $i; $w++){
                            $active += $this->getPoint($x, $y, $z, $w);
                        }
                    }
                }
            }
            print("step ".$i." active = ".$active."\n");
            for($x = -$i; $x < $count + $i; $x++){
                $l = "";
                for($y = -$i; $y < $count + $i; $y++){
                    $l = $l.($this->getPoint($x, $y, 0, 0)===1 ? "#" : ".");
                }
                print($l."\n");
            }
        }

        $active = 0;
        for($z = -$i; $z < $count + $i; $z++){
            for($x = -$i; $x < $count + $i; $x++){
                for($y = -$i; $y < $count + $i; $y++){
                    for($w = -$i; $w < $count + $i; $w++){
                        $active += $this->getPoint($x, $y, $z, $w);
                    }
                }
            }
        }
        //663 is too high
        //271 is too high
        //280 is too low
        print("\n"."active = ".$active."\n");
        return "".$count;
    }

    public function getPoint(int $x, int $y, int $z, int $w): int {
        $index = $this->odd ? 0 : 1;
        $point = $x." ".$y." ".$z." ".$w;
        if (C\contains_key($this->map, $point)) {
            return $this->map[$point][$index];
        }
        return 0;
    }

    public function setPoint(int $x, int $y, int $z, int $w, int $val): void {
        $index = $this->odd ? 1 : 0;
        $point = $x." ".$y." ".$z." ".$w;
        if (C\contains_key($this->map, $point)) {
            $cell = $this->map[$point];
            $cell[$index] = $val;
            $this->map[$point] = $cell;
        } else {
            $cell = $this->odd ? tuple(0, $val) : tuple($val, 0);
            $this->map[$point] = $cell;
        }
    }

    public function mutatePoint(int $x, int $y, int $z, int $w): void {
        $count = 0;
        $state = $this->getPoint($x, $y, $z, $w);
        for($i = -1; $i <= 1; $i++){
            for($j = -1; $j <= 1; $j++) {
                for($k = -1; $k <= 1; $k++) {
                    for($l = -1; $l <= 1; $l++) {
                        if ($i !== 0 || $j !== 0 || $k !== 0 || $l !==0) {
                            $count += $this->getPoint($x + $i, $y + $j, $z + $k, $w + $l);
                        }
                    }
                }
            }
        }
        
        if ($state === 1) {
            $val = $count !== 2 && $count !== 3 ? 0 : 1;
            $this->setPoint($x, $y, $z, $w, $val);
        } else {
            $val = ($count === 3 ? 1 : 0);
            $this->setPoint($x, $y, $z, $w, $val);
        }
        $state1 = $this->getPoint($x, $y, $z, $w);
        if ($state !== $state1) {
            throw new \Exception("Mem");
        }
    }
    
}
