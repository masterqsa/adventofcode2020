namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Dir = (int, int);

final class Day12 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
F10
N3
F7
R90
F11
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

        $x = 0;
        $y = 0;
        $dx = 10;
        $dy = 1;
        $angle = 0;
        foreach($lines as $line) {
            $op = $line[0];
            $val = Str\to_int(Str\slice($line, 1));
            //print($op." ".$val."\n");

            
            //part 1
            switch($op) {
                case "L":
                    $angle += $val;
                    $angle = $angle % 360;
                    $dir = self::getDir($angle, $dx, $dy);
                    $dx = $dir[0];
                    $dy = $dir[1];
                    $angle = 0;
                    //print("a = ".$angle."\n");
                    break;
                case "R":
                    $angle -= $val;
                    $angle = (360 + $angle) % 360;
                    $dir = self::getDir($angle, $dx, $dy);
                    $dx = $dir[0];
                    $dy = $dir[1];
                    $angle = 0;
                    //print("a = ".$angle."\n");
                    break;
                case "E":
                    $dx+= $val;
                    break;
                case "N":
                    $dy+= $val;
                    break;

                case "W":
                    $dx-= $val;
                    break;
                case "S":
                    $dy-= $val;
                    break;
                case "F":
                    
                    //print($dir[0]." ".$dir[1]."\n");
                    $x = $x + $dx * $val;
                    $y = $y + $dy * $val;
                    break;
            }
        }
        print($x." ".$y."\n");
        print((Math\abs($x)+Math\abs($y))."\n");
        
        //16460
        return "".$count;
    }

    //part 1
    // public function getDir(int $angle): (int, int) {
    //     switch($angle) {
    //         case 0:
    //             return tuple(1, 0);
    //         case 90:
    //             return tuple(0, 1);
    //         case 180:
    //             return tuple(-1, 0);
    //         case 270:
    //             return tuple(0, -1);
    //     }
    //     return tuple(0, 0);
    // }
    
    //part 2
    public function getDir(int $angle, int $dx, int $dy): (int, int) {
        switch($angle) {
            case 0:
                return tuple($dx, $dy);
            case 90:
                return tuple(-$dy, $dx);
            case 180:
                return tuple(-$dx, -$dy);
            case 270:
                return tuple($dy, -$dx);
        }
        return tuple(0, 0);
    }
}
