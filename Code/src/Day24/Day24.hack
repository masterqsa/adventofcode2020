namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Tile = (bool, bool); 
newtype Coord = (int, int);

final class Day24 {
    use UtilsTrait;

    public $tiles = dict<string, Tile>[];

    public $neigh = vec[tuple(2, 0), tuple(-2, 0), tuple(-1, 1), tuple(1,1), tuple(-1, -1), tuple(1, -1)];

    public $turn = false;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
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
        $this->tiles = dict<string, Tile>[];
        $this->turn = false;
        $lines = Str\split($input, "\n");
        $count = 0;
        $new = 0;
        $flipped = 0;
        foreach($lines as $line) {
            $x = 0; 
            $y = 0;
            for($i = 0; $i < Str\length($line); $i++) {
                switch($line[$i]) {
                    case 'w':
                        $x-=2;
                        break;
                    case 'e':
                        $x+=2;
                        break;
                    case 's':
                        $i++;
                        $y--;
                        $x+= ($line[$i] === 'w' ? -1 : 1);
                        break;
                    case 'n':
                        $i++;
                        $y++;
                        $x+= ($line[$i] === 'w' ? -1 : 1);
                        break;
                }   
            }
            //print("x: ".$x." , y: ".$y."\n");
            $hash = $this->hash($x,$y);
            if (C\contains_key($this->tiles, $hash)) {
                $count+=($this->tiles[$hash] ? -1 : 1);
                $this->tiles[$hash] = tuple(!$this->tiles[$hash][0], !$this->tiles[$hash][1]);
                $flipped++;
            } else {
                $this->tiles[$hash] = tuple(true, true);
                $count++;
                $new++;
            }
        }

        print("new: ".$new." , flipped: ".$flipped."\n");

        foreach($this->tiles as $k => $v) {
            $coord = $this->hashToCo($k);
            foreach($this->neigh as $n) {
                $x = $coord[0] + $n[0];
                $y = $coord[1] + $n[1];
                $hash = $this->hash($x, $y);
                if (!C\contains_key($this->tiles, $hash)) {
                    $this->tiles[$hash] = tuple(false, false);
                }
            }
        }

        for($i = 1; $i <= 100; $i++) {
            $count = $this->turn();
            print("Day: ".$i.", blacks: ".$count."\n");
        }

        //363 is wrong
        return "".$count;
    }

    public function turn(): int {
        $count = 0;
        $this->turn = !$this->turn;
        $index = $this->turn ? 0 : 1;
        $set_index = $this->turn ? 1 : 0;
        foreach($this->tiles as $k => $v) {
            $coord = $this->hashToCo($k);
            $blacks = 0;
            foreach($this->neigh as $n) {
                $x = $coord[0] + $n[0];
                $y = $coord[1] + $n[1];
                $hash = $this->hash($x, $y);
                if (C\contains_key($this->tiles, $hash)) {
                    $blacks += ($this->tiles[$hash][$index] ? 1 : 0);
                } else {
                    $this->tiles[$hash] = tuple(false, false);
                }
            }
            if ($v[$index]) {
                if ($blacks === 0 || $blacks > 2){
                    $this->tiles[$k] = $this->turn ? tuple(true, false) : tuple(false, true);
                } else {
                    $this->tiles[$k] = tuple(true, true);
                    $count++;
                }
            } else {
                if ($blacks === 2) {
                    $this->tiles[$k] = $this->turn ? tuple(false, true) : tuple(true, false);
                    $count++;
                } else {
                    $this->tiles[$k] = tuple(false, false);
                }
            }
        }
        return $count;
    }

    public function hashToCo(string $hash): Coord {
        $parts = Str\split($hash, '|');
        return tuple(Str\to_int($parts[0]), Str\to_int($parts[1]));
    }

    public function hash(int $x, int $y): string {
        return $x."|".$y;
    }

}
