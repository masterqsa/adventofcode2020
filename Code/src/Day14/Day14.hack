namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Dir = (int, int);

final class Day14 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
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

        $mem = dict[];

        $size = 36;
        $mask_or = 0;
        $mask_neg = 0;
        $mask_and = (1 << 36) - 1;
        print("start mask_and = ".$mask_and.", mask_or = ".$mask_or."\n");
        foreach($lines as $line) {
            $parts = Str\split($line, ' = ');
            //part 1
            // if($parts[0] === 'mask'){
            //     $mask_or = 0;
            //     $mask_and = (1 << 36) - 1;
            //     $val = $parts[1];
            //     $len = Str\length($val);
            //     for($i = 0; $i < $len; $i++){
            //         if($val[$i]==='0') {
            //             $mask_and = $mask_and ^ (1 << ($len - $i - 1));
            //         } else if ($val[$i]==='1') {
            //             $mask_or = $mask_or | (1 << ($len - $i - 1));
            //         }
            //     }
            //     print("mask_and = ".$mask_and.", mask_or = ".$mask_or."\n");
            // } else {
            //     $val = Str\to_int($parts[1]);
            //     $parts = Str\split(Str\replace($parts[0], ']', ''), '[');
            //     $addr = Str\to_int($parts[1]);
            //     $new_val = ($val & $mask_and) | $mask_or;
            //     print("addr = ".$addr.", val = ".$val.", new_val = ".$new_val."\n");
            //     $mem[$addr] = $new_val;
            // }

            //part 2
            if($parts[0] === 'mask'){
                $mask_or = 0;
                $mask_neg = (1 << 36) - 1;
                $mask_and = 0;
                $val = $parts[1];
                $len = Str\length($val);
                for($i = 0; $i < $len; $i++){
                    if($val[$i]==='X') {
                        $mask_neg = $mask_neg ^ (1 << ($len - $i - 1));
                        $mask_and = $mask_and | (1 << ($len - $i - 1));
                    } else if ($val[$i]==='1') {
                        $mask_or = $mask_or | (1 << ($len - $i - 1));
                    }
                }
                //print("mask_and = ".$mask_and.", mask_or = ".$mask_or."\n");
            } else {
                $val = Str\to_int($parts[1]);
                $parts = Str\split(Str\replace($parts[0], ']', ''), '[');
                $addr = Str\to_int($parts[1]);
                $new_addr = ($addr | $mask_or) & $mask_neg;
                //print("addr = ".$addr.", val = ".$val."\n");
                $addrs = self::getAddresses($new_addr, $mask_and);
                foreach ($addrs as $a) {
                    $mem[$a] = $val;
                }
            }
        }
        
        foreach($mem as $val) {
            $count += $val;
        }

        return "".$count;
    }

    public function getAddresses(int $addr, int $mask): keyset<int> {
        //print('get addresses for '.$addr.' with mask '.$mask."\n");
        $addrs = keyset[$addr];
        for($i = 0; $i < 36; $i++) {
            $pos = 1 << $i;
            if (($mask & $pos) === $pos) {
                foreach($addrs as $a) {
                    $addrs[] = $a | (1 << $i);
                }
            }
        }
        print('get addresses for '.$addr.' with mask '.$mask.' count = '.C\count($addrs)."\n");
        return $addrs;
    }

    
}
