namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec};

final class Day1 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAsync();

$sample1 = <<<EOD
1721
979
366
299
675
1456
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
        $d = dict[];
        $vals = vec[];
        $lines = Str\split($input, "\n");
        foreach($lines as $line) {
            $i = Str\to_int($line);
            $vals[] = $i;
            // if (C\contains_key($d, 2020-$i)) {
            //     return "".($i*(2020-$i));
            // }
            // $d[$i] = $i;
            $d[2020-$i] = $i;
        }

        foreach(Vec\keys($d) as $partial) {
            $dd = dict[];
            foreach($vals as $i){
                if (C\contains_key($dd, $partial-$i)) {
                    return "".($i*($partial-$i)*$d[$partial]);
                }
                $dd[$i] = $i;
            }
        }
        return $input;
    }

    

}