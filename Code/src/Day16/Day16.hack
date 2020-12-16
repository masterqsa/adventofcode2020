namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Range = (int, int, int, int);

final class Day16 {
    use UtilsTrait;

    public $rules = dict<string, Range>[];

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
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

        
        
        //rules
        for($i = 0; $i < C\count($lines); $i++) {
            $line = $lines[$i];
            if ($line === "") {
                $i++;
                break;
            }
            $parts = Str\split($line, ': ');
            $field = $parts[0];

            $parts = Str\split($parts[1], ' or ');
            $range1 = Str\split($parts[0], '-');
            $range2 = Str\split($parts[1], '-');

            $this->rules[$field] = tuple(Str\to_int($range1[0]),Str\to_int($range1[1]),Str\to_int($range2[0]),Str\to_int($range2[1]));
            print("rule: ".$this->rules[$field][0]." ".$this->rules[$field][1]." ".$this->rules[$field][2]." ".$this->rules[$field][3]."\n");
        }

        $ticket = vec[];
        //my ticket
        for(; $i < C\count($lines); $i++) {
            $line = $lines[$i];
            if ($line === "") {
                $i++;
                break;
            }
            
            $parts = Str\split($line, ',');
            if (C\count($parts) > 1) {
                foreach($parts as $part) {
                    $ticket[] = Str\to_int($part);
                }
                print($line."\n");
            }
        }

        $tickets = vec<vec<int>>[];
        //other tickets
        for(;$i < C\count($lines); $i++) {
            $line = $lines[$i];
            $parts = Str\split($line, ',');
            if (C\count($parts) > 1) {
                $t = vec<int>[];
                foreach($parts as $part) {
                    $t[] = Str\to_int($part);
                }
                $tickets[] = $t;
                $count++;
            }
            
        }

        $sum = 0;
        $valid_tickets = vec<vec<int>>[];
        foreach($tickets as $t) {
            $err = $this->isValid($t);
            $sum += $err;
            if ($err === 0) {
                $valid_tickets[] = $t;
            }
        }
    
        print("part 1 sum = ".$sum."\n");

        $matches = dict<string, keyset<int>>[];
        foreach($this->rules as $field=>$rule){
            $matches[$field] = keyset<int>[];
            for($i = 0; $i < C\count($ticket); $i++) {
                $valid = true;
                foreach($valid_tickets as $t){
                    $val = $t[$i];
                    if ($val < $rule[0] || ($val > $rule[1] && $val < $rule[2]) || $val > $rule[3]) {
                        $valid = false;
                        break;
                    } 
                }
                if ($valid) {
                    $matches[$field][] = $i;
                }
            }
        }

        $result = dict<string, int>[];
        $done = keyset[];
        for($i = 0; $i < C\count($this->rules); $i++) {
            foreach($matches as $field => $m) {
                if (!C\contains_key($done, $field)) {
                    if (C\count($m) === 1) {
                        $done[] = $field;
                        $value = vec($m)[0];
                        $result[$field] = $value;
                        foreach($matches as $k => $v) {
                            if (!C\contains_key($done, $k)) {
                                unset($matches[$k][$value]);
                            }
                        }
                    }
                }
            }
        }

        $mult = 1;
        foreach($this->rules as $field => $rule) {
            if (Str\starts_with($field, 'departure')) {
                $mult *= $ticket[$result[$field]];
            }
        }

        print('Product = '.$mult."\n");

        return "".$count;
    }
    
    public function isValid(vec<int> $ticket): int {
        foreach($ticket as $val) {
            $valid = false;
            foreach($this->rules as $rule) {
                if (!($val < $rule[0] || ($val > $rule[1] && $val < $rule[2]) || $val > $rule[3])) {
                    $valid = true;
                } 
            }
            if (!$valid) {
                print("invalid: ".$val." rule ".$rule[0]."\n");
                return $val;
            }
        }
        return 0;
    }
}
