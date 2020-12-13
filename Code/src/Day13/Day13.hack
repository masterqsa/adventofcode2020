namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Dir = (int, int);

final class Day13 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 =  <<<EOD
939
7,13,x,x,59,x,31,19
EOD;
$sample2 = <<<EOD
10
17,x,13,19
EOD;
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

        //part 1
        // $time = Str\to_int($lines[0]);
        // $buses = Str\split($lines[1],',')
        //     |> Vec\filter($$, $x ==> $x !== 'x')
        //     |> Vec\map($$, $x ==> Str\to_int($x));

        // $min = 1000000;
        // $best_id = 0;
        // foreach($buses as $bus) {
        //     $rem = $bus - ($time% $bus);
        //     print($rem."\n");
        //     if ($rem < $min) {
        //         $min = $rem;
        //         $best_id = $bus;
        //     }
        // }
        
        // print($min." ".$best_id."\n");
        // print(($min * $best_id)." **\n");

        //part 2
        $buses = dict<int, int>[];
        $count = 0;
        $buses_str = Str\split($lines[1],',');
        foreach($buses_str as $b){
            if ($b !== 'x') {
                $bus = Str\to_int($b);
                $buses[$count] = $bus;
            }
            $count++;
        }
        print(C\count($buses)."\n");
        // solving using chinese remainder theorem 
        $m = 1;
        foreach($buses as $k => $b){
            print($k." bus ".$b."\n");
            $m *= $b;
        }

        // print("gcd(10,15) = ".self::eucledian_alg_gcd(10,15)[0]."\n");
        // print("mod_inv(2312,13) = ".self::mod_inv(2312,13)."\n");
        // print("mod_inv(451763,7) = ".self::mod_inv(451763,7)."\n");
        // print("mod_inv(53599,59) = ".self::mod_inv(53599,59)."\n");
        // print("mod_inv(111342072473963,13) = ".self::mod_inv(111342072473963,13)."\n");
        print("m = ".$m."\n");
        $x = 0;
        foreach($buses as $k => $b){
            $mi = $m / $b;
            print("mi = ".$mi."\n");
            $mi1 = self::mod_inv($mi, $b);
            print("k = ".$k.", mi1 = ".$mi1." ,ai = ".$b."\n");
            $x += (($b - $k) * $mi * $mi1);
        }

        print("x = ".$x % $m."\n");
        
        //552612234243498 - right answer
        return "".$count;
    }

    public function checkValid(dict<int, int> $buses, int $number): bool {
        foreach($buses as $k => $b){
            if (($number + $k) % $b !== 0) {
                return false;
            }
        }
        return true;
    }

    public function eucledian_alg_gcd(int $a, int $b): (int, int, int) {
        if ($b === 0){
            return tuple($a, 1, 0);
        }
        $x = self::eucledian_alg_gcd($b, $a % $b);
        return tuple($x[0], $x[2], $x[1] - Math\floor($a  / $b) * $x[2]);
    }
    
    public function mod_inv(int $a, int $m): int {
        $euc = self::eucledian_alg_gcd($a, $m);
        if ($euc[0] === 1) {
            return ($euc[1] + $m) % $m; // adjusted to fight negative numbers, I'm at loss
        }
        return 0;
    }
}
