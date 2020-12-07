namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

final class Day6 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
abc

a
b
c

ab
ac

a
a
a
a

b

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
        $keyset = keyset<string>[];
        $is_new_group = true;
        foreach($lines as $line) {
            $current = keyset<string>[];
            if (Str\is_empty($line)){
                $count += C\count($keyset);
                print("".C\count($keyset)."\n");
                $keyset = keyset<string>[];
                $is_new_group = true;
            } else {
                for($i = 0; $i < Str\length($line); $i++) {
                    if(!C\contains_key($current, $line[$i])) {
                        $current[] = $line[$i];
                    }
                }
                if ($is_new_group) {
                    $keyset = keyset($current);
                } else {
                    $keyset = Keyset\intersect($keyset, $current);
                }
                $is_new_group = false;
            }
        }

        
        
        return "".$count;
    }

    
}