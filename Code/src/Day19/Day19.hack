namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Cell = (int, int);
newtype Rule = (?string, vec<int>, vec<int>);

final class Day19 {
    use UtilsTrait;

    public $rules = dict<int, Rule>[];
    public $odd = true;
    public $max_len = 0;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = null;
// <<<EOD
// 42: 9 14 | 10 1
// 9: 14 27 | 1 26
// 10: 23 14 | 28 1
// 1: "a"
// 11: 42 31
// 5: 1 14 | 15 1
// 19: 14 1 | 14 14
// 12: 24 14 | 19 1
// 16: 15 1 | 14 14
// 31: 14 17 | 1 13
// 6: 14 14 | 1 14
// 2: 1 24 | 14 4
// 0: 8 11
// 13: 14 3 | 1 12
// 15: 1 | 14
// 17: 14 2 | 1 7
// 23: 25 1 | 22 14
// 28: 16 1
// 4: 1 1
// 20: 14 14 | 1 15
// 3: 5 14 | 16 1
// 27: 1 6 | 14 18
// 14: "b"
// 21: 14 1 | 1 14
// 25: 1 1 | 1 14
// 22: 14 14
// 8: 42
// 26: 14 22 | 1 20
// 18: 15 15
// 7: 14 5 | 1 21
// 24: 14 1

// abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
// bbabbbbaabaabba
// babbbbaabbbbbabbbbbbaabaaabaaa
// aaabbbbbbaaaabaababaabababbabaaabbababababaaa
// bbbbbbbaaaabbbbaaabbabaaa
// bbbababbbbaaaaaaaabbababaaababaabab
// ababaaaaaabaaab
// ababaaaaabbbaba
// baabbaaaabbaaaababbaababb
// abbbbabbbbaaaababbbbbbaaaababb
// aaaaabbaabaaaaababaa
// aaaabbaaaabbaaa
// aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
// babaaabbbaaabaababbaabababaaab
// aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
// EOD;
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
        $this->map = dict<string, Cell>[];
        $lines = Str\split($input, "\n");
        $sum = 0;
        $count = 0;
        $section = 1;
        $this->rules = dict<int, Rule>[];
        $valid = keyset[];
        $valid42 = keyset[];
        $valid31 = keyset[];

        $part2_size = 8;
        foreach($lines as $line) {
            if($line === '') {
                $section = 2;
                $rule_results = $this->evaluateRule(0);
                foreach($rule_results as $r) {
                    if (!C\contains_key($valid, $r)) {
                        $valid[] = $r;
                    }
                }

                print("42:\n");
                $rule42 = $this->evaluateRule(42);
                $valid42 = keyset($rule42);

                foreach($this->evaluateRule(42) as $out42) {
                    $part2_size = Str\length($out42);
                    print($out42."\n");
                }
                print("31:\n");
                $rule31 = $this->evaluateRule(31);
                $valid31 = keyset($rule31);
                foreach($this->evaluateRule(31) as $out31) {
                    print($out31."\n");
                }
                print(C\count($this->rules)."\n");
            } else {
                switch($section){
                    case 1:
                        $parts = Str\split($line, ': ');
                        $rule_num = Str\to_int($parts[0]);
                        if ($parts[1][0] === '"') {
                            $this->rules[$rule_num] = tuple($parts[1][1], vec[], vec[]);
                        } else {
                            $parts = Str\split($parts[1], ' | ');
                            $part1 = $parts[0];
                            $subrules1 = Vec\map(Str\split($part1, ' '), $s ==> Str\to_int($s));
                            if (C\count($parts) === 2) {
                                $part2 = $parts[1];
                                $subrules2 = Vec\map(Str\split($part2, ' '), $s ==> Str\to_int($s));
                                $this->rules[$rule_num] = tuple(null, $subrules1, $subrules2);
                            } else {
                                $this->rules[$rule_num] = tuple(null, $subrules1, vec[]);
                            }
                        }
                        break;
                    case 2:
                        $length = Str\length($line);
                        if (C\contains_key($valid, $line)) {
                            print("valid: ".$line."\n");
                            $count++;
                        } else if ($length % $part2_size === 0) {
                            $val42 = false;
                            $val31 = false;
                            $count42 = 0;
                            $count31 = 0;
                            for($i = 0; $i < $length; $i+=$part2_size) {
                                if (C\contains_key($valid42, Str\slice($line, $i, $part2_size)) && !$val31) {
                                    $count42++;
                                    $val42 = true;
                                } else if (
                                        !C\contains_key($valid42, Str\slice($line, $i, $part2_size)) 
                                        && !$val31
                                        && C\contains_key($valid31, Str\slice($line, $i, $part2_size))
                                    ) {
                                    $count31++;
                                    $val31 = true;
                                } else if ($val31 && C\contains_key($valid31, Str\slice($line, $i, $part2_size))) {
                                    $count31++;
                                } else {
                                    $val31 = false;
                                    break;
                                }
                            }

                            if ($val42 && $val31 && $count42 > $count31) {
                                print("valid31: ".$line."\n");
                                $count++;
                            }
                            
                        }
                        break;
                }
            }
        }
        
        //425 is too high
        //401 is too high
        
        return "".$count;
    }
    public $recursion_depth = 0;
    <<__Memoize>>
    public function evaluateRule(int $index): vec<string> {
        $rule = $this->rules[$index];
        if ($rule[0] is nonnull) {
            return vec[$rule[0]];
        }

        $result = $this->evaluateRule($rule[1][0]);
        for($i = 1; $i < C\count($rule[1]); $i++) {
            if ($index === $rule[1][$i]) {
                $this->recursion_depth++;
            }
            if ($this->recursion_depth < 1) {
                $result = $this->descartes($result, $this->evaluateRule($rule[1][$i]));
            } else {
                $this->recursion_depth = 0;
            }
        }

        $result2 = vec[];
        if (C\count($rule[2]) > 0) {
            $result2 = $this->evaluateRule($rule[2][0]);
            for($i = 1; $i < C\count($rule[2]); $i++) {
                if ($index === $rule[2][$i]) {
                    $this->recursion_depth++;
                }
                if ($this->recursion_depth < 1) {
                    $result2 = $this->descartes($result2, $this->evaluateRule($rule[2][$i]));
                } else {
                    $this->recursion_depth = 0;
                }
            }
        }

        return Vec\unique(Vec\concat($result, $result2));
    }

    public function descartes(vec<string> $v1, vec<string> $v2): vec<string> {
        $result = vec[];
        foreach($v1 as $a) {
            foreach($v2 as $b) {
                $result[] = $a.$b;
            }
        }
        return $result;
    }
    
}
