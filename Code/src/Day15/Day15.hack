namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Numbers = (int, ?int);

final class Day15 {
    use UtilsTrait;

    public $nums = dict<int, Numbers>[];

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
0,3,6
EOD;
$sample2 = "1,3,2";
$sample3 = "2,1,3";
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
        
        $this->nums = dict<int, Numbers>[];
        $lines = Str\split($lines[0], ',');
        $last_num = 0;
        foreach($lines as $line) {
            $last_num = Str\to_int($line);
            $this->nums[$last_num] = tuple($count,null);

            $count++;
        }
        
        //part 1
        $limit = 2020;
        //part 2
        $limit = 30000000
        for(;$count<$limit;$count++) {            
            $entry = $this->nums[$last_num];
            //print($last_num." => ".$entry[0]." ".$entry[1]."\n");
            if ($entry[1] is nonnull) {
                $last_num = $entry[1] - $entry[0];
            } else {
                $last_num = 0;
            }
            $this->addNumber($last_num, $count);
            //print($last_num."\n");
        }
        print("last num: ".$last_num."\n");
        //7 is wrong
        return "".$count;
    }

    public function addNumber(int $number, $count): void {
        if (!C\contains_key($this->nums, $number)) {
            $this->nums[$number] = tuple($count, null);
        } else {
            $entry = $this->nums[$number];
            if ($entry[1] is null) {
                $this->nums[$number] = tuple($entry[0], $count);
            } else {
                $this->nums[$number] = tuple($entry[1], $count);
            }
        }
    }
    
}
