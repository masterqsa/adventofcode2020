namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec};

final class Day2 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();
        // $s2 = await $f->readAsync();
        // print($s);
        // print($s2);

$sample1 = <<<EOD
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
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
        //print(C\count($lines));
        foreach($lines as $line) {
            $parts = Str\split($line, " ");
            $policy = $parts[0];
            $policy_parts = Str\split($policy,"-");
            $policy_low = Str\to_int($policy_parts[0]);
            $policy_high = Str\to_int($policy_parts[1]);
            $char = $parts[1][0];
            $pass = $parts[2];

            if (self::isValid($pass, $char, $policy_low, $policy_high)) {
                $count += 1;
            }
            
        }

        
        return "".$count;
    }

    public static function isValid(
        string $pass,
        string $char,
        int $low,
        int $high
    ): bool {
        // $l = Str\length($pass);
        // //print($pass." ".$char);
        // $pass = Str\replace($pass, $char, "");
        // $n = $l - Str\length($pass);
        // //print(" ".$pass." ".$n."\n");
        // return $n >= $low && $n <= $high;

        //part 2
        if (Str\length($pass) < $low) {
            return false;
        }
        $first = $pass[$low-1] === $char;
        if (Str\length($pass) < $high) {
            return $first;
        }
        $second = $pass[$high-1] === $char;
        return ($first != $second);
    }
    

}