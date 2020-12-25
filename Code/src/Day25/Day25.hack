namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Tile = (bool, bool); 
newtype Coord = (int, int);

final class Day25 {
    use UtilsTrait;

    public $tiles = dict<string, Tile>[];

    public $neigh = vec[tuple(2, 0), tuple(-2, 0), tuple(-1, 1), tuple(1,1), tuple(-1, -1), tuple(1, -1)];

    public $turn = false;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
5764801
17807724
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
        
        $card_public = Str\to_int($lines[0]);
        $door_public = Str\to_int($lines[1]);

        $card_loop = $this->findLoop($card_public);
        $door_loop = $this->findLoop($door_public);

        print($card_loop." , ".$door_loop."\n");

        print($this->transform($door_public,$card_loop)."\n");
        
        return "".$count;
    }

    public function transform(int $subject_number, int $loop_size): int {
        $val = 1;
        for($i = 0; $i < $loop_size; $i++) {
            $val = ($val * $subject_number) % 20201227;
        }
        return $val;
    }

    public function findLoop(int $public): int {
        $i = 0;
        $val = 1;
        $subject_number = 7;
        while($val !== $public) {
            $i++;
            $val = ($val * $subject_number) % 20201227;
        }
        return $i;
    }

}
